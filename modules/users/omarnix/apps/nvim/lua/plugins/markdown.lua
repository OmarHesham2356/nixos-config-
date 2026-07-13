return {
  {
    "arminveres/md-pdf.nvim",
    branch = "main",
    lazy = true,
    keys = {
      {
        "<leader>mp",
        function()
          local input_file = vim.api.nvim_buf_get_name(0)
          if input_file == "" or not input_file:match("%.md$") then
            vim.notify("Not a valid Markdown (.md) file", vim.log.levels.WARN)
            return
          end

          local output_file = input_file:gsub("%.md$", ".pdf")
          local header_file = vim.fn.tempname() .. ".tex"

          local header_content = [[
\usepackage{fontspec}
\usepackage{luacode}
\directlua{
  luaotfload.add_fallback("emojifallback", {"Noto Color Emoji:mode=harf;script=DFLT;"})
}
\setmainfont{DejaVu Sans}[RawFeature={fallback=emojifallback}]
]]
          vim.fn.writefile(vim.split(header_content, "\n", { plain = true }), header_file)

          local cmd = string.format(
            "pandoc '%s' -o '%s' --pdf-engine=lualatex -V mainfont='DejaVu Sans' -H '%s'",
            input_file, output_file, header_file
          )

          vim.notify("Compiling PDF with advanced Emoji support...", vim.log.levels.INFO)

          vim.fn.jobstart(cmd, {
            on_exit = function(_, exit_code)
              os.remove(header_file)
              if exit_code == 0 then
                vim.notify("PDF generated successfully!", vim.log.levels.INFO)
                vim.fn.jobstart({ "xdg-open", output_file })
              else
                vim.notify("PDF compilation failed. Check system packages.", vim.log.levels.ERROR)
              end
            end,
          })
        end,
        desc = "Markdown to PDF (Dynamic Emoji)",
      },
    },
  },
}
