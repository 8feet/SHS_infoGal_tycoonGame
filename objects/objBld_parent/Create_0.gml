/// @description Building Parent - Handles drag, placement, and employee docking
/// Once placed, buildings become immovable to prevent accidental dragging

// Basic drag system
is_dragging = false;
is_built = false; // Once true, building can't be moved anymore
hover_tile = noone; // Track which tile is being highlighted

// Employee tracking
docked_employees = ds_list_create(); // List of employees working here

// Stress system
stress_rate = 0.1; // Base stress per second while working (positive = stressful, negative = recovery)

// Global stress processing system
if (!variable_global_exists("stress_processing_index")) global.stress_processing_index = 0;
if (!variable_global_exists("stress_processing_batch")) {
    // Calculate processing rate based on FPS (25% of FPS, minimum 10 per second)
    var target_fps = max(30, fps_real);
    global.stress_processing_batch = max(1, floor(target_fps * 0.25));
}

// Figure out building size from sprite (0=free, 1=small, 2=medium, 3=large)
bld_size_type = 0;
if (sprite_index == sprBld_size1) bld_size_type = 1;
else if (sprite_index == sprBld_size2) bld_size_type = 2;
else if (sprite_index == sprBld_size3) bld_size_type = 3;

// Remember where we started (to snap back if placement fails)
drag_origin_x = x;
drag_origin_y = y;

// Building costs: free, 1000, 2000, 4000
bld_cost = 0;
if (bld_size_type == 1) bld_cost = 1000;
else if (bld_size_type == 2) bld_cost = 2000;
else if (bld_size_type == 3) bld_cost = 4000;

// Rally system - points to next room in chain
rally_output = noone;
rally_configured = false; // Set to true when rally is explicitly configured

// Work progress tracking
