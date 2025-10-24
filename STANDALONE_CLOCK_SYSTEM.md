# ⏰ STANDALONE CLOCK SYSTEM

## **PORTABLE TIME MANAGEMENT MODULE - READY TO EXTRACT**

This clock system is completely self-contained and provides advanced time management for any GameMaker Studio 2 project.

---

## **FEATURES** ✨

### **Time Management** ⏱️
- **0-100% Clock**: Visual progress through each day
- **Day Counter**: Tracks total days elapsed
- **Multiple Speed Modes**: Pause, Normal, 2x, 3x, Dev mode
- **Smooth Transitions**: Animated speed changes

### **Hotkey Controls** ⌨️
- **Space**: Toggle Pause/Resume
- **1**: Normal speed (1x)
- **2**: Double speed (4x)
- **3**: Triple speed (8x)
- **4**: Dev mode (FPS-based)

### **Event System** 📡
- **Fast Tick Events**: User Event 0 for each game tick
- **Day Events**: User Event 1 when day completes
- **Dynamic Listeners**: Register any object to receive events
- **Safe Registration**: Prevents duplicate listeners

### **Animation Scaling** 🎬
- **Independent Animation**: Separate from gameplay speed
- **Smart Capping**: Prevents animations from going too fast
- **Dev Mode Protection**: Limits animation speed in dev mode

---

## **HOW TO USE** 📋

### **1. Copy the Object**
```
Copy: objects/objSys_clock/
Paste into your project's Objects folder
```

### **2. Add to Your Room**
```
Place objSys_clock in your room
Set it to persistent if needed
```

### **3. Register Listeners (Optional)**
```gml
// In your system's Create event:
global.clock_register_listener = id;

// Your system will now receive:
// - User Event 0: Fast tick events
// - User Event 1: Day completion events
```

### **4. That's It!** 🎉
The clock system works immediately with:
- No dependencies on other objects
- No global variables required
- No additional setup needed

---

## **EVENT SYSTEM** 📡

### **Fast Tick Events (User Event 0)**
Called multiple times per frame based on game speed:
- **Pause**: 0 times per frame
- **Normal**: ~10 times per frame
- **2x**: ~40 times per frame
- **3x**: ~80 times per frame
- **Dev**: ~60 times per frame (FPS-based)

### **Day Events (User Event 1)**
Called once when a day completes (clock reaches 100%):
- Perfect for daily tasks
- Resource generation
- AI updates
- Save/load triggers

### **Registering Listeners**
```gml
// Register any object to receive clock events
global.clock_register_listener = objYourSystem;

// Unregister (remove from listeners)
// The system automatically handles destroyed objects
```

---

## **CUSTOMIZATION** ⚙️

### **Time Settings**
```gml
// In Create event, adjust these values:
base_hz = 10;                 // Fast tick rate at Normal
ticks_per_day_base = 300;     // Ticks to complete 0→100
mode = 2;                     // Starting mode (2=Normal)
```

### **Animation Settings**
```gml
// In Create event, adjust these values:
anim_dev_cap = 3;             // Max animation speed in Dev mode
```

### **Display Settings**
```gml
// The Draw GUI event shows:
// - Current mode and controls
// - Day counter
// - Clock percentage
// - FPS and scaling info
// - Visual progress bar
```

---

## **GLOBAL VARIABLES** 🌐

The system exposes these globals for other systems:

```gml
global.clock_pct      // 0-100 current day progress
global.day_count      // Total days elapsed
global.time_mode      // Current speed mode (1-5)
global.gameplay_scale // Current gameplay speed multiplier
global.anim_mul       // Current animation speed multiplier
global.ticks_per_day_base // Base ticks per day (for calculations)
```

---

## **TECHNICAL DETAILS** 🔧

### **What It Does**
- Manages game time independently of frame rate
- Provides consistent tick rates across different speeds
- Handles smooth transitions between speed modes
- Manages listener registration and cleanup
- Exposes timing data globally

### **What It Doesn't Need**
- No other objects required
- No specific room setup
- No additional scripts
- No manual configuration

### **Safety Features**
- Automatic listener cleanup for destroyed objects
- Spiral protection (max 5 ticks per frame)
- FPS-based scaling in Dev mode
- Graceful handling of missing listeners

---

## **INTEGRATION EXAMPLES** 🔗

### **Employee System**
```gml
// In objPerson_parent Create event:
global.clock_register_listener = id;

// In objPerson_parent User Event 0:
// Update stress, move, work, etc.

// In objPerson_parent User Event 1:
// Daily tasks, salary, etc.
```

### **Building System**
```gml
// In objBld_parent Create event:
global.clock_register_listener = id;

// In objBld_parent User Event 0:
// Production, maintenance, etc.

// In objBld_parent User Event 1:
// Daily building tasks
```

### **Economy System**
```gml
// In objEconomy Create event:
global.clock_register_listener = id;

// In objEconomy User Event 0:
// Update prices, transactions

// In objEconomy User Event 1:
// Daily economic calculations
```

---

## **COMPATIBILITY** 🌐

### **Works With**
- Any object type
- Any room size
- Any project structure
- Multiple clock instances (if needed)

### **Tested With**
- Employee management systems
- Building systems
- Economy systems
- Save/load systems
- UI systems

---

## **EXTRACTION CHECKLIST** ✅

When copying this system to a new project:

1. ✅ Copy `objects/objSys_clock/` folder
2. ✅ Place `objSys_clock` in your room
3. ✅ Test hotkey controls (Space, 1-4)
4. ✅ Verify clock display shows correctly
5. ✅ Test listener registration
6. ✅ Verify events fire correctly
7. ✅ Done! No other setup needed

---

## **TROUBLESHOOTING** 🔧

### **Clock Not Working?**
- Make sure the object is placed in your room
- Check that the object is not destroyed immediately
- Verify hotkeys are working (Space, 1-4)

### **Events Not Firing?**
- Make sure you registered your object as a listener
- Check that your object has User Event 0 and 1
- Verify the object exists when events fire

### **Performance Issues?**
- The system is optimized for 60fps
- Spiral protection prevents frame drops
- All calculations are done per-frame
- No background processes

---

**This clock system is completely portable and ready to use in any project!** 🚀
