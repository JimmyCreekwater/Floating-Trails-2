function scr_recognize_shape() {
    if (ds_list_size(shape_path_points) < 8) return "";
    
    // Get bounds and normalize
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
    
    if (width < 30 || height < 30) return "";
    
    // Create downsampled path for matching (every 10th point)
    var sample_points = ds_list_create();
    var sample_step = max(1, floor(ds_list_size(shape_path_points) / 16)); // Target 16 sample points
    
    for (var i = 0; i < ds_list_size(shape_path_points); i += sample_step) {
        var point = ds_list_find_value(shape_path_points, i);
        var nx = (point[0] - min_x) / width;
        var ny = (point[1] - min_y) / height;
        ds_list_add(sample_points, [nx, ny]);
    }
    
    // Test each shape template
    var best_match = "";
    var best_score = 0.6; // Minimum 60% match required
    
    var shapes = ["Circle", "Square", "Triangle", "Star"];
    
    for (var s = 0; s < array_length(shapes); s++) {
        var shape_name = shapes[s];
        var template = global.shape_templates[? shape_name];
        
        if (template != undefined) {
            var match_score = calculate_shape_match_improved(sample_points, template);
            
            show_debug_message("Testing " + shape_name + ": " + string(match_score * 100) + "%");
            
            if (match_score > best_score) {
                best_score = match_score;
                best_match = shape_name;
            }
        }
    }
    
    ds_list_destroy(sample_points);
    
    if (best_match != "") {
        show_debug_message("SHAPE RECOGNIZED: " + best_match + " (" + string(best_score * 100) + "%)");
    }
    
    return best_match;
}
function calculate_shape_match_improved(drawn, template) {
    if (ds_list_size(drawn) < 4 || ds_list_size(template) < 4) return 0;
    
    var total_score = 0;
    var comparisons = 0;
    
    // Sample-based matching approach
    var sample_count = min(ds_list_size(drawn), 12);
    
    for (var i = 0; i < sample_count; i++) {
        var drawn_index = floor((i / sample_count) * ds_list_size(drawn));
        var drawn_point = ds_list_find_value(drawn, drawn_index);
        
        // Find closest template point
        var min_distance = 999;
        for (var j = 0; j < ds_list_size(template); j++) {
            var template_point = ds_list_find_value(template, j);
            var distance = point_distance(drawn_point[0], drawn_point[1], template_point[0], template_point[1]);
            min_distance = min(min_distance, distance);
        }
        
        // Convert distance to score (closer = higher score)
        var point_score = max(0, 1 - (min_distance / 0.3)); // 0.3 = maximum tolerance
        total_score += point_score;
        comparisons++;
    }
    
    return comparisons > 0 ? total_score / comparisons : 0;
}
