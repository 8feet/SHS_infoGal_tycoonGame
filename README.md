# SHS_infoGal_sim_aA0

A comprehensive building and employee management simulation built in GameMaker Studio 2.

## 🎮 Project Overview

This is a simulation game where players manage buildings and employees in a strategic environment. The game features drag-and-drop building placement, employee assignment systems, stress management, and work progression mechanics.

## ✨ Key Features

### 🏢 Building System
- **Drag & Drop Placement**: Intuitive building placement with visual feedback
- **Tile Validation**: Smart collision detection and placement validation
- **Cost System**: Resource-based building costs with visual indicators
- **Demolition**: Safe building removal with employee ejection
- **Immutability**: Buildings become permanent after placement

### 👥 Employee Management
- **Smart Assignment**: Drag employees to buildings for work assignment
- **Stress Tracking**: Real-time stress monitoring (0-100 scale)
- **Work Progress**: Individual work completion tracking (0-100 scale)
- **Visual Feedback**: Hover-based progress bars (yellow for work, white for stress)
- **Auto-Recovery**: Stress recovery in lobby area

### 🏛️ Lobby System
- **Holding Area**: Neutral zone for unassigned employees
- **Stress Recovery**: Automatic stress reduction (-0.1/sec)
- **Random Positioning**: Employees spread randomly across lobby width
- **No Work Progression**: Lobby provides rest, not work

### 🔄 Work Flow System
- **Three Forced-to-Lobby Triggers**:
  1. **Work Complete**: Employee finishes 100% work progress
  2. **No Rally Output**: Room has no connected next room
  3. **Building Demolished**: Room is destroyed while employees are inside

## 🛠️ Technical Architecture

### Core Objects
- **`objBld_parent`**: Base building class with all core functionality
- **`objBld_lobby`**: Standalone lobby system for employee holding
- **`objPerson_parent`**: Employee base class with assignment and tracking
- **`objTile`**: Grid-based placement validation system

### Processing Systems
- **Staggered Batch Processing**: Optimized performance for large employee counts
- **Clock-Aware Updates**: Time-based progression with gameplay scaling
- **Memory Management**: Efficient data structure handling with cleanup

### Visual Systems
- **Real-Time Bars**: Dynamic progress visualization
- **Conditional Display**: Bars only show when relevant (hide at 0)
- **World-to-GUI Conversion**: Proper coordinate transformation for UI elements

## 📊 Current Configuration

### Default Values
- **Building Stress Rate**: `0.1` per second (stressful work)
- **Lobby Stress Rate**: `-0.1` per second (stress recovery)
- **Work Progress Rate**: `1.0` per second (default for all rooms)
- **Lobby Work Rate**: `0.0` (no work progression)

### Performance Settings
- **Stress Processing**: 25% of employees per frame
- **Work Processing**: Reuses stress batch for efficiency
- **Visual Updates**: Real-time on hover

## 🚀 Getting Started

### Prerequisites
- GameMaker Studio 2 (latest version)
- Windows development environment

### Installation
1. Clone this repository
2. Open `SHS_infoGal_sim_aA0.yyp` in GameMaker Studio 2
3. Run the project

### Basic Controls
- **Left Click + Drag**: Move buildings during placement
- **Left Click + Drag**: Assign employees to buildings
- **Hover**: View employee stress and work progress
- **Right Click**: Demolish buildings (when not dragging)

## 📁 Project Structure

```
SHS_infoGal_sim_aA0/
├── objects/                 # Game objects
│   ├── objBld_parent/      # Base building class
│   ├── objBld_lobby/       # Lobby system
│   ├── objPerson_parent/   # Employee base class
│   └── objTile/            # Grid validation
├── sprites/                # Visual assets
├── rooms/                  # Game rooms
├── options/                # Platform-specific settings
└── datafiles/             # Game data and placeholders
```

## 🔧 Development Notes

### Code Philosophy
- **"Dumb and Easy"**: Simple, readable code for maintainability
- **Modular Design**: Clear separation of concerns
- **Performance First**: Optimized for large-scale simulations
- **Error Prevention**: Extensive safety checks and validation

### Key Implementation Details
- **Parent-Child Relationships**: Efficient inheritance system
- **Data Structure Management**: Proper cleanup and memory management
- **State Management**: Robust flag system for preventing race conditions
- **Coordinate Systems**: Proper world-to-GUI conversion for UI elements

## 🐛 Known Issues & Solutions

### Fixed Issues
- ✅ Employee teleportation loops (fixed with `just_assigned` flag)
- ✅ Work progress retention on room change (reset on assignment)
- ✅ Initial work boost bug (proper time tracking)
- ✅ Visual bar persistence (conditional display logic)

### Performance Considerations
- Staggered processing prevents frame drops with many employees
- Memory cleanup prevents accumulation over time
- Efficient collision detection for placement validation

## 🎯 Future Development

### Planned Features
- **Rally System**: Visual connections between rooms for work flow
- **Room-Specific Rates**: Custom work and stress rates per room type
- **Advanced UI**: Enhanced visual feedback and management tools
- **Save System**: Persistent game state management

### Extension Points
- New building types with custom behaviors
- Advanced employee AI and decision making
- Resource management and economy systems
- Multiplayer and networking capabilities

## 📝 License

This project is developed for educational and entertainment purposes.

## 🤝 Contributing

This is a personal project, but suggestions and feedback are welcome!

---

**Built with GameMaker Studio 2** | **Version**: Latest | **Status**: Active Development
