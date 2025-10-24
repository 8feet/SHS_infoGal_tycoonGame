/// @description Global Resource Manager
/// Central hub for all game resources and statistics
/// Simple, dumb, and easy to find - everything is here

// ===== CORE RESOURCES =====
global.money = 5000;
global.people_count = 0;
global.buildings_placed = 0;

// ===== BUILDING COUNTS =====
// Track how many of each building type we have
global.count_hostel = 0;
global.count_butcher = 0;
global.count_dental = 0;
global.count_dog = 0;
global.count_grill = 0;
global.count_gun = 0;
global.count_head = 0;
global.count_kitchen = 0;
global.count_legs = 0;
global.count_office = 0;
global.count_rope = 0;
global.count_showroom = 0;
global.count_sMachine = 0;
global.count_stream = 0;
global.count_training = 0;
global.count_chest = 0;

// ===== GAME STATE =====
global.game_paused = false;
global.game_speed = 1.0; // 1.0 = normal speed

// ===== DEBUG INFO =====
show_debug_message("Resource Manager initialized - Money: " + string(global.money));










