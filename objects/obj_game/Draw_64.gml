// Interactive expandable minimap
if (instance_exists(obj_player)) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    var minimap_size, minimap_x, minimap_y;
    var background_alpha = 0.7;
    
    if (minimap_expanded) {
        // Large minimap (90% of screen, centered)
        minimap_size = min(gui_width, gui_height) * 0.9;
        minimap_large_size = minimap_size; // Store for click detection
        minimap_x = (gui_width - minimap_size) / 2;
        minimap_y = (gui_height - minimap_size) / 2;
        background_alpha = 0.9; // More opaque when large
        
        // Semi-transparent overlay behind large minimap
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(0, 0, gui_width, gui_height, false);
    } else {
    // Normal minimap (top-right, DEFINITELY bigger)
    minimap_size = 180;  // FIXED: Force bigger size (was 144, now 180)
    minimap_x = gui_width - minimap_size - 20;
    minimap_y = 20;
}

    
    // Minimap background
    draw_set_color(c_black);
    draw_set_alpha(background_alpha);
    draw_rectangle(minimap_x, minimap_y, minimap_x + minimap_size, minimap_y + minimap_size, false);
    
    // Minimap border
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(minimap_x, minimap_y, minimap_x + minimap_size, minimap_y + minimap_size, true);
    
    // Player position on minimap
    var player_map_x = minimap_x + (obj_player.x / room_width) * minimap_size;
    var player_map_y = minimap_y + (obj_player.y / room_height) * minimap_size;
    
    draw_set_color(c_lime);
    draw_circle(player_map_x, player_map_y, max(3, minimap_size / 40), false);
    
    // World bounds indicator
    draw_set_color(c_red);
    draw_set_alpha(0.4);
    var border_size = (50 / room_width) * minimap_size;
    draw_rectangle(minimap_x + border_size, minimap_y + border_size, 
                  minimap_x + minimap_size - border_size, minimap_y + minimap_size - border_size, true);
    
    // Show all artwork on large minimap
    if (minimap_expanded && surface_exists(trail_canvas)) {
        // Draw the trail canvas scaled down on the minimap
        draw_set_alpha(0.6);
        var scale_x = minimap_size / room_width;
        var scale_y = minimap_size / room_height;
        draw_surface_ext(trail_canvas, minimap_x, minimap_y, scale_x, scale_y, 0, c_white, 0.6);
    }
    
    // Click instruction text
    draw_set_color(c_white);
    draw_set_alpha(1);
    if (minimap_expanded) {
        draw_set_halign(fa_center);
        draw_text(gui_width / 2, minimap_y + minimap_size + 20, "Click to close");
        draw_set_halign(fa_left);
    } else {
        // Small click hint
        draw_set_halign(fa_right);
        draw_text(gui_width - 25, minimap_y + minimap_size + 5, "Click to expand");
        draw_set_halign(fa_left);
    }
    
    // Reset drawing settings
    draw_set_color(c_white);
    draw_set_alpha(1);
}
