// ===== obj_ghost - CREATE EVENT =====
// Copy this entire block into obj_ghost Create Event

player_id = -1;
target_x = x;
target_y = y;
image_alpha = 0.5; // CUSTOMIZE: Ghost transparency (try 0.2-0.8)
image_blend = c_white;

// Add after existing properties:
// Trail painting properties
ghost_color = choose(c_lime, c_aqua, c_yellow, c_orange, c_fuchsia);
last_paint_x = x;
last_paint_y = y;

// Shard collection for multiplayer
shards = 0; // Track shards collected by this ghost player
