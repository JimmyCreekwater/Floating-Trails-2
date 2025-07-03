function scr_detect_shapes() {
    // SIMPLE, RELIABLE shape detection
    // Just check if player completed a rough circle/loop around their current area
    
    if (!surface_exists(obj_game.trail_canvas)) return 0;
    
    // Check a small area around the player for a potential loop
    var check_radius = 80;
    var center_x = x;
    var center_y = y;
    
    // Count painted pixels in concentric rings around player
    var inner_ring_pixels = 0;
    var outer_ring_pixels = 0;
    var total_checks = 0;
    
    // Check inner area (should be mostly empty for a shape)
    for (var angle = 0; angle < 360; angle += 20) {
        var inner_x = center_x + lengthdir_x(20, angle);
        var inner_y = center_y + lengthdir_y(20, angle);
        var inner_key = string(floor(inner_x)) + "," + string(floor(inner_y));
        
        if (ds_map_exists(global.painted_pixels, inner_key)) {
            inner_ring_pixels++;
        }
        total_checks++;
    }
    
    // Check outer ring (should have painted pixels for a shape)
    for (var angle = 0; angle < 360; angle += 15) {
        var outer_x = center_x + lengthdir_x(50, angle);
        var outer_y = center_y + lengthdir_y(50, angle);
        var outer_key = string(floor(outer_x)) + "," + string(floor(outer_y));
        
        if (ds_map_exists(global.painted_pixels, outer_key)) {
            outer_ring_pixels++;
        }
    }
    
    // Shape detection logic:
    // - Outer ring should have many painted pixels (forming a boundary)
    // - Inner area should have fewer painted pixels (hollow inside)
    var outer_coverage = outer_ring_pixels / 24; // 24 checks in outer ring
    var inner_coverage = inner_ring_pixels / 18;  // 18 checks in inner ring
    
    // Detect shape if:
    // - At least 60% of outer ring is painted (good boundary)
    // - Less than 40% of inner area is painted (hollow center)
    if (outer_coverage >= 0.6 && inner_coverage <= 0.4) {
        var estimated_size = outer_ring_pixels * 4; // Rough size estimate
        
        if (estimated_size >= 40) {
            // Mark this area as completed to prevent immediate re-detection
            var completion_key = string(floor(center_x / 100)) + "," + string(floor(center_y / 100)) + "_completed";
            
            if (!ds_map_exists(global.painted_pixels, completion_key)) {
                ds_map_add(global.painted_pixels, completion_key, current_time);
                return estimated_size;
            }
        }
    }
    
    return 0;
}
