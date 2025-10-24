/// @description Building Step - Handle dragging, placement, and employee processing

// Start dragging (only if not built yet)
if (mouse_check_button_pressed(mb_left)) {
	if (instance_position(mouse_x, mouse_y, id) && !is_built) {
		is_dragging = true;
		drag_origin_x = x;
		drag_origin_y = y;
	}
}

// Clear tile highlights
if (hover_tile != noone) {
	with (hover_tile) { highlight = false; }
	hover_tile = noone;
}

// While dragging: follow mouse and show placement preview
if (is_dragging) {
	x = mouse_x;
	y = mouse_y;
	image_alpha = 0.75;
	
	// Detect tile under the object's mask
	var hit = instance_place(x, y, objTile);
	if (hit != noone) {
		hover_tile = hit;
		with (hover_tile) { highlight = true; }
	}

	// Check if we can afford this building
	var can_afford = true;
	if (variable_global_exists("money")) {
		can_afford = (global.money >= bld_cost);
	}
	
	// Check if placement is valid
	current_place_valid = false;
	snap_avg_x = x;
	snap_avg_y = y;
	var required_tiles = bld_size_type;
	
	if (required_tiles == 0) {
		current_place_valid = can_afford;
	} else {
		// Check tiles under building
		var tile_list = ds_list_create();
		collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, objTile, true, false, tile_list, false);
		var total = ds_list_size(tile_list);
		
		if (total == required_tiles) {
			var sample = tile_list[| 0];
			var bias = 0.45;
			var tol = sample.sprite_height * bias;
			var ref_y = (hover_tile != noone) ? hover_tile.y : sample.y;

			var used_count = 0;
			var sum_x = 0;
			var sum_y = 0;
			var all_tiles_empty = true;
			
			for (var i = 0; i < total; i++) {
				var t = tile_list[| i];
				if (abs(t.y - ref_y) <= tol) {
					used_count++;
					sum_x += t.x;
					sum_y += t.y;
					var occ_list = ds_list_create();
					collision_point_list(t.x, t.y, objBld_parent, true, true, occ_list, false);
					if (ds_list_size(occ_list) > 0) {
						all_tiles_empty = false;
					}
					ds_list_destroy(occ_list);
				}
			}

			if (used_count == required_tiles && all_tiles_empty && can_afford) {
				current_place_valid = true;
				snap_avg_x = sum_x / used_count;
				snap_avg_y = sum_y / used_count;
			}
		}
		ds_list_destroy(tile_list);
	}

	// Show valid (green) or invalid (red) placement
	if (required_tiles == 0) {
		image_blend = c_lime;
	} else {
		image_blend = current_place_valid ? c_lime : c_red;
	}
} else {
	// Not dragging - normal appearance
	image_alpha = 1;
	image_blend = c_white;
}

// Release mouse - place building or snap back
if (mouse_check_button_released(mb_left)) {
	if (is_dragging) {
		if (current_place_valid) {
			x = snap_avg_x;
			y = snap_avg_y;
			is_built = true;
			
			if (variable_global_exists("money")) {
				global.money -= bld_cost;
				global.buildings_placed++;
				show_debug_message("Building purchased for " + string(bld_cost) + " money. Remaining: " + string(global.money));
			}
		} else {
			x = drag_origin_x;
			y = drag_origin_y;
		}
	}
	is_dragging = false;
}

// Right-click to demolish building
if (mouse_check_button_pressed(mb_right)) {
	if (!is_dragging && instance_position(mouse_x, mouse_y, id)) {
		var demolish_cost = floor(bld_cost * 0.25);
		
		var can_demolish = true;
		if (variable_global_exists("money")) {
			can_demolish = (global.money >= demolish_cost);
		}
		
		if (can_demolish) {
			if (variable_global_exists("money")) {
				global.money -= demolish_cost;
				global.buildings_placed--;
				show_debug_message("Building demolished for " + string(demolish_cost) + " money. Remaining: " + string(global.money));
			}
			instance_destroy();
		} else {
			show_debug_message("Cannot demolish - need " + string(demolish_cost) + " money (have " + string(global.money) + ")");
		}
	}
}

// ===== STRESS PROCESSING SYSTEM =====
if (variable_global_exists("stress_processing_batch")) {
	var employees_processed = 0;
	var max_employees = global.stress_processing_batch;
	
	with (objPerson_parent) {
		if (employees_processed < max_employees) {
			var time_since_last_update = current_time - last_stress_update;
			var stress_to_add = 0;
			var clock_progression = (time_since_last_update / 1000) * global.gameplay_scale;
			
			if (docked_room != noone) {
				stress_to_add = docked_room.stress_rate * clock_progression;
			} else {
				stress_to_add = -0.1 * clock_progression;
			}
			
			stress += stress_to_add;
			last_stress_update = current_time;
			
			if (employees_processed < 3) {
				show_debug_message("Employee stress: " + string(stress) + " (rate: " + string(stress_to_add) + ")");
			}
			
			stress = clamp(stress, 0, 100);
			if (stress >= 100) {
				show_debug_message("Employee quit due to stress!");
				instance_destroy();
			}
			
			employees_processed++;
		}
	}
}

// ===== WORK PROGRESS PROCESSING SYSTEM =====
if (variable_global_exists("stress_processing_batch")) {
	var employees_processed = 0;
	var max_employees = global.stress_processing_batch;
	
	with (objPerson_parent) {
		if (employees_processed < max_employees) {
			// SAFETY CHECK: Initialize if missing (for employees created before this code)
			if (!variable_instance_exists(id, "last_work_update")) {
				last_work_update = current_time;
			}
			if (!variable_instance_exists(id, "workProgress")) {
				workProgress = 0;
			}
			
			// Only process if docked to a room
			if (docked_room != noone && instance_exists(docked_room)) {
				// SAFETY CHECK: Ensure docked_room has workProgress_rate
				if (!variable_instance_exists(docked_room, "workProgress_rate")) {
					docked_room.workProgress_rate = 1.0;
				}
				
				var time_since_last_update = current_time - last_work_update;
				var work_to_add = 0;
				var clock_progression = (time_since_last_update / 1000) * global.gameplay_scale;
				
				work_to_add = docked_room.workProgress_rate * clock_progression;
				workProgress += work_to_add;
				last_work_update = current_time;
				
				if (employees_processed < 3) {
					show_debug_message("Employee work: " + string(workProgress) + " (rate: " + string(work_to_add) + ")");
				}
				
				workProgress = clamp(workProgress, 0, 100);
			}
			
			employees_processed++;
		}
	}
}




