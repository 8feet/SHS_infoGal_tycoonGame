/// @description Resource Manager - Step Event
/// Simple resource updates and validation

// ===== RESOURCE VALIDATION =====
// Keep money from going negative (basic protection)
if (global.money < 0) global.money = 0;

// Keep people count from going negative
if (global.people_count < 0) global.people_count = 0;

// ===== DEBUG KEYS (REMOVE IN FINAL VERSION) =====
// F1 = Add 100 money (for testing)
if (keyboard_check_pressed(vk_f1)) {
    global.money += 100;
    show_debug_message("Money added: " + string(global.money));
}

// F2 = Add 10 people (for testing)
if (keyboard_check_pressed(vk_f2)) {
    global.people_count += 10;
    show_debug_message("People added: " + string(global.people_count));
}

// F3 = Show all resource counts
if (keyboard_check_pressed(vk_f3)) {
    show_debug_message("=== RESOURCE STATUS ===");
    show_debug_message("Money: " + string(global.money));
    show_debug_message("People: " + string(global.people_count));
    show_debug_message("Buildings Placed: " + string(global.buildings_placed));
}










