# 🎯 CLOCK SYSTEM USAGE EXAMPLE

## **Quick Start Guide for New Projects**

Here's how to use the standalone clock system in a new project:

---

## **STEP 1: BASIC SETUP** 🚀

### **1. Copy the Clock System**
```
Copy: objects/objSys_clock/
Paste into your project's Objects folder
```

### **2. Add to Your Room**
```
Place objSys_clock in your room
That's it! The clock works immediately
```

---

## **STEP 2: TEST THE SYSTEM** ✅

### **Test Controls**
- **Space**: Pause/Resume
- **1**: Normal speed
- **2**: Double speed  
- **3**: Triple speed
- **4**: Dev mode

### **What You Should See**
- Clock display in top-left corner
- Day counter incrementing
- Clock percentage (0-100%)
- Speed mode indicator
- FPS and scaling info

---

## **STEP 3: REGISTER YOUR SYSTEMS** 📡

### **Example: Employee System**
```gml
// In objEmployee Create event:
global.clock_register_listener = id;

// In objEmployee User Event 0:
// This runs multiple times per frame based on game speed
// Update employee AI, movement, work, etc.

// In objEmployee User Event 1:
// This runs once per day
// Daily tasks, salary, rest, etc.
```

### **Example: Building System**
```gml
// In objBuilding Create event:
global.clock_register_listener = id;

// In objBuilding User Event 0:
// This runs multiple times per frame
// Production, maintenance, resource generation

// In objBuilding User Event 1:
// This runs once per day
// Daily building tasks, rent, etc.
```

### **Example: Economy System**
```gml
// In objEconomy Create event:
global.clock_register_listener = id;

// In objEconomy User Event 0:
// This runs multiple times per frame
// Update prices, handle transactions

// In objEconomy User Event 1:
// This runs once per day
// Daily economic calculations, market updates
```

---

## **STEP 4: ACCESS GLOBAL DATA** 🌐

### **Use Global Variables**
```gml
// Get current day progress (0-100)
var progress = global.clock_pct;

// Get total days elapsed
var days = global.day_count;

// Get current speed mode
var speed = global.time_mode;

// Get gameplay scale
var scale = global.gameplay_scale;

// Get animation scale
var anim_scale = global.anim_mul;
```

### **Example: UI Display**
```gml
// In your UI object's Draw event:
draw_text(10, 10, "Day: " + string(global.day_count));
draw_text(10, 30, "Progress: " + string(global.clock_pct) + "%");
draw_text(10, 50, "Speed: " + string(global.time_mode));
```

---

## **STEP 5: ADVANCED USAGE** 🔧

### **Custom Speed Modes**
```gml
// In objSys_clock Create event, you can modify:
mode = 2;                     // Starting mode
base_hz = 10;                 // Tick rate
ticks_per_day_base = 300;     // Ticks per day
```

### **Animation Scaling**
```gml
// The system automatically provides:
global.anim_mul       // For sprite animations
global.gameplay_scale // For gameplay logic
```

### **Event Timing**
```gml
// User Event 0: Fast ticks (multiple per frame)
// - Use for: AI updates, movement, work
// - Frequency: Based on game speed

// User Event 1: Day events (once per day)
// - Use for: Daily tasks, resources, maintenance
// - Frequency: Once when clock reaches 100%
```

---

## **COMPLETE EXAMPLE** 🎯

### **Simple Employee System**
```gml
// objEmployee Create event:
global.clock_register_listener = id;
stress = 0;
work_progress = 0;

// objEmployee User Event 0 (Fast ticks):
stress += 0.1; // Work increases stress
work_progress += 1; // Make progress on work

// objEmployee User Event 1 (Daily):
stress = max(0, stress - 50); // Rest reduces stress
work_progress = 0; // Reset work progress
```

### **Simple Building System**
```gml
// objBuilding Create event:
global.clock_register_listener = id;
production = 0;
resources = 0;

// objBuilding User Event 0 (Fast ticks):
production += 0.5; // Produce resources

// objBuilding User Event 1 (Daily):
resources += production; // Add to total resources
production = 0; // Reset production
```

---

## **TROUBLESHOOTING** 🔧

### **Common Issues**
1. **Clock not showing**: Make sure objSys_clock is in your room
2. **Events not firing**: Make sure you registered your object
3. **Performance issues**: Check that you're not doing too much in User Event 0

### **Debug Tips**
- Use `show_debug_message()` to see when events fire
- Check the clock display for current state
- Test different speed modes to verify timing

---

**The clock system is now ready to use in your project!** 🎉
