function scr_detect_closed_shape() {
    // Need minimum points for a valid shape
    if (ds_list_size(shape_path_points) < 12) {
        return 0;
    }
    
    // Calculate shape bounds and validate size
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
    
    show_debug_message("Shape bounds - Width: " + string(width) + ", Height: " + string(height));
    
    // Minimum size validation (at least 40x40 pixels)
    if (width < 40 || height < 40) {
        show_debug_message("Shape too small: " + string(width) + "x" + string(height));
        return 0;
    }
    
    // Check if path forms a reasonable loop
    var first_point = ds_list_find_value(shape_path_points, 0);
    var last_point = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
    var closure_distance = point_distance(first_point[0], first_point[1], last_point[0], last_point[1]);
    
    // Must be reasonably closed (within 20% of average dimension)
    var avg_dimension = (width + height) / 2;
    var max_closure_distance = avg_dimension * 0.2;
    
    if (closure_distance > max_closure_distance) {
        show_debug_message("Path not closed enough: " + string(closure_distance) + " > " + string(max_closure_distance));
        return 0;
    }
    
    // VALID SHAPE DETECTED!
    show_debug_message("VALID SHAPE! Area: " + string(area) + ", Closure: " + string(closure_distance));
    
    // Create shape flash effect
    if (surface_exists(obj_game.shape_fill_surface)) {
        var shape_points = ds_list_create();
        for (var i = 0; i < ds_list_size(shape_path_points); i++) {
            var pt = ds_list_find_value(shape_path_points, i);
            ds_list_add(shape_points, [pt[0], pt[1]]);
        }
        
        var shape_data = [
            shape_points,           // [0] Point list
            (min_x + max_x) / 2,   // [1] Center X
            (min_y + max_y) / 2,   // [2] Center Y
            width,                 // [3] Width
            height,                // [4] Height
            my_trail_color,        // [5] Color
            180,                   // [6] Animation timer (3 seconds)
            area,                  // [7] Shape area
            1.0,                   // [8] Fill alpha
            false                  // [9] Has spawned particles
        ];
        
        ds_list_add(shape_flash_list, shape_data);
        
        // Draw filled shape on shape surface
        surface_set_target(obj_game.shape_fill_surface);
        draw_set_color(my_trail_color);
        draw_set_alpha(0.3);
        
        // Draw shape outline
        if (ds_list_size(shape_points) > 2) {
            for (var i = 0; i < ds_list_size(shape_points) - 1; i++) {
                var p1 = ds_list_find_value(shape_points, i);
                var p2 = ds_list_find_value(shape_points, i + 1);
                draw_line_width(p1[0], p1[1], p2[0], p2[1], 4);
            }
            // Close the shape
            var first = ds_list_find_value(shape_points, 0);
            var last = ds_list_find_value(shape_points, ds_list_size(shape_points) - 1);
            draw_line_width(last[0], last[1], first[0], first[1], 4);
        }
        
        surface_reset_target();
    }
    
    return area;
}
