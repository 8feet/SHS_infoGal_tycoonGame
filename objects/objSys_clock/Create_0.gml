/// objSys_clock → Create  (0..100 clock + day counter, custom hotkeys)

// -------- Tunables --------
base_hz = 10;                 // fast-tick rate at Normal (ticks/sec)
ticks_per_day_base = 300;     // ticks at Normal to complete 0→100
mode = 2;                     // start at Normal

// -------- Internal state --------
accum_fast   = 0;
clock_pct    = 0;             // 0..100
day_count    = 1;
last_day     = day_count;

//---------- Animation speed--------
global.anim_mul = 1;   // 1× at Normal

// --- Optional: cap anim speed in Dev so it stays readable
anim_dev_cap = 3;   // anim ×3 max in Dev (tweak or remove if you want full speed)

// --- Convenience: expose gameplay scale for subsystems (read-only)
global.gameplay_scale = 1; // set each Step


// Standalone clock system - no hard dependencies
// Listeners array can be configured by other systems
listeners = [];

// Method to register listeners dynamically
// Usage: with (objSys_clock) clock_register_listener(objYourSystem);

_time_prev = current_time / 1000;

// Percent gained per fast tick at Normal
pct_per_fast_tick = 100 / ticks_per_day_base;

// FPS cache (avoid using built-in name 'fps' anywhere)
gameFps = max(1, fps_real);

// Expose for UI/debug
global.clock_pct = clock_pct;
global.day_count = day_count;
global.time_mode = mode;

global.ticks_per_day_base = ticks_per_day_base; // lets managers convert “per day” to “per fast tick”


prev_mode = 2; // last non-pause speed to resume to (default Normal)

