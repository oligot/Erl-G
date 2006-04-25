#ifndef ERL_DEBUG_MODE_MACROS___
#define ERL_DEBUG_MODE_MACROS___

extern int debug_mode;

#define is_debug_mode_enabled debug_mode
#define disable_debug_mode debug_mode = 0
#define enable_debug_mode debug_mode = 1

#endif
