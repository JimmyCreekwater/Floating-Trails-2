// REPLACE the entire obj_game Draw_64.gml with this updated minimap:

// Interactive expandable minimap (TOP-LEFT)
if (instance_exists(obj_player)) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    var minimap_size, minimap_x, minimap_y;
    var background_alpha = 0.8;
    
    if (minimap_expanded) {
        // Large minimap (90% of screen, centered)
        minimap_size = min(gui_width, gui_height) * 0.9;
        minimap_large_size = minimap_size;
        minimap_x = (gui_width - minimap_size) / 2;
        minimap_y = (gui_height - minimap_size) / 2;
        background_alpha = 0.9;
        
        // Semi-transparent overlay behind large minimap
        draw_set_color(c_black);
        draw_set_alpha(0.5);
        draw_rectangle(0, 0, gui_width, gui_height, false);
    } else {
        // Normal minimap (TOP-LEFT, MUCH BIGGER)
        minimap_size = 220;  // Increased from 180
        minimap_x = 20;      // Left margin
        minimap_y = 20;      // Top margin
    }
    
    // Minimap background with rounded corners
    draw_set_color(c_black);
    draw_set_alpha(background_alpha);
    draw_roundrect(minimap_x, minimap_y, minimap_x + minimap_size, minimap_y + minimap_size, false);
    
    // Minimap border
    draw_set_color(c_white);
    draw_set_alpha(0.8);
    draw_roundrect(minimap_x, minimap_y, minimap_x + minimap_size, minimap_y + minimap_size, true);
    
    // Draw mini version of artwork if expanded
    if (minimap_expanded && surface_exists(obj_game.trail_canvas)) {
        draw_set_alpha(0.6);
        var scale_x = minimap_size / room_width;
        var scale_y = minimap_size / room_height;
        draw_surface_ext(obj_game.trail_canvas, minimap_x, minimap_y, scale_x, scale_y, 0, c_white, 0.6);
    }
    
    // Player position on minimap
    var player_map_x = minimap_x + (obj_player.x / room_width) * minimap_size;
    var player_map_y = minimap_y + (obj_player.y / room_height) * minimap_size;
    
    // Player indicator with pulse effect
    var pulse = 1 + sin(current_time * 0.005) * 0.2;
    draw_set_color(c_lime);
    draw_set_alpha(0.5);
    draw_circle(player_map_x, player_map_y, 8 * pulse, false);
    draw_set_alpha(1);
    draw_circle(player_map_x, player_map_y, 4, false);
    
    // Direction indicator
    var dir_length = 12;
    var dir_x = player_map_x + lengthdir_x(dir_length, obj_player.direction);
    var dir_y = player_map_y + lengthdir_y(dir_length, obj_player.direction);
    draw_line_width(player_map_x, player_map_y, dir_x, dir_y, 2);
    
    // World bounds indicator
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    var border_size = (50 / room_width) * minimap_size;
    draw_roundrect(minimap_x + border_size, minimap_y + border_size, 
                  minimap_x + minimap_size - border_size, minimap_y + minimap_size - border_size, true);
    
    // Draw other players on minimap
    with (obj_ghost) {
        var ghost_map_x = other.minimap_x + (x / room_width) * other.minimap_size;
        var ghost_map_y = other.minimap_y + (y / room_height) * other.minimap_size;
        
        draw_set_color(ghost_color);
        draw_set_alpha(0.7);
        draw_circle(ghost_map_x, ghost_map_y, 3, false);
    }
    
    // Draw shards on minimap
    draw_set_color(c_aqua);
    draw_set_alpha(0.8);
    with (obj_shard) {
        var shard_map_x = other.minimap_x + (x / room_width) * other.minimap_size;
        var shard_map_y = other.minimap_y + (y / room_height) * other.minimap_size;
        
        // Sparkle effect
        if (sparkle_timer < 15) {
            draw_circle(shard_map_x, shard_map_y, 2, false);
        }
    }
    
    // Minimap label
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    
    if (minimap_expanded) {
        // Close instruction
        draw_set_halign(fa_center);
        draw_text_transformed(gui_width / 2, minimap_y + minimap_size + 20, "Click anywhere to close", 1.5, 1.5, 0);
        draw_set_halign(fa_left);
    } else {
        // Minimap title
        draw_text_transformed(minimap_x, minimap_y - 20, "MAP", 1.5, 1.5, 0);
        // Click hint
        draw_set_alpha(0.6);
        draw_text(minimap_x, minimap_y + minimap_size + 5, "Click to expand");
    }
    
    // Reset drawing settings
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}