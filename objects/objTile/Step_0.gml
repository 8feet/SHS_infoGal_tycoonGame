/// @description Tile Occupancy Check System with safety checks

// ===== PERFORMANCE OPTIMIZATION =====
// Only check when any building is dragging
var any_dragging = false;
with (objBld_parent) {
    if (variable_instance_exists(id, "is_dragging") && is_dragging) {
        any_dragging = true;
    }
}

if (any_dragging) {
    // ===== OVERLAP-BASED OCCUPANCY CHECK =====
    // Check if this tile is occupied by any building
    var occupied = instance_place(x, y, objBld_parent);
    if (occupied != noone) {
        // Safety check: make sure occupied has the variables we need
        if (variable_instance_exists(occupied, "is_dragging") && occupied.is_dragging) {
            // This is the dragging building - show validity
            if (variable_instance_exists(occupied, "current_place_valid") && occupied.current_place_valid) {
                image_blend = c_lime; // Valid placement
            } else {
                image_blend = c_red;  // Invalid placement
            }
        } else {
            // Tile is occupied by another building - only show red if dragging building overlaps it
            var dragging_building = noone;
            with (objBld_parent) {
                if (variable_instance_exists(id, "is_dragging") && is_dragging) {
                    dragging_building = id;
                    break;
                }
            }
            
            // Check if the dragging building's mask overlaps this tile
            if (dragging_building != noone && instance_place(x, y, dragging_building) == dragging_building) {
                image_blend = c_red; // Invalid - dragging building overlaps occupied tile
            } else {
                image_blend = c_white; // Occupied but not overlapped - show normal
            }
        }
    } else {
        // Tile is empty
        image_blend = c_white; // Available
    }
} else {
    // ===== NO BUILDINGS DRAGGING =====
    image_blend = c_white; // Default state
}




