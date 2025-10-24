/// @description Lobby Create - Neutral holding area for unassigned employees

// Employee docking
docked_employees = ds_list_create();

// Lobby has NO stress effects (neutral zone)
stress_rate = -0.1;

// Lobby has NO work progression (neutral zone)
workProgress_rate = 0;  // ← ADD THIS!

// Lobby has no rally output (employees stay here until manually reassigned)
rally_output = noone;