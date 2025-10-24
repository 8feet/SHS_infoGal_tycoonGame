/// @description Employee Parent - Handles dragging, animation, and room docking
/// Employees can be dragged to rooms where they snap vertically to center

// Basic drag system
dragging = false;
original_x = x;
original_y = y;

// Animation system (skip frame 0 - idle pose)
image_index = 1;
anim_fps_normal = 6; // frames per second
anim_acc = 0;
_last_sprite = sprite_index;

// Visual settings
tint_col = make_colour_rgb(255,255,255);

// Stress system
if (!variable_instance_exists(id,"stress")) stress = 0;
last_stress_update = current_time; // Track when stress was last updated

// Room docking
if (!variable_instance_exists(id,"docked_room")) docked_room = noone;

// Flag to prevent forced-to-lobby check on same frame as manual assignment
just_assigned = false;
