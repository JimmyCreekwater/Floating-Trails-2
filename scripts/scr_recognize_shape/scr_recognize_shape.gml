function scr_recognize_shape() {
    // Just detect circles for now
    if (ds_list_size(shape_path_points) < 8) return "";
    
    // Get first and last points
    var first = ds_list_find_value(shape_path_points, 0);
    var last = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
    
    // Are we near the start?
    var close_dist = point_distance(first[0], first[1], last[0], last[1]);
    if (close_dist > 50) return ""; // Not closed
    
    // Get bounds
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
    
    // Check if it's roughly circular (width ≈ height)
    var ratio = min(width, height) / max(width, height);
    
    if (ratio > 0.7 && width > 40 && height > 40) {
        return "Circle";
    }
    
    return "";
}