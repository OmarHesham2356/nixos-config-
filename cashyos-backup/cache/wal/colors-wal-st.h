const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#121112", /* black   */
  [1] = "#4F626A", /* red     */
  [2] = "#AD5E4A", /* green   */
  [3] = "#EB9B77", /* yellow  */
  [4] = "#597984", /* blue    */
  [5] = "#837E81", /* magenta */
  [6] = "#6D8C93", /* cyan    */
  [7] = "#c3c6c7", /* white   */

  /* 8 bright colors */
  [8]  = "#888a8b",  /* black   */
  [9]  = "#4F626A",  /* red     */
  [10] = "#AD5E4A", /* green   */
  [11] = "#EB9B77", /* yellow  */
  [12] = "#597984", /* blue    */
  [13] = "#837E81", /* magenta */
  [14] = "#6D8C93", /* cyan    */
  [15] = "#c3c6c7", /* white   */

  /* special colors */
  [256] = "#121112", /* background */
  [257] = "#c3c6c7", /* foreground */
  [258] = "#c3c6c7",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
