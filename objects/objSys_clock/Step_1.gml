// objSys_clock's BEGIN STEP EVENT

/// Capture hotkeys early; clear tick backlog when pausing or leaving Dev.

/// Space: toggle Pause <-> previous speed
if (keyboard_check_pressed(vk_space)) {
    if (mode != 1) {
        // Entering Pause: remember current mode and clear queued ticks
        prev_mode  = mode;
        mode       = 1;
        accum_fast = 0;  // <-- critical so time stops immediately
    } else {
        // Resuming: back to last non-pause (fallback to Normal)
        mode = (prev_mode == 1) ? 2 : prev_mode;
    }
}

/// '1' = Normal ×1
if (keyboard_check_pressed(ord("1"))) {
    if (mode == 5) accum_fast = 0; // leaving Dev: drop backlog
    mode = 2; prev_mode = 2;
}

/// '2' = ×4
if (keyboard_check_pressed(ord("2"))) {
    if (mode == 5) accum_fast = 0;
    mode = 3; prev_mode = 3;
}

/// '3' = ×8
if (keyboard_check_pressed(ord("3"))) {
    if (mode == 5) accum_fast = 0;
    mode = 4; prev_mode = 4;
}

/// '4' = Dev (fps speed)
if (keyboard_check_pressed(ord("4"))) {
    mode = 5; prev_mode = 5;
}
