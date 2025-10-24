/// @description Employee Step - Handle dragging, room assignment, and animation

// Safety checks
if (!variable_instance_exists(id,"dragging")) dragging = false;
if (!variable_instance_exists(id,"anim_acc")) anim_acc = 0;
if (!variable_instance_exists(id,"_last_sprite")) _last_sprite = sprite_index;
if (!variable_instance_exists(id,"anim_fps_normal")) anim_fps_normal = 6;
if (!variable_instance_exists(id,"just_assigned")) just_assigned = false;

// Start dragging
if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        dragging = true;
        original_x = x;
        original_y = y;
    }
}

// While dragging: follow mouse and freeze animation
if (dragging) {
    x = mouse_x; 
    y = mouse_y;
    image_speed = 0;
    image_index = 0;
}

// Release mouse - handle room assignment
if (mouse_check_button_released(mb_left) && dragging) {
    dragging = false;
    
    // Check if dropped over a built room (try objBld_parent first, then objBld_lobby)
    var room_hit = instance_place(x, y, objBld_parent);
    if (room_hit == noone) {
        room_hit = instance_place(x, y, objBld_lobby);
    }
    
    // Check if lobby has is_built property (it should if standalone)
    var is_valid_drop = (room_hit != noone);
    if (room_hit != noone && variable_instance_exists(room_hit, "is_built")) {
        is_valid_drop = room_hit.is_built;
    }
    
    if (is_valid_drop) {
        // Snap to room's vertical center (keep X position)
        y = room_hit.y;
        
        // Handle room assignment
        if (room_hit != docked_room) {
            // Different room - change assignment
            if (docked_room != noone && instance_exists(docked_room)) {
                // Remove from old room
                if (variable_instance_exists(docked_room, "docked_employees")) {
                    var index = ds_list_find_index(docked_room.docked_employees, id);
                    if (index >= 0) ds_list_delete(docked_room.docked_employees, index);
                }
            }
            
            // Add to new room
            docked_room = room_hit;
            workProgress = 0;  // Reset work progress when changing rooms
            last_work_update = current_time;  // Reset time tracker to prevent accumulated time boost
            if (variable_instance_exists(room_hit, "docked_employees")) {
                ds_list_add(room_hit.docked_employees, id);
            } else {
                room_hit.docked_employees = ds_list_create();
                ds_list_add(room_hit.docked_employees, id);
            }
            
            // Mark as just assigned so forced-to-lobby logic skips this frame
            just_assigned = true;
            
            show_debug_message("Employee assigned to room at " + string(x) + ", " + string(y));
        } else {
            // Same room - no change
            show_debug_message("Employee still at same room");
        }
    } else {
        // No room found - return to original position
        x = original_x;
        y = original_y;
        show_debug_message("Employee returned to original position");
    }
}

// Clear just_assigned flag (only lasts one frame)
if (just_assigned) {
    just_assigned = false;
}

// Check if employee should be forced to lobby
// Only check if not currently assigned to lobby and not just manually assigned
if (!dragging && docked_room != noone && instance_exists(docked_room) && !just_assigned) {
    var lobby = instance_find(objBld_lobby, 0);
    var should_go_to_lobby = false;
    var reason = "";
    
    // Don't re-trigger if already in lobby
    if (docked_room != lobby) {
        // Trigger 1: Room has no rally output (only if rally was explicitly configured)
        if (variable_instance_exists(docked_room, "rally_configured") && docked_room.rally_configured && 
            variable_instance_exists(docked_room, "rally_output") && docked_room.rally_output == noone) {
            should_go_to_lobby = true;
            reason = "no rally output";
        }
        
        // Trigger 2: Work progress complete (100%) - check EMPLOYEE's workProgress
        if (workProgress >= 100) {
            should_go_to_lobby = true;
            reason = "work complete";
        }
    }
    
    // If should go to lobby, send them there
    if (should_go_to_lobby && lobby != noone) {
        // Remove from old room
        if (variable_instance_exists(docked_room, "docked_employees")) {
            var old_index = ds_list_find_index(docked_room.docked_employees, id);
            if (old_index >= 0) ds_list_delete(docked_room.docked_employees, old_index);
        }
        
        // Teleport to lobby with random X within sprite width
        var lobby_left = lobby.x - (lobby.sprite_width / 2);
        var lobby_right = lobby.x + (lobby.sprite_width / 2);
        x = random_range(lobby_left, lobby_right);
        y = lobby.y;
        
        // Assign to lobby
        docked_room = lobby;
        workProgress = 0;  // Reset work progress when sent to lobby
        last_work_update = current_time;  // Reset time tracker
        if (variable_instance_exists(lobby, "docked_employees")) {
            ds_list_add(lobby.docked_employees, id);
        }
        
        show_debug_message("Employee sent to lobby (" + reason + ")");
    }
}

// Trigger: docked_room became invalid (building demolished)
if (!dragging && docked_room != noone && !instance_exists(docked_room)) {
    var lobby = instance_find(objBld_lobby, 0);
    if (lobby != noone) {
        // Teleport to lobby
        var lobby_left = lobby.x - (lobby.sprite_width / 2);
        var lobby_right = lobby.x + (lobby.sprite_width / 2);
        x = random_range(lobby_left, lobby_right);
        y = lobby.y;
        
        // Assign to lobby
        docked_room = lobby;
        workProgress = 0;  // Reset work progress when sent to lobby
        last_work_update = current_time;  // Reset time tracker
        if (variable_instance_exists(lobby, "docked_employees")) {
            ds_list_add(lobby.docked_employees, id);
        }
        
        show_debug_message("Employee sent to lobby (building demolished)");
    }
}

// Animation (not dragging)
if (!dragging) {
    image_speed = 0; // Manual animation control
    
    // Handle sprite changes
    if (sprite_index != _last_sprite) {
        _last_sprite = sprite_index;
        image_index = max(1, image_index);
        anim_acc = 0;
    }
    
    // Animate through frames (skip frame 0)
    if (image_number > 1) {
        if (image_index < 1) image_index = 1;
        
        var mul = variable_global_exists("anim_mul") ? global.anim_mul : 1;
        var advance = (anim_fps_normal * mul) / max(1, room_speed);
        
        anim_acc += advance;
        while (anim_acc >= 1) {
            image_index += 1;
            if (image_index >= image_number) image_index = 1;
            anim_acc -= 1;
        }
    } else {
        if (image_index < 1) image_index = 1;
    }
}




