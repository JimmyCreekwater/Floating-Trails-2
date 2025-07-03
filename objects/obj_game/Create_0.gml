// ===== obj_game - CREATE EVENT =====
// Initialize networking
network_set_config(network_config_connect_timeout, 5000); // FIXED: numeric constant
global.server = network_create_server_raw(network_socket_tcp, 6510, 16);
if (global.server < 0) {
    // If server creation fails, try to connect as a client
    global.client = network_create_socket(network_socket_tcp);
    network_connect_raw(global.client, "127.0.0.1", 6510);
} else {
    global.client = -1; // -1 indicates this is the server
}
global.player_id = -1;
global.ghosts = ds_map_create();

// Add after existing networking code:
// Create drawing canvas for trails
canvas_width = 4096;  // NEW: Fixed large canvas size
canvas_height = 4096;

trail_canvas = surface_create(canvas_width, canvas_height);
// Clear canvas to transparent
surface_set_target(trail_canvas);
draw_clear_alpha(c_black, 0); // Transparent background
surface_reset_target();

// Camera setup for large world
view_enabled = true;
view_visible[0] = true;
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = 1024;
view_hport[0] = 768;
view_camera[0] = camera_create_view(0, 0, 1024, 768);
// Camera properties
cam_x = room_width / 2;
cam_y = room_height / 2;
cam_speed = 0.15;

// Interactive minimap system
minimap_expanded = false;
minimap_normal_size = 144;  // 20% bigger than before (was 120)
minimap_large_size = 0;     // Will be calculated based on screen size

// PHASE 4A: Global pixel tracking system
global.painted_pixels = ds_map_create(); // x,y -> player_id (tracks ALL painted pixels)
global.total_pixels_painted = 0;

// Global trail segments for Living Weave animation
global.painted_trail_segments = ds_list_create();
