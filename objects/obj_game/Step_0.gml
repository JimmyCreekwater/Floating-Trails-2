// Recreate surface if lost (memory management)
if (!surface_exists(trail_canvas)) {
    trail_canvas = surface_create(canvas_width, canvas_height);
    surface_set_target(trail_canvas);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

// Recreate shape fill surface if lost
if (!surface_exists(shape_fill_surface)) {
    shape_fill_surface = surface_create(canvas_width, canvas_height);
    surface_set_target(shape_fill_surface);
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

// ADD THIS TO obj_game Step Event (after the trail_canvas surface check):

// Recreate shape fill surface if lost
if (!surface_exists(shape_fill_surface)) {
    shape_fill_surface = surface_create(canvas_width, canvas_height);
    surface_set_target(shape_fill_surface);
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


// UPDATE the minimap click detection in obj_game Step Event:
// Find the section that checks for minimap clicks and replace with:

// RELIABLE: Check for minimap clicks in Step Event
if (mouse_check_button_pressed(mb_left) && instance_exists(obj_player)) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    // Convert mouse to GUI coordinates
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);
    
    if (minimap_expanded) {
        // Click anywhere to close when expanded
        minimap_expanded = false;
    } else {
        // Check if clicked on small minimap (top-left now)
        var minimap_size = 220;
        var minimap_x = 20;
        var minimap_y = 20;
        
        if (gui_mouse_x >= minimap_x && gui_mouse_x <= minimap_x + minimap_size &&
            gui_mouse_y >= minimap_y && gui_mouse_y <= minimap_y + minimap_size) {
            minimap_expanded = true;
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

// ===== DYNAMIC VIEWPORT SCALING =====
// Update viewport when window size changes
var current_width = window_get_width();
var current_height = window_get_height();

if (current_width != view_wport[0] || current_height != view_hport[0]) {
    // Window size changed - update viewport
    view_xport[0] = 0;
    view_yport[0] = 0;
    view_wport[0] = current_width;
    view_hport[0] = current_height;
    
    // Recalculate camera view
    var base_view_width = 1366;
    var base_view_height = 768;
    var display_aspect = current_width / current_height;
    var base_aspect = base_view_width / base_view_height;
    
    if (display_aspect > base_aspect) {
        // Wider screen
        view_hview[0] = base_view_height;
        view_wview[0] = base_view_height * display_aspect;
    } else {
        // Taller screen
        view_wview[0] = base_view_width;
        view_hview[0] = base_view_width / display_aspect;
    }
    
    // Update camera
    camera_set_view_size(view_camera[0], view_wview[0], view_hview[0]);
    
    // Update GUI scaling
    display_set_gui_maximise();
}