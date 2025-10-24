/// objSys_camera → Create  (minimal zoom-only setup)

// How fast to pan with WASD (pixels per step measured on the screen)
cam_pan_px = 16;
cam_pan_boost = 2.5; // WASD boost factor when holding Shift


// drag-to-pan state (screen-space anchor)
panning       = false;
pan_start_sx  = 0; // mouse screen X within viewport
pan_start_sy  = 0; // mouse screen Y within viewport
pan_start_vx  = 0; // camera view x at pan start (room-space)
pan_start_vy  = 0; // camera view y at pan start (room-space)



// --- Zoom tunables ---
zoom_step = 0.1;     // wheel/QE step size
zoom_max  = 5;     // how far IN you can zoom
zoom      = 1.0;     // starting zoom (this becomes the zoom-out floor)

// --- Zoom tween (MMB) ---
z_active   = false;
z_from     = 1.0;
z_to       = 1.0;
z_t0_ms    = 0;
z_dur_ms   = 150;   // 150ms feels nice
z_relx     = 0;
z_rely     = 0;
z_focus_x = 0;
z_focus_y = 0;



// Ensure view[0] exists (standalone safety)
if (!view_enabled) view_enabled = true;
if (!view_get_visible(0)) view_set_visible(0, true);

// Create a camera if none assigned (standalone camera creation)
cam = view_get_camera(0);	
if (cam == -1) {
    var port_w = display_get_width();
    var port_h = display_get_height();
    cam = camera_create_view(0, 0, port_w, port_h, 0, -1, -1, 0, 0, 0);
    view_set_camera(0, cam);
}

// Safety check - ensure camera is valid
if (cam == -1) {
    show_debug_message("Camera system failed to initialize!");
    instance_destroy();
    exit;
}

// Base (unscaled) view size we’ll scale by zoom
base_view_w = camera_get_view_width(cam);
base_view_h = camera_get_view_height(cam);

// Start centered
var cx = clamp(room_width  * 0.5, base_view_w * 0.5, room_width  - base_view_w * 0.5);
var cy = clamp(room_height * 0.5, base_view_h * 0.5, room_height - base_view_h * 0.5);

// Apply initial size/pos
camera_set_view_size(cam, base_view_w / zoom, base_view_h / zoom);
camera_set_view_pos(cam, cx - (base_view_w / zoom) * 0.5,
                         cy - (base_view_h / zoom) * 0.5);

// Lock the zoom-out floor to whatever we started at
zoom_min = zoom;
if (zoom_max < zoom_min) zoom_max = zoom_min;
