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

// Camera setup for large world with dynamic scaling
view_enabled = true;
view_visible[0] = true;

// Get current window size
var window_width = window_get_width();
var window_height = window_get_height();

// Set viewport to fill entire window
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = window_width;
view_hport[0] = window_height;

// Calculate camera view size to maintain gameplay visibility
var base_view_width = 1366;
var base_view_height = 768;
var display_aspect = window_width / window_height;
var base_aspect = base_view_width / base_view_height;

if (display_aspect > base_aspect) {
    // Wider screen - fit height, expand width
    view_hview[0] = base_view_height;
    view_wview[0] = base_view_height * display_aspect;
} else {
    // Taller screen - fit width, expand height
    view_wview[0] = base_view_width;
    view_hview[0] = base_view_width / display_aspect;
}

// Create camera with calculated view
view_camera[0] = camera_create_view(0, 0, view_wview[0], view_hview[0]);

// Set GUI to scale with window
display_set_gui_maximise();
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
// Permanent animated wave segments for Living Weave
global.permanent_wave_segments = ds_list_create();

// Shape fill surface for visual effects
shape_fill_surface = surface_create(canvas_width, canvas_height);
surface_set_target(shape_fill_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// XP particle system
global.xp_particles = ds_list_create();

// Shape fill surface for visual effects
shape_fill_surface = surface_create(canvas_width, canvas_height);
surface_set_target(shape_fill_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();