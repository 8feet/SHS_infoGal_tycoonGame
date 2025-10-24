/// objSys_clock → Draw GUI

var label, scale_vis;
switch (mode) {
    case 1: label = "⏸ Pause (Space resumes)"; scale_vis = 0;                break;
    case 2: label = "▶ Normal (1 / Space pauses)"; scale_vis = 1;            break;
    case 3: label = "⏩ Double (2)";                   scale_vis = 4;             break;
    case 4: label = "⏭ Triple (3)";                   scale_vis = 8;             break;
    case 5: label = "🧪 Dev (4)";                  scale_vis = gameFps/base_hz; break;
    default:label = "▶ Normal";                    scale_vis = 1;             break;
}

// Layout
var x0=16, y0=16, w=240, h=72;
draw_set_alpha(0.7); draw_set_color(c_black);
draw_rectangle(x0-6, y0-6, x0+w+6, y0+h+38, false);
draw_set_alpha(1); draw_set_color(c_white);

// Lines
draw_text(x0, y0,    "Mode: " + label);
draw_text(x0, y0+18, "Day: " + string(day_count));
draw_text(x0, y0+36, "Clock: " + string_format(clock_pct, 0, 1) + " / 100   (fast≈ " + string_format(base_hz*scale_vis, 0, 1) + " Hz)");
draw_text(x0, y0+54, "FPS: " + string(gameFps) +
                     "   Anim×: " + string_format(global.anim_mul, 0, 2) +
                     "   Play×: " + string_format(global.gameplay_scale, 0, 2));


// Progress bar
var bar_w = 200, bar_h = 10;
var pct01 = clamp(clock_pct / 100, 0, 1);
draw_set_color(make_colour_rgb(40,40,40));
draw_rectangle(x0, y0+72, x0+bar_w, y0+72+bar_h, false);
draw_set_color(c_lime);
draw_rectangle(x0, y0+72, x0 + floor(bar_w * pct01), y0+72+bar_h, false);
