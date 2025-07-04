// REPLACE your entire scr_detect_closed_shape with this battle-tested version:

function scr_detect_closed_shape() {
    // Minimum points for a shape
    if (ds_list_size(shape_path_points) < 8) {
        return 0;
    }
    
    // Get the most recent point
    var last_point = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
    var last_x = last_point[0];
    var last_y = last_point[1];
    
    // Check against FIRST point for simple loop detection
    var first_point = ds_list_find_value(shape_path_points, 0);
    var first_x = first_point[0];
    var first_y = first_point[1];
    
    var close_distance = point_distance(last_x, last_y, first_x, first_y);
    
    // Debug what we're checking
    show_debug_message("Checking shape - Points: " + string(ds_list_size(shape_path_points)) + 
                      ", Distance to close: " + string(close_distance));
    
    // Simple check: Are we back at the start?
    if (close_distance < 30) {
        // Calculate shape bounds
        var min_x = 999999, max_x = -999999;
        var min_y = 999999, max_y = -999999;
        
        for (var i = 0; i < ds_list_size(shape_path_points); i++) {
            var point = ds_list_find_value(shape_path_points, i);
            min_x = min(min_x, point[0]);
            max_x = max(max_x, point[0]);
            min_y = min(min_y, point[1]);
            max_y = max(max_y, point[1]);
        }
        
        var width = max_x - min_x;
        var height = max_y - min_y;
        var area = width * height;
        
        show_debug_message("Shape detected! Width: " + string(width) + 
                          ", Height: " + string(height) + ", Area: " + string(area));
        
        // Minimum size check (about 25x25)
        if (width >= 25 && height >= 25) {
            // Copy points for the shape
            var shape_points = ds_list_create();
            for (var i = 0; i < ds_list_size(shape_path_points); i++) {
                var pt = ds_list_find_value(shape_path_points, i);
                ds_list_add(shape_points, pt);
            }
            
            // Create shape effect data
            var shape_data = [
                shape_points,           // [0] Point list
                (min_x + max_x) / 2,   // [1] Center X
                (min_y + max_y) / 2,   // [2] Center Y
                width,                 // [3] Width
                height,                // [4] Height
                my_trail_color,        // [5] Color
                120,                   // [6] Animation timer
                area,                  // [7] Shape area
                1.0,                   // [8] Fill alpha
                false                  // [9] Has spawned particles
            ];
            
            ds_list_add(shape_flash_list, shape_data);
            
            // Fill the shape on surface
            if (surface_exists(obj_game.shape_fill_surface)) {
                surface_set_target(obj_game.shape_fill_surface);
                draw_set_color(my_trail_color);
                draw_set_alpha(0.8);
                
                // Simple rectangle fill for now
                draw_rectangle(min_x, min_y, max_x, max_y, false);
                
                surface_reset_target();
            }
            
            // Clear the path
            ds_list_clear(shape_path_points);
            
            show_debug_message("SHAPE COMPLETED! Returning area: " + string(area));
            return area;
        } else {
            show_debug_message("Shape too small!");
        }
    }
    
    return 0;
}
