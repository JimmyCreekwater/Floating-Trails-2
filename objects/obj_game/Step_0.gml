// Recreate surface if lost (memory management)
if (!surface_exists(trail_canvas)) {
    trail_canvas = surface_create(canvas_width, canvas_height);
    surface_set_target(trail_canvas);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}
// Canvas controls
if (keyboard_check_pressed(ord("C")) && keyboard_check(vk_control)) {
    // Clear canvas with Ctrl+C
    surface_set_target(trail_canvas);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

// NEW: Camera following player
if (instance_exists(obj_player)) {
    // Smooth camera following
    cam_x = lerp(cam_x, obj_player.x, cam_speed);
    cam_y = lerp(cam_y, obj_player.y, cam_speed);
    
    // Keep camera within world bounds
    cam_x = clamp(cam_x, 512, room_width - 512);
    cam_y = clamp(cam_y, 384, room_height - 384);
    
    // Update camera position
    camera_set_view_pos(view_camera[0], cam_x - 512, cam_y - 384);
}


// RELIABLE: Check for minimap clicks in Step Event
if (mouse_check_button_pressed(mb_left) && instance_exists(obj_player)) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    // Convert mouse to GUI coordinates
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    
    if (minimap_expanded) {
        // Large minimap (center of screen)
        var large_size = min(gui_width, gui_height) * 0.9;
        var large_x = (gui_width - large_size) / 2;
        var large_y = (gui_height - large_size) / 2;
        
        // Check if clicked on large minimap
        if (gui_mouse_x >= large_x && gui_mouse_x <= large_x + large_size &&
            gui_mouse_y >= large_y && gui_mouse_y <= large_y + large_size) {
            minimap_expanded = false;
            show_debug_message("Large minimap clicked - collapsing!");
        }
    } else {
        // Small minimap (top-right)
        var small_size = 180;
        var small_x = gui_width - small_size - 20;
        var small_y = 20;
        
        // Check if clicked on small minimap
        if (gui_mouse_x >= small_x && gui_mouse_x <= small_x + small_size &&
            gui_mouse_y >= small_y && gui_mouse_y <= small_y + small_size) {
            minimap_expanded = true;
            show_debug_message("Small minimap clicked - expanding!");
        }
    }
}

// PHASE 4A: Shard spawning system
if (random(100) < 1.5) { // ~1.5% chance per frame = every 3-4 seconds
    // Find a blank pixel to spawn shard
    var attempts = 0;
    var spawn_x, spawn_y;
    var found_spot = false;
    
    while (attempts < 20 && !found_spot) {
        spawn_x = random_range(100, room_width - 100);
        spawn_y = random_range(100, room_height - 100);
        
        var pixel_key = string(floor(spawn_x)) + "," + string(floor(spawn_y));
        if (!ds_map_exists(global.painted_pixels, pixel_key)) {
            found_spot = true;
        }
        attempts++;
    }
    
    if (found_spot) {
        instance_create_layer(spawn_x, spawn_y, "Instances", obj_shard);
    }
}

// ===== FULLSCREEN TOGGLE =====
// F11 or Alt+Enter to toggle fullscreen
if (keyboard_check_pressed(vk_f11) || (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))) {
    if (window_get_fullscreen()) {
        window_set_fullscreen(false);
        
        // Return to windowed mode with reasonable size
        var display_w = display_get_width();
        var display_h = display_get_height();
        var window_w = min(display_w * 0.8, 1366);
        var window_h = min(display_h * 0.8, 768);
        
        window_set_size(window_w, window_h);
        window_center();
    } else {
        window_set_fullscreen(true);
    }
}

// ESC to exit fullscreen
if (keyboard_check_pressed(vk_escape) && window_get_fullscreen()) {
    window_set_fullscreen(false);
    
    var display_w = display_get_width();
    var display_h = display_get_height();
    var window_w = min(display_w * 0.8, 1366);
    var window_h = min(display_h * 0.8, 768);
    
    window_set_size(window_w, window_h);
    window_center();
}