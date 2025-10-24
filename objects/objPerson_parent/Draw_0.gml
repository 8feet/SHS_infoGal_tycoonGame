// objPerson_employee's DRAW EVENT
// Skip frame 0 (idle pose) - always show frame 1 or higher

draw_set_alpha(1);
gpu_set_blendmode(bm_normal);
var col = variable_instance_exists(id,"tint_col") ? tint_col : c_white;
draw_set_color(col);

// Force skip frame 0 - show frame 1+ only
var draw_frame = max(1, image_index);
draw_sprite_ext(sprite_index, draw_frame, x, y, 1, 1, 0, col, 1);
