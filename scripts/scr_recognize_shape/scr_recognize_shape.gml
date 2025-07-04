function scr_recognize_shape() {
    if (ds_list_size(shape_path_points) < 8) return "";
    
    // Get bounds of drawn shape
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
    
    // Too small
    if (width < 30 || height < 30) return "";
    
    // Normalize points to 0-1 range
    var normalized = ds_list_create();
    for (var i = 0; i < ds_list_size(shape_path_points); i++) {
        var point = ds_list_find_value(shape_path_points, i);
        var nx = (point[0] - min_x) / width;
        var ny = (point[1] - min_y) / height;
        ds_list_add(normalized, [nx, ny]);
    }
    
    // Check against each template
    var best_match = "";
    var best_score = 0.7; // Minimum 70% match
    
    var shapes = ds_map_keys_to_array(global.shape_templates);
    for (var s = 0; s < array_length(shapes); s++) {
        var shape_name = shapes[s];
        var template = global.shape_templates[? shape_name];
        
        // Calculate match score
        var score = calculate_shape_match(normalized, template);
        
        if (score > best_score) {
            best_score = score;
            best_match = shape_name;
        }
    }
    
    ds_list_destroy(normalized);
    
    return best_match;
}

function calculate_shape_match(drawn, template) {
    // Simple matching: check if key points are near template points
    var matches = 0;
    var checks = 0;
    
    // Sample points along the template
    for (var i = 0; i < ds_list_size(template) - 1; i++) {
        var t_point = ds_list_find_value(template, i);
        var min_dist = 999;
        
        // Find closest drawn point
        for (var j = 0; j < ds_list_size(drawn); j++) {
            var d_point = ds_list_find_value(drawn, j);
            var dist = point_distance(t_point[0], t_point[1], d_point[0], d_point[1]);
            min_dist = min(min_dist, dist);
        }
        
        checks++;
        if (min_dist < 0.2) { // Within 20% tolerance
            matches++;
        }
    }
    
    return matches / checks;
}