# Updated Bottom Navigation Structure

## Navigation Order (Left to Right)
1. **Home** - Dashboard screen
2. **Workout** - Workout logger screen  
3. **Coach** - AI Nutrition Coach (NEW POSITION - moved from index 4 to index 2)
4. **Library** - Exercise library (moved from index 2 to index 3)
5. **Profile** - Settings/Profile screen

## Coach Icon Design
- **Outline State**: Chat bubble with person motif and leaf accent
- **Filled State**: Filled chat bubble with white person motif and leaf accent
- **Colors**: 
  - Inactive: #BDBDBD (muted)
  - Active: #5DD62C (accent1)
- **Size**: 24x24px
- **Format**: SVG with proper scaling

## Navigation Logic Updates
- Dashboard navigation handler updated to match new order
- Coach now at index 2 (was index 3)
- Library now at index 3 (was index 2)
- All other navigation remains the same

## Assets Created
- `assets/icons/coach-outline.svg` - Inactive state icon
- `assets/icons/coach-filled.svg` - Active state icon
- Both icons use currentColor for theming compatibility

