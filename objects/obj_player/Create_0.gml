// ===== obj_player - CREATE EVENT =====
// ONLY initialization code goes here - NO drawing or step logic!
// Player properties
speed = 4; // CUSTOMIZE: Change movement speed (try 2-8)
image_blend = c_white;
// Enhanced movement properties
max_speed = 4;
base_speed = 4;          // NEW: Base movement speed
sprint_speed = 7;        // NEW: Sprint speed (Shift)
crouch_speed = 1.5;      // NEW: Crouch speed (Ctrl)

acceleration = 0.3;
friction = 0.95;
turn_speed = 0.15;
current_speed = 0;
move_direction = 0;
velocity_x = 0;
velocity_y = 0;
// Networking
last_sent_x = x;
last_sent_y = y;
// FIXED: Add trail timing
trail_timer = 0;
trail_interval = 3; // Create trail every 3 frames
// Trail painting properties

// =====COLOR SELECTION SYSTEM=====
color_palette = [c_red, c_lime, c_blue, c_yellow, c_fuchsia, make_color_rgb(0,255,255), c_orange, c_white, make_color_rgb(128,0,128), make_color_rgb(0,255,200)];
current_color_index = 0;
my_trail_color = color_palette[current_color_index];
color_change_cooldown = 0;

// Color will be set by color selection system above
last_paint_x = x;
last_paint_y = y;
brush_size = 2; // FIXED: Define brush_size variable!

// Start in center of large world
if (x == 0 && y == 0) {
    x = room_width / 2;
    y = room_height / 2;
}

// =====PHASE 4B: REWARD SYSTEM=====
// Unlocked rewards
neon_trail_unlocked = false;
neon_trail_active = false;
// Neon trail effect properties
neon_fade_time = 480; // 8 seconds at 60fps
// Shape detection
last_shape_check = 0;
shape_check_interval = 60; // Check for shapes every 1 second
// UI notifications
reward_notification = "";
reward_notification_timer = 0;

// =====PHASE 4A: PROGRESSION SYSTEM=====
// Player progression stats
ink_xp = 0;
player_level = 1;
shards = 0;
gems = 0;
event_tickets = 0;
xp_needed = [0, 100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000]; // Index 0 unused, levels 1-10
// Pixel tracking for rewards
painted_pixels_this_session = ds_map_create(); // Track our own pixels this session
// UI positioning
ui_x = 20;
ui_y = 20;
// Level up notification
level_up_timer = 0;
just_leveled_up = false;

// =====PHASE 4C: ANIMATED SPARKLE BEAM SYSTEM=====
sparkle_pulse_unlocked = false;
sparkle_pulse_active = false;
// Beam generation
pulse_distance_tracker = 0;
pulse_spawn_interval = 15; // Every 25 pixels
// Animated beam storage: [start_x, start_y, current_x, current_y, target_x, target_y, travel_progress, lifetime, beam_speed, explosion_timer, exploded]
sparkle_beams = ds_list_create();
beam_lifetime = 180; // 3 seconds max travel time
beam_speed = 4; // Pixels per frame travel speed
beam_max_distance = 100; // Maximum travel distance before explosion
// Explosion effects storage: [x, y, explosion_timer, max_timer]
explosion_effects = ds_list_create();
explosion_duration = 30; // Half second explosion effect
// Collection balancing
pulse_toggle_cooldown = 0;
pulse_generation_cooldown = 0;
// FORCE UNLOCK FOR TESTING (remove later)
gems = 15;
event_tickets = 3;

// =====PHASE 4D: LIVING WEAVE PATTERN SYSTEM=====
living_weave_unlocked = false;
living_weave_active = false;
// Wave animation properties
weave_time = 0; // Global animation timer
wave_frequency = 0.05; // Base wave frequency
wave_amplitude = 8; // Wave height in pixels
wave_speed_multiplier = 1.0; // Speed-based frequency multiplier
// Speed tracking for animation
movement_speed_history = ds_list_create(); // Track recent speeds
speed_sample_interval = 5; // Sample speed every 5 frames
speed_sample_timer = 0;
// Control cooldowns
weave_toggle_cooldown = 0;
// Enhanced movement tracking for responsive kinetic art
last_movement_direction = 0;
player_connected = true;
disconnection_time = 0;
random_animation_seed = random(1000);

// Living Weave Mode System
weave_mode = 0; // 0 = Wave, 1 = ZigZag, 2 = Candy Cane, 3 = Heartbeat
weave_mode_names = ["Wave Flow", "Lightning Strike", "Candy Swirl", "Heartbeat Pulse"];
weave_mode_count = 4;
weave_mode_cooldown = 0;

// Candy Cane mode specific
candy_rotation_offset = 0;
global.permanent_wave_segments = ds_list_create();


// Window Sizing

// ADD THIS TO obj_game Create Event (at the end):

// ===== WINDOW AND DISPLAY SETUP =====
// Get display size
var display_w = display_get_width();
var display_h = display_get_height();

// Set a reasonable default window size (80% of screen)
var window_w = display_w * 0.8;
var window_h = display_h * 0.8;

// Make sure it's not bigger than the room
window_w = min(window_w, 1366);
window_h = min(window_h, 768);

// Set window size and center it
window_set_size(window_w, window_h);
window_center();

// Enable window resizing
window_set_min_width(800);
window_set_min_height(600);
window_set_max_width(display_w);
window_set_max_height(display_h);

// Set up proper GUI scaling
display_set_gui_size(1366, 768); // Fixed GUI size for consistent UI

// Enable the application surface for proper scaling
application_surface_draw_enable(true);

// Start windowed (not fullscreen)
window_set_fullscreen(false);

// Drawing control
drawing_enabled = true;
drawing_toggle_cooldown = 0;

// Shape detection system
shape_path_points = ds_list_create(); // Track recent drawing path
max_path_points = 300; // Keep last 200 points
shape_check_cooldown = 0;
shape_flash_list = ds_list_create(); // Store completed shapes for animation

// ADD THIS TO obj_game Create Event (at the end):



// XP particle system
global.xp_particles = ds_list_create();

// ADD to obj_player Create Event:

// Shape detection helpers
stop_timer = 0;
// Shape recognition
current_shape_preview = "";
// Shape gallery UI
shapes_scroll_offset = 0;

// Shape detection variables
shape_clearing_timer = 0;