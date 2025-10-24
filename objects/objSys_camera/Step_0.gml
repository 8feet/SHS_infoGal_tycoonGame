/// objSys_camera → Step  (drag-to-pan + MMB tween + wheel/QE zoom + WASD)

// ---------- LMB drag-to-pan on empty space (standalone drag detection) ----------
// Check if mouse is over any draggable objects (employees, buildings, etc.)
var over_drag_src = false;
if (instance_exists(objPerson_parent)) {
    over_drag_src = (instance_position(mouse_x, mouse_y, objPerson_parent) != noone);
}
if (instance_exists(objBld_parent)) {
    over_drag_src = over_drag_src || (instance_position(mouse_x, mouse_y, objBld_parent) != noone);
}

// Start panning only if: LMB pressed and not over any drag source
if (!panning && mouse_check_button_pressed(mb_left) && !over_drag_src) {
    panning = true;

    // screen-space anchor
    var px = view_get_xport(0), py = view_get_yport(0);
    pan_start_sx = window_mouse_get_x() - px;
    pan_start_sy = window_mouse_get_y() - py;

    // room-space view top-left
    pan_start_vx = camera_get_view_x(cam);
    pan_start_vy = camera_get_view_y(cam);
}

// While panning: move opposite to mouse delta, stop if release or a system drag begins
if (panning) {
    var px = view_get_xport(0), py = view_get_yport(0);
    var cur_sx = window_mouse_get_x() - px;
    var cur_sy = window_mouse_get_y() - py;

    var dsx = cur_sx - pan_start_sx;
    var dsy = cur_sy - pan_start_sy;

    var vw = camera_get_view_width(cam);
    var vh = camera_get_view_height(cam);
    var pw = view_get_wport(0);
    var ph = view_get_hport(0);

    var world_dx = dsx * (vw / pw);
    var world_dy = dsy * (vh / ph);

    var new_vx = pan_start_vx - world_dx;
    var new_vy = pan_start_vy - world_dy;

    var max_vx = max(0, room_width  - vw);
    var max_vy = max(0, room_height - vh);
    new_vx = clamp(new_vx, 0, max_vx);
    new_vy = clamp(new_vy, 0, max_vy);

    camera_set_view_pos(cam, new_vx, new_vy);

    if (mouse_check_button_released(mb_left)) {
        panning = false;
    }
}

// ---------- MMB toggle with animated zoom-to-cursor (single source of truth) ----------
if (mouse_check_button_pressed(mb_middle)) {
    // read current view
    var vx = camera_get_view_x(cam);
    var vy = camera_get_view_y(cam);
    var vw = camera_get_view_width(cam);
    var vh = camera_get_view_height(cam);

    // cursor’s relative pos inside current view
    z_relx = (mouse_x - vx) / vw;
    z_rely = (mouse_y - vy) / vh;

    // capture the world point under cursor at click time (fixed anchor)
    z_focus_x = vx + z_relx * vw;
    z_focus_y = vy + z_rely * vh;

	// decide target zoom using thresholds (feels natural)
	// 0.25 -> snap IN, 0.75 -> snap OUT, in-between -> nearest side
	var denom   = max(0.00001, zoom_max - zoom_min);
	var z_norm  = (zoom - zoom_min) / denom; // 0..1
	var low_t   = 0.25;
	var high_t  = 0.75;

z_from = zoom;
if (z_norm <= low_t) {
    z_to = zoom_max;            // mostly zoomed out → go all-in
} else if (z_norm >= high_t) {
    z_to = zoom_min;            // already zoomed in → go back out
} else {
    z_to = (z_norm < 0.5) ? zoom_max : zoom_min; // middle band → nearest side
}


    // start tween
    z_t0_ms  = current_time;
    z_active = (z_from != z_to);
}

// Cancel tween if manual zoom input happens (wheel/Q/E)
var _wheel_input = (mouse_wheel_up() - mouse_wheel_down()) != 0;
var _key_input   = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("Q"));
if (z_active && (_wheel_input || _key_input)) z_active = false;

// ---------- Zoom tween update OR normal zoom (mutually exclusive) ----------
if (z_active) {
    // Interpolate zoom with smoothstep easing
    var t  = clamp((current_time - z_t0_ms) / z_dur_ms, 0, 1);
    var e  = t * t * (3 - 2 * t);
    var zt = z_from + (z_to - z_from) * e;

    var vw = base_view_w / zt;
    var vh = base_view_h / zt;

    // keep original world focus fixed based on original rel fractions
    var new_vx = z_focus_x - z_relx * vw;
    var new_vy = z_focus_y - z_rely * vh;

    // clamp to room bounds
    var max_vx = max(0, room_width  - vw);
    var max_vy = max(0, room_height - vh);
    new_vx = clamp(new_vx, 0, max_vx);
    new_vy = clamp(new_vy, 0, max_vy);

    // apply
    camera_set_view_size(cam, vw, vh);
    camera_set_view_pos(cam, new_vx, new_vy);

    // sync state
    zoom = zt;
    camera_center_x = new_vx + vw * 0.5;
    camera_center_y = new_vy + vh * 0.5;

    if (t >= 1) z_active = false;

} else {
    // ---------- Normal wheel/QE zoom-to-cursor ----------
    var z_delta = 0;
    z_delta += mouse_wheel_up() - mouse_wheel_down();
    z_delta += keyboard_check(ord("E")) - keyboard_check(ord("Q"));

    if (z_delta != 0) {
        var old_vx = camera_get_view_x(cam);
        var old_vy = camera_get_view_y(cam);
        var old_vw = camera_get_view_width(cam);
        var old_vh = camera_get_view_height(cam);

        var relx = (mouse_x - old_vx) / old_vw;
        var rely = (mouse_y - old_vy) / old_vh;

        var old_zoom = zoom;
        zoom = clamp(zoom + zoom_step * z_delta, zoom_min, zoom_max);

        if (zoom != old_zoom) {
            var new_vw = base_view_w / zoom;
            var new_vh = base_view_h / zoom;

            var new_vx = mouse_x - relx * new_vw;
            var new_vy = mouse_y - rely * new_vh;

            var max_vx = max(0, room_width  - new_vw);
            var max_vy = max(0, room_height - new_vh);
            new_vx = clamp(new_vx, 0, max_vx);
            new_vy = clamp(new_vy, 0, max_vy);

            camera_set_view_size(cam, new_vw, new_vh);
            camera_set_view_pos(cam, new_vx, new_vy);
        }
    }
}

// ---------- WASD pan (screen-space consistent, Shift to boost) ----------
var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var v = keyboard_check(ord("S")) - keyboard_check(ord("W"));
if (h != 0 || v != 0) {
    if (h != 0 && v != 0) { var inv = 0.70710678; h *= inv; v *= inv; }

    var boost = keyboard_check(vk_shift) ? cam_pan_boost : 1;

    var vw = camera_get_view_width(cam);
    var vh = camera_get_view_height(cam);
    var pw = view_get_wport(0);
    var ph = view_get_hport(0);

    var screen_px = cam_pan_px * boost;
    var world_dx  = screen_px * (vw / pw) * h;
    var world_dy  = screen_px * (vh / ph) * v;

    var vx = camera_get_view_x(cam);
    var vy = camera_get_view_y(cam);

    var new_vx = vx + world_dx;
    var new_vy = vy + world_dy;

    var max_vx = max(0, room_width  - vw);
    var max_vy = max(0, room_height - vh);
    new_vx = clamp(new_vx, 0, max_vx);
    new_vy = clamp(new_vy, 0, max_vy);

    camera_set_view_pos(cam, new_vx, new_vy);
}
