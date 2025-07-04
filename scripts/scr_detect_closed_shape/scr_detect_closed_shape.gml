// CREATE A NEW SCRIPT: scr_detect_closed_shape

function scr_detect_closed_shape() {
    // Check if we have enough points to form a shape
    if (ds_list_size(shape_path_points) < 20) return false;
    
    // Get the last point (current position)
    var last_point = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
    var current_x = last_point[0];
    var current_y = last_point[1];
    
    // Check if we've come back near any earlier point to close a loop
    var loop_start_index = -1;
    var min_loop_size = 15; // Minimum points to form a valid shape
    
    for (var i = 0; i < ds_list_size(shape_path_points) - min_loop_size; i++) {
        var point = ds_list_find_value(shape_path_points, i);
        var dist = point_distance(current_x, current_y, point[0], point[1]);
        
        // If we're close to an earlier point, we've closed a loop!
        if (dist < 20) {
            loop_start_index = i;
            break;
        }
    }
    
    if (loop_start_index >= 0) {
        // We found a closed loop! Calculate the shape
        var shape_points = ds_list_create();
        var min_x = 999999, max_x = -999999;
        var min_y = 999999, max_y = -999999;
        var area = 0;
        
        // Extract the loop points
        for (var i = loop_start_index; i < ds_list_size(shape_path_points); i++) {
            var point = ds_list_find_value(shape_path_points, i);
            ds_list_add(shape_points, point);
            
            // Track bounds
            min_x = min(min_x, point[0]);
            max_x = max(max_x, point[0]);
            min_y = min(min_y, point[1]);
            max_y = max(max_y, point[1]);
        }
        
        // Calculate approximate area using shoelace formula
        var n = ds_list_size(shape_points);
        for (var i = 0; i < n; i++) {
            var p1 = ds_list_find_value(shape_points, i);
            var p2 = ds_list_find_value(shape_points, (i + 1) % n);
            area += (p1[0] * p2[1] - p2[0] * p1[1]);
        }
        area = abs(area) / 2;
        
        // Check if shape is large enough (at least 40px equivalent)
        if (area >= 1600) { // 40x40 = 1600
            // Valid shape detected! Create flash effect
            var shape_data = [
                shape_points,           // [0] Point list
                (min_x + max_x) / 2,   // [1] Center X
                (min_y + max_y) / 2,   // [2] Center Y
                max_x - min_x,         // [3] Width
                max_y - min_y,         // [4] Height
                my_trail_color,        // [5] Color
                120,                   // [6] Animation timer (2 seconds)
                area,                  // [7] Shape area
                1.0,                   // [8] Fill alpha (starts at 1)
                false                  // [9] Has spawned particles
            ];
            
            ds_list_add(shape_flash_list, shape_data);
            
            // Draw the filled shape on the shape surface
            if (surface_exists(obj_game.shape_fill_surface)) {
                surface_set_target(obj_game.shape_fill_surface);
                
                draw_set_color(my_trail_color);
                draw_set_alpha(0.8);
                
                // Draw filled polygon
                var n = ds_list_size(shape_points);
                if (n > 2) {
                    // Use path for better fill
                    draw_primitive_begin(pr_trianglefan);
                    
                    // Center point
                    draw_vertex((min_x + max_x) / 2, (min_y + max_y) / 2);
                    
                    // Edge points
                    for (var i = 0; i <= n; i++) {
                        var p = ds_list_find_value(shape_points, i % n);
                        draw_vertex(p[0], p[1]);
                    }
                    
                    draw_primitive_end();
                }
                
                surface_reset_target();
            }
            
            // Clear the path to prevent re-detection
            ds_list_clear(shape_path_points);
            
            // Return the area for rewards
            return area;
        }
        
        ds_list_destroy(shape_points);
    }
    
    return 0;
}