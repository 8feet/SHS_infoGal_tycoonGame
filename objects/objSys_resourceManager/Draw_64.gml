/// @description Resource Manager - Draw GUI Event
/// Money display positioned below the clock HUD
/// Draw GUI is camera-independent (not affected by zoom)

// ===== MONEY DISPLAY =====
// Position well below clock HUD to avoid any overlap issues
var x0 = 16, y0 = 140, w = 240, h = 40;

// Background panel (matching clock style)
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(x0-6, y0-6, x0+w+6, y0+h+6, false);

// Reset alpha and color
draw_set_alpha(1);
draw_set_color(c_white);

// Money display
draw_text(x0, y0, "💰 Money: " + string(global.money));
draw_text(x0, y0+18, "🏗️ Buildings: " + string(global.buildings_placed));

// Optional: Show people count if you want it visible
// draw_text(x0, y0+36, "👥 People: " + string(global.people_count));



