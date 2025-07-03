// ===== obj_ghost - STEP EVENT =====
// Copy this entire block into obj_ghost Step Event

x = lerp(x, target_x, 0.1);
y = lerp(y, target_y, 0.1);

// Paint ghost trails (NEW ETCH-A-SKETCH SYSTEM)
var paint_distance = point_distance(x, y, last_paint_x, last_paint_y);
if (paint_distance > 3) {
    if (surface_exists(obj_game.trail_canvas)) {
        surface_set_target(obj_game.trail_canvas);
        
        draw_set_color(ghost_color);
        draw_set_alpha(0.4); // More transparent for ghosts
        draw_line_width(last_paint_x, last_paint_y, x, y, 1.5);
        
        draw_set_alpha(1);
        surface_reset_target();
    }
    
    last_paint_x = x;
    last_paint_y = y;
}
// Pulse collection cooldown management
if (variable_instance_exists(id, "last_collection_time") && last_collection_time > 0) {
    last_collection_time--;
}
