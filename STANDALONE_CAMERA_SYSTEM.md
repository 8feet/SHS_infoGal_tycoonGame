# 🎥 STANDALONE CAMERA SYSTEM

## **PORTABLE CAMERA MODULE - READY TO EXTRACT**

This camera system is completely self-contained and can be copied to any GameMaker Studio 2 project without dependencies.

---

## **FEATURES** ✨

### **Drag-to-Pan** 🖱️
- **Left Mouse Button**: Drag to pan around the world
- **Smart Detection**: Automatically detects when dragging over other objects
- **Smooth Movement**: Natural camera movement with proper bounds checking

### **Zoom Controls** 🔍
- **Mouse Wheel**: Zoom in/out with smooth cursor-following
- **Q/E Keys**: Alternative zoom controls
- **Middle Mouse Button**: Smart zoom toggle (zooms to cursor position)
- **Animated Transitions**: Smooth zoom animations with easing

### **WASD Movement** ⌨️
- **WASD Keys**: Pan camera in any direction
- **Shift + WASD**: Boosted movement speed
- **Diagonal Movement**: Properly normalized for consistent speed

### **Smart Bounds** 🎯
- **Room Boundaries**: Camera never goes outside room limits
- **Dynamic Sizing**: Automatically adjusts to room dimensions
- **Safe Initialization**: Always starts in a valid position

---

## **HOW TO USE** 📋

### **1. Copy the Object**
```
Copy: objects/objSys_camera/
Paste into your project's Objects folder
```

### **2. Add to Your Room**
```
Place objSys_camera in your room
Set it to persistent if needed
```

### **3. That's It!** 🎉
The camera system works immediately with:
- No dependencies on other objects
- No global variables required
- No additional setup needed

---

## **CUSTOMIZATION** ⚙️

### **Movement Speed**
```gml
// In Create event, adjust these values:
cam_pan_px = 16;        // WASD movement speed
cam_pan_boost = 2.5;    // Shift boost multiplier
```

### **Zoom Settings**
```gml
// In Create event, adjust these values:
zoom_step = 0.1;        // Zoom sensitivity
zoom_max = 5;           // Maximum zoom level
zoom = 1.0;             // Starting zoom level
```

### **Zoom Animation**
```gml
// In Create event, adjust these values:
z_dur_ms = 150;         // Animation duration (milliseconds)
```

---

## **TECHNICAL DETAILS** 🔧

### **What It Does**
- Creates and manages its own camera
- Handles all view transformations
- Provides smooth user interactions
- Maintains proper room boundaries

### **What It Doesn't Need**
- No other objects required
- No global variables
- No special room setup
- No additional scripts

### **Safety Features**
- Automatic camera creation
- Bounds checking on all movements
- Error handling for invalid states
- Clean destruction when removed

---

## **COMPATIBILITY** 🌐

### **Works With**
- Any room size
- Any viewport size
- Any GameMaker Studio 2 project
- Any object types (automatically detects draggable objects)

### **Tested With**
- Employee drag systems
- Building drag systems
- Any object with drag functionality
- Multiple camera instances (if needed)

---

## **EXTRACTION CHECKLIST** ✅

When copying this system to a new project:

1. ✅ Copy `objects/objSys_camera/` folder
2. ✅ Place `objSys_camera` in your room
3. ✅ Test drag-to-pan functionality
4. ✅ Test zoom controls (wheel, Q/E, MMB)
5. ✅ Test WASD movement
6. ✅ Verify bounds checking works
7. ✅ Done! No other setup needed

---

## **TROUBLESHOOTING** 🔧

### **Camera Not Working?**
- Make sure the object is placed in your room
- Check that view[0] is enabled in room settings
- Verify the object is not destroyed immediately

### **Drag Conflicts?**
- The system automatically detects draggable objects
- If you have custom drag objects, they'll be detected automatically
- No manual configuration needed

### **Performance Issues?**
- The system is optimized for 60fps
- All calculations are done per-frame
- No background processes or timers

---

**This camera system is completely portable and ready to use in any project!** 🚀

