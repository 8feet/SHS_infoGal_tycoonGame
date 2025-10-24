/// objSys_clock → Step  (NO HOTKEYS HERE)

// Standalone listener registration (built into Step event)
// Other systems can register by setting a global variable
if (variable_global_exists("clock_register_listener") && global.clock_register_listener != noone) {
    var listener_obj = global.clock_register_listener;
    global.clock_register_listener = noone; // Clear the request
    
    // Safety check
    if (instance_exists(listener_obj)) {
        // Check if already registered
        var already_registered = false;
        for (var i = 0; i < array_length(listeners); i++) {
            if (listeners[i] == listener_obj) {
                already_registered = true;
                break;
            }
        }
        
        // Add to listeners if not already registered
        if (!already_registered) {
            array_push(listeners, listener_obj);
            show_debug_message("Clock: Registered " + object_get_name(listener_obj) + " as listener");
        }
    }
}

// Cache FPS safely
gameFps = max(1, fps_real);

// Real dt and scale
var t_now = current_time / 1000;
var dt    = max(0, t_now - _time_prev);
_time_prev = t_now;

var scale;
switch (mode) {
    case 1: scale = 0; break;             // Pause
    case 2: scale = 1; break;             // Normal ×1
    case 3: scale = 4; break;             // "Double" ×4
    case 4: scale = 8; break;             // "Triple" ×8
    case 5: scale = gameFps / base_hz; break; // Dev: ~1 fast tick per frame
}

global.gameplay_scale = scale; // 0, 1, 4, 8, or fps/base_hz


// Gameplay scale (unchanged): used by the clock internally
//   mode: 1=Pause(0), 2=×1, 3=×4, 4=×8, 5=Dev (gameFps/base_hz)

// Animation scale (new mapping): 1,2,3,Dev
var anim_mul;
switch (mode) {
    case 1: anim_mul = 0;              break; // Pause
    case 2: anim_mul = 1;              break; // Normal
    case 3: anim_mul = 2;              break; // Gameplay ×4 → Anim ×2
    case 4: anim_mul = 3;              break; // Gameplay ×8 → Anim ×3
    case 5: anim_mul = min(scale, anim_dev_cap); break; // Dev: cap for readability
    default: anim_mul = 1;             break;
}
global.anim_mul = anim_mul;



// Accumulate fast ticks (fixed timestep)
accum_fast += dt * base_hz * scale;

// Spiral safety
var max_ticks_this_frame = 5;
var ticks_to_run = min(max_ticks_this_frame, floor(accum_fast));

// Run fast ticks and advance 0..100 meter
if (ticks_to_run > 0) {

    // FAST ticks → User Event 0 (standalone safety)
    for (var i = 0; i < array_length(listeners); i++) {
        if (instance_exists(listeners[i])) {
            with (listeners[i]) {
                repeat (ticks_to_run) event_user(0);
            }
        }
    }

    // Advance meter
    clock_pct += pct_per_fast_tick * ticks_to_run;

    // Day rollover(s)
    while (clock_pct >= 100) {
        clock_pct -= 100;	
        day_count += 1;

        // Day event → User Event 1 (standalone safety)
        for (var j = 0; j < array_length(listeners); j++) {
            if (instance_exists(listeners[j])) {
                with (listeners[j]) event_user(1);
            }
        }
    }

    accum_fast -= ticks_to_run;
}

// Globals for UI
global.clock_pct = clock_pct;
global.day_count = day_count;
global.time_mode = mode;
