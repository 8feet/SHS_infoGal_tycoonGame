// objPerson_parent's DRAW GUI EVENT
// Show work progress bar (yellow, above) and stress bar (white, below) when hovering over employee
// Both bars only show when there's actual progress/stress (hidden when = 0)

if (!position_meeting(mouse_x, mouse_y, id)) exit;

// world→GUI (viewport 0)
var cam = view_get_camera(0);
var vx  = camera_get_view_x(cam), vy = camera_get_view_y(cam);
var vw  = camera_get_view_width(cam), vh = camera_get_view_height(cam);
var px  = view_get_xport(0),    py = view_get_yport(0);
var pw  = view_get_wport(0),    ph = view_get_hport(0);

// point above head
var wx = x;
var wy = bbox_top - 8;

// convert
var sx = px + ((wx - vx) / vw) * pw;
var sy = py + ((wy - vy) / vh) * ph;

// Bar setup
var barW = 90, barH = 10;
var _stress = variable_instance_exists(id, "stress") ? stress : 0;
var _work = variable_instance_exists(id, "workProgress") ? workProgress : 0;
var stress_pct = clamp(_stress / 100, 0, 1);
var work_pct = clamp(_work / 100, 0, 1);

draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

// ===== WORK PROGRESS BAR (Yellow, above) - Only show if there's active work =====
if (docked_room != noone && instance_exists(docked_room) && _work > 0) {
    // Background (black outline)
    draw_set_color(c_black);
    draw_rectangle(sx - barW/2, sy - barH*2, sx + barW/2, sy - barH, false);

    // Yellow work progress bar (grows horizontally from left to right)
    draw_set_color(c_yellow);
    var workWidth = floor((barW - 4) * work_pct);
    if (workWidth > 0) {
        draw_rectangle(sx - barW/2 + 2, sy - barH*2 + 2,
                       sx - barW/2 + 2 + workWidth, sy - barH - 2, false);
    }

    // Yellow outline
    draw_set_color(c_yellow);
    draw_rectangle(sx - barW/2, sy - barH*2, sx + barW/2, sy - barH, true);
}

// ===== STRESS BAR (White, below work progress) - Only show if there's actual stress =====
if (_stress > 0) {
    // Background (black outline)
    draw_set_color(c_black);
    draw_rectangle(sx - barW/2, sy - barH, sx + barW/2, sy, false);

    // White stress bar (grows horizontally from left to right)
    draw_set_color(c_white);
    var stressWidth = floor((barW - 4) * stress_pct);
    if (stressWidth > 0) {
        draw_rectangle(sx - barW/2 + 2, sy - barH + 2,
                       sx - barW/2 + 2 + stressWidth, sy - 2, false);
    }

    // White outline
    draw_set_color(c_white);
    draw_rectangle(sx - barW/2, sy - barH, sx + barW/2, sy, true);
}




