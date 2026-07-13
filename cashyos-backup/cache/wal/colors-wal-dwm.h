static const char norm_fg[] = "#c3c6c7";
static const char norm_bg[] = "#121112";
static const char norm_border[] = "#888a8b";

static const char sel_fg[] = "#c3c6c7";
static const char sel_bg[] = "#AD5E4A";
static const char sel_border[] = "#c3c6c7";

static const char urg_fg[] = "#c3c6c7";
static const char urg_bg[] = "#4F626A";
static const char urg_border[] = "#4F626A";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
