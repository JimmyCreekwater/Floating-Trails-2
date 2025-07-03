// ===== obj_player - STEP EVENT =====
// ALL movement, painting, and update logic goes here
// Player movement
scr_player_movement();
// Camera control
scr_camera_control();
// Paint trails when moving (FIXED ETCH-A-SKETCH SYSTEM)
// Paint trails when moving (ETCH-A-SKETCH + XP SYSTEM)

// Detect disconnection for autonomous art mode
if (!instance_exists(obj_game) || global.client < 0) {
    if (player_connected) {
        // Just disconnected - start autonomous mode
        player_connected = false;
        disconnection_time = current_time;
        random_animation_seed = random(1000);
    }
} else {
    player_connected = true;
}


if (current_speed > 0.5) {
    var paint_distance = point_distance(x, y, last_paint_x, last_paint_y);
    
    // FIXED: Adaptive paint frequency based on speed
    var paint_threshold = max(1, 3 - current_speed);
    
    if (paint_distance > paint_threshold) {
        // Draw smooth line on canvas WITH XP TRACKING
        if (surface_exists(obj_game.trail_canvas)) {
            surface_set_target(obj_game.trail_canvas);
            
            draw_set_color(my_trail_color);
            
            // FIXED: Separate brush size calculation system
            var base_brush_size = 2;
            var speed_ratio = current_speed / base_speed;
            var speed_brush_modifier = lerp(0.5, 1.5, speed_ratio);
            
            // FIXED: Add explicit sprint/crouch modifiers (BALANCED)
            var mode_brush_modifier = 1;
            if (keyboard_check(vk_shift)) {
                mode_brush_modifier = 1.8; // Sprint = moderately thicker lines
            } else if (keyboard_check(vk_control)) {
                mode_brush_modifier = 0.6; // Crouch = moderately thin lines
            }
            
            // Final brush size combines all factors
            var final_brush_size = base_brush_size * speed_brush_modifier * mode_brush_modifier;
            
           // LIVING WEAVE: Transform painting into sine waves when active
if (living_weave_active && living_weave_unlocked) {
    // Draw wavy lines instead of straight lines
    var line_length = point_distance(last_paint_x, last_paint_y, x, y);
    var line_dir = point_direction(last_paint_x, last_paint_y, x, y);
    var wave_segments = max(3, line_length / 8); // More segments for longer lines
    
    // Wave parameters based on movement speed
    var wave_frequency = 0.3 + (current_speed * 0.1); // Faster movement = faster waves
    var wave_amplitude = final_brush_size * 2; // Wave height scales with brush size
    var time_offset = current_time * 0.01; // Animation based on time
    
    draw_set_alpha(0.2);
    for (var seg = 0; seg < wave_segments - 1; seg++) {
        var t1 = seg / (wave_segments - 1);
        var t2 = (seg + 1) / (wave_segments - 1);
        
        // Calculate base positions
        var x1 = lerp(last_paint_x, x, t1);
        var y1 = lerp(last_paint_y, y, t1);
        var x2 = lerp(last_paint_x, x, t2);
        var y2 = lerp(last_paint_y, y, t2);
        
        // Add sine wave offset
        var wave1 = sin((t1 * line_length * wave_frequency) + time_offset) * wave_amplitude;
        var wave2 = sin((t2 * line_length * wave_frequency) + time_offset) * wave_amplitude;
        
        // Apply wave perpendicular to line direction
        var perp_dir = line_dir + 90;
        var wave_x1 = x1 + lengthdir_x(wave1, perp_dir);
        var wave_y1 = y1 + lengthdir_y(wave1, perp_dir);
        var wave_x2 = x2 + lengthdir_x(wave2, perp_dir);
        var wave_y2 = y2 + lengthdir_y(wave2, perp_dir);
        
        // Draw wavy line segment
        draw_line_width(wave_x1, wave_y1, wave_x2, wave_y2, final_brush_size * 2);
    }
    
    // Core wavy line
    draw_set_alpha(0.7);
    for (var seg = 0; seg < wave_segments - 1; seg++) {
        var t1 = seg / (wave_segments - 1);
        var t2 = (seg + 1) / (wave_segments - 1);
        
        var x1 = lerp(last_paint_x, x, t1);
        var y1 = lerp(last_paint_y, y, t1);
        var x2 = lerp(last_paint_x, x, t2);
        var y2 = lerp(last_paint_y, y, t2);
        
        var wave1 = sin((t1 * line_length * wave_frequency) + time_offset) * wave_amplitude;
        var wave2 = sin((t2 * line_length * wave_frequency) + time_offset) * wave_amplitude;
        
        var perp_dir = line_dir + 90;
        var wave_x1 = x1 + lengthdir_x(wave1, perp_dir);
        var wave_y1 = y1 + lengthdir_y(wave1, perp_dir);
        var wave_x2 = x2 + lengthdir_x(wave2, perp_dir);
        var wave_y2 = y2 + lengthdir_y(wave2, perp_dir);
        
        draw_line_width(wave_x1, wave_y1, wave_x2, wave_y2, final_brush_size);
    }
    
} else {
    // Normal straight line painting
    draw_set_alpha(0.2);
    draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size * 2); // Glow
    
    draw_set_alpha(0.7);
    draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size); // Core
}

            
			

			
                        // NEW: XP TRACKING + SPARKLE PULSE CREATION
            var pixels_painted = 0;
            var steps = max(1, paint_distance);
            for (var i = 0; i <= steps; i++) {
                var check_x = floor(lerp(last_paint_x, x, i / steps));
                var check_y = floor(lerp(last_paint_y, y, i / steps));
                var pixel_key = string(check_x) + "," + string(check_y);
                
                // Check if this pixel was already painted by anyone
                if (!ds_map_exists(global.painted_pixels, pixel_key)) {
                    // New pixel! Award XP
                    ds_map_add(global.painted_pixels, pixel_key, id);
                    ds_map_add(painted_pixels_this_session, pixel_key, true);
                    pixels_painted++;
                    global.total_pixels_painted++;
                }
            }
            
                             // Q KEY SPARKLE BEAM: Manual activation system
if (keyboard_check_pressed(ord("Q")) && sparkle_pulse_unlocked && pulse_generation_cooldown <= 0) {
    // Create beam at current position
    var beam_start_x = x;
    var beam_start_y = y;
    
    // Calculate target point in movement direction
    var movement_dir = point_direction(last_paint_x, last_paint_y, x, y);
    // Add some randomness to direction for variety
    movement_dir += random_range(-30, 30);
    
    var target_x = beam_start_x + lengthdir_x(beam_max_distance, movement_dir);
    var target_y = beam_start_y + lengthdir_y(beam_max_distance, movement_dir);
    
    // Create animated beam
    var new_beam = [beam_start_x, beam_start_y, beam_start_x, beam_start_y, target_x, target_y, 0.0, beam_lifetime, beam_speed, 0, false];
    ds_list_add(sparkle_beams, new_beam);
    
    // Set cooldown (1 second)
    pulse_generation_cooldown = 60;
	// THIS LINE MIGHT BE MISSING FROM YOUR STEP_0.GML:
	// THIS LINE MIGHT BE MISSING FROM YOUR STEP_0.GML:

    
    // Show activation message
    reward_notification = "SPARKLE BEAM FIRED!";
    reward_notification_timer = 60;
    
    // Limit number of active beams
    while (ds_list_size(sparkle_beams) > 20) {
        ds_list_delete(sparkle_beams, 0);
    }
}

	if (pulse_generation_cooldown > 0) pulse_generation_cooldown--;

// Update animated sparkle beams

// C KEY: Color Selection
if (keyboard_check_pressed(ord("C")) && color_change_cooldown <= 0) {
    current_color_index = (current_color_index + 1) % array_length(color_palette);
    my_trail_color = color_palette[current_color_index];
    color_change_cooldown = 30; // Half second cooldown
    
    // Show color change notification
    reward_notification = "Color Changed!";
    reward_notification_timer = 60; // 1 second
}
// Decrease color change cooldown
if (color_change_cooldown > 0) {
    color_change_cooldown--;
}


for (var i = ds_list_size(sparkle_beams) - 1; i >= 0; i--) {
    var beam = ds_list_find_value(sparkle_beams, i);
    
    if (!beam[10]) { // If not exploded yet
        // Move beam toward target
        var move_x = lengthdir_x(beam[8], point_direction(beam[2], beam[3], beam[4], beam[5]));
        var move_y = lengthdir_y(beam[8], point_direction(beam[2], beam[3], beam[4], beam[5]));
        
        beam[2] += move_x; // Update current_x
        beam[3] += move_y; // Update current_y
        beam[6] += 0.02;   // Update travel_progress
        
        // Check if beam should explode
        var distance_traveled = point_distance(beam[0], beam[1], beam[2], beam[3]);
        var distance_to_target = point_distance(beam[2], beam[3], beam[4], beam[5]);
        
        if (distance_traveled >= beam_max_distance || distance_to_target < 5 || beam[6] >= 1.0) {
            // EXPLODE!
            beam[10] = true; // Mark as exploded
            beam[9] = explosion_duration; // Start explosion timer
            
            // Create explosion effect
            var explosion = [beam[2], beam[3], explosion_duration, explosion_duration];
            ds_list_add(explosion_effects, explosion);
            
			// Create 2-4 shards randomly for variety
			var shard_count = irandom_range(2, 4);
			for (var shard_i = 0; shard_i < shard_count; shard_i++) {
			    var random_distance = random_range(60, 120);
			    var random_angle = random(360);
    
			    var shard_x = beam[2] + lengthdir_x(random_distance, random_angle);
			    var shard_y = beam[3] + lengthdir_y(random_distance, random_angle);
    
			    var new_shard = instance_create_layer(shard_x, shard_y, "Instances", obj_shard);
}
// DEBUG: Show shard count ONCE per explosion (remove after testing)
show_debug_message("Created " + string(shard_count) + " shards at explosion");


			

        }
    } else {
        // Handle explosion animation
        beam[9]--; // Decrease explosion timer
        if (beam[9] <= 0) {
            // Explosion finished, remove beam
            ds_list_delete(sparkle_beams, i);
        }
    }
    
    // Remove beam if lifetime expired
    beam[7]--; // Decrease lifetime
    if (beam[7] <= 0) {
        ds_list_delete(sparkle_beams, i);
    }
}
// Update explosion effects
for (var i = ds_list_size(explosion_effects) - 1; i >= 0; i--) {
    var explosion = ds_list_find_value(explosion_effects, i);
    explosion[2]--; // Decrease timer
    
    if (explosion[2] <= 0) {
        ds_list_delete(explosion_effects, i);
    }
}


            
            // Award XP for new pixels
            if (pixels_painted > 0) {
                ink_xp += pixels_painted;
                
                // Check for level up
                if (player_level < 10 && ink_xp >= xp_needed[player_level]) {
                    player_level++;
                    just_leveled_up = true;
                    level_up_timer = 120; // Show notification for 2 seconds
    
                    // Check if neon trail should be unlocked when leveling up
                    if (!neon_trail_unlocked && player_level >= 5) {
                        neon_trail_unlocked = true;
                        reward_notification = "NEON TRAIL UNLOCKED! Press N to toggle";
                        reward_notification_timer = 240; // 4 seconds
                    }
                    
                    // Check if sparkle pulse should be unlocked
                    if (!sparkle_pulse_unlocked && gems >= 15 && event_tickets >= 3) {
                        sparkle_pulse_unlocked = true;
                        reward_notification = "SPARKLE PULSE UNLOCKED! Press P to toggle";
                        reward_notification_timer = 240; // 4 seconds
                    }
					
					// Check for Living Weave unlock (Level 8)
					if (player_level >= 8 && !living_weave_unlocked) {
					    living_weave_unlocked = true;
					    reward_notification = "LIVING WEAVE UNLOCKED! Press W to transform your trails!";
					    reward_notification_timer = 180; // 3 seconds
					}

                }
            }
			
			            // Add brush dot at current position
            draw_circle(x, y, final_brush_size / 2, false);
            
// PHASE 4B: Neon trail effect (WITH BRUSH SIZE SCALING)
if (neon_trail_active && neon_trail_unlocked) {
    // Only create segments when actually moving
    if (paint_distance > 3) {
        // Calculate brush size (same logic as main painting)
        var base_brush_size = 2;
        var speed_ratio = current_speed / base_speed;
        var speed_brush_modifier = lerp(0.5, 1.5, speed_ratio);
        
        var mode_brush_modifier = 1;
        if (keyboard_check(vk_shift)) {
            mode_brush_modifier = 1.8; // Sprint = thicker
        } else if (keyboard_check(vk_control)) {
            mode_brush_modifier = 0.6; // Crouch = thinner
        }
        
        var final_brush_size = base_brush_size * speed_brush_modifier * mode_brush_modifier;
        
        // Store segment with brush size: [start_x, start_y, end_x, end_y, timer, color, brush_size]
        var segment = [last_paint_x, last_paint_y, x, y, neon_fade_time, my_trail_color, final_brush_size];
        ds_list_add(neon_segments, segment);
        
        // Limit segment count for performance
        while (ds_list_size(neon_segments) > 200) {
            ds_list_delete(neon_segments, 0);
        }
    }
}

// LIVING WEAVE: Store painted segments with FULL MOVEMENT DATA
if (current_speed > 0.5 && paint_distance > paint_threshold) {
    // Calculate movement direction and speed intensity
    var movement_direction = point_direction(last_paint_x, last_paint_y, x, y);
    var speed_intensity = min(current_speed / 10, 1); // Normalize to 0-1
    var direction_change = abs(angle_difference(movement_direction, last_movement_direction));
    
    // Store comprehensive movement data for each trail segment
    var trail_segment = [
        last_paint_x,           // [0] start_x
        last_paint_y,           // [1] start_y  
        x,                      // [2] end_x
        y,                      // [3] end_y
        current_time,           // [4] creation_time
        my_trail_color,         // [5] segment_color
        final_brush_size,       // [6] brush_size
        current_speed,          // [7] creation_speed
        movement_direction,     // [8] movement_direction
        speed_intensity,        // [9] speed_intensity
        direction_change,       // [10] direction_change_amount
        0,                      // [11] personal_time_offset (for individual segment animation)
        keyboard_check(vk_shift), // [12] was_sprinting
        keyboard_check(vk_control) // [13] was_crouching
    ];
    
    ds_list_add(global.painted_trail_segments, trail_segment);
    
    // Update last movement direction for next frame
    last_movement_direction = movement_direction;
    
    // Keep only recent segments for performance
    while (ds_list_size(global.painted_trail_segments) > 500) {
        ds_list_delete(global.painted_trail_segments, 0);
    }
}


            surface_reset_target();
        }
        
        last_paint_x = x;
        last_paint_y = y;
    }
}

// W KEY: Toggle Living Weave Pattern  
if (keyboard_check_pressed(ord("W")) && living_weave_unlocked) {
    living_weave_active = !living_weave_active;
    
    if (living_weave_active) {
        reward_notification = "Living Weave ACTIVATED - Your art comes alive!";
    } else {
        reward_notification = "Living Weave DEACTIVATED";
    }
    
    reward_notification_timer = 90;
}

speed_sample_timer++;
if (speed_sample_timer >= speed_sample_interval) {
    ds_list_add(movement_speed_history, current_speed);
    
    // Keep only recent speed samples
    while (ds_list_size(movement_speed_history) > 10) {
        ds_list_delete(movement_speed_history, 0);
    }
    
    // Calculate speed multiplier for wave animation
    var avg_speed = 0;
    for (var i = 0; i < ds_list_size(movement_speed_history); i++) {
        avg_speed += ds_list_find_value(movement_speed_history, i);
    }
    if (ds_list_size(movement_speed_history) > 0) {
        avg_speed /= ds_list_size(movement_speed_history);
        wave_speed_multiplier = 1 + (avg_speed / base_speed);
    }
    
    speed_sample_timer = 0;
}

// PHASE 4B: Shape detection check
last_shape_check++;
if (last_shape_check >= shape_check_interval) {
    last_shape_check = 0;
    
    var detected_shape_size = scr_detect_shapes();
    if (detected_shape_size > 0) {
        // Shape completed! Award rewards
        ink_xp += 50;
        gems += 1;
        
        // Show notification
        reward_notification = "SHAPE COMPLETED! +50 XP, +1 Gem";
        reward_notification_timer = 180; // 3 seconds
        
        // Check for level up
        if (player_level < 6 && ink_xp >= xp_needed[player_level]) {
            player_level++;
            just_leveled_up = true;
            level_up_timer = 120;
        }
        
        // Check if neon trail should be unlocked
        if (!neon_trail_unlocked) {
            if (player_level >= 5 || shards >= 250) {
                neon_trail_unlocked = true;
                reward_notification = "NEON TRAIL UNLOCKED! Press N to toggle";
                reward_notification_timer = 240; // 4 seconds
            }
        }
    }
}



// DEBUG: Show shape detection info (OPTIONAL - remove after testing)
if (keyboard_check_pressed(ord("T"))) {
    var debug_result = scr_detect_shapes();
    show_debug_message("Shape detection result: " + string(debug_result));
    
    // Show some stats
    show_debug_message("Player position: " + string(x) + ", " + string(y));
    show_debug_message("Total painted pixels: " + string(global.total_pixels_painted));
    show_debug_message("Player XP: " + string(ink_xp));
    show_debug_message("Player Level: " + string(player_level));
}



// Neon trail toggle
if (keyboard_check_pressed(ord("N")) && neon_trail_unlocked) {
    neon_trail_active = !neon_trail_active;
    if (neon_trail_active) {
        reward_notification = "Neon Trail ON";
    } else {
        reward_notification = "Neon Trail OFF";
    }
    reward_notification_timer = 60;
}
// Update neon trail segments
if (neon_trail_active && ds_list_size(neon_segments) > 0) {
    for (var i = ds_list_size(neon_segments) - 1; i >= 0; i--) {
        var segment = ds_list_find_value(neon_segments, i);
        segment[4]--; // Decrease timer
        
        if (segment[4] <= 0) {
            ds_list_delete(neon_segments, i);
        }
    }
}
// Reward notifications timer
if (reward_notification_timer > 0) {
    reward_notification_timer--;
}

// P key now toggles sparkle pulse mode (unlocks Q key usage)
if (keyboard_check_pressed(ord("P")) && sparkle_pulse_unlocked && pulse_toggle_cooldown <= 0) {
    sparkle_pulse_active = !sparkle_pulse_active;
    if (sparkle_pulse_active) {
        reward_notification = "Sparkle Pulse MODE ON - Press Q to fire!";
    } else {
        // Clear existing beams when turning off
        ds_list_clear(sparkle_beams);
        ds_list_clear(explosion_effects);
        reward_notification = "Sparkle Pulse MODE OFF";
    }
    reward_notification_timer = 90;
    pulse_toggle_cooldown = 30;
}

// W KEY: Toggle Living Weave Pattern
if (keyboard_check_pressed(ord("W")) && living_weave_unlocked && weave_toggle_cooldown <= 0) {
    living_weave_active = !living_weave_active;
    
    if (living_weave_active) {
        // Clear other effects for clean weave display
        neon_trail_active = false;
        sparkle_pulse_active = false;
        ds_list_clear(weave_segments); // Start fresh
        reward_notification = "Living Weave ACTIVATED - Kinetic Art Mode!";
    } else {
        ds_list_clear(weave_segments);
        reward_notification = "Living Weave DEACTIVATED";
    }
    
    reward_notification_timer = 90;
    weave_toggle_cooldown = 30;
}
// Decrement weave cooldown
if (weave_toggle_cooldown > 0) weave_toggle_cooldown--;



// Update animated sparkle beams
for (var i = ds_list_size(sparkle_beams) - 1; i >= 0; i--) {
    var beam = ds_list_find_value(sparkle_beams, i);
    
    if (!beam[10]) { // If not exploded yet
        // Move beam toward target
        var move_x = lengthdir_x(beam[8], point_direction(beam[2], beam[3], beam[4], beam[5]));
        var move_y = lengthdir_y(beam[8], point_direction(beam[2], beam[3], beam[4], beam[5]));
        
        beam[2] += move_x; // Update current_x
        beam[3] += move_y; // Update current_y
        beam[6] += 0.02;   // Update travel_progress
        
        // Check if beam should explode
        var distance_traveled = point_distance(beam[0], beam[1], beam[2], beam[3]);
        var distance_to_target = point_distance(beam[2], beam[3], beam[4], beam[5]);
        
        if (distance_traveled >= beam_max_distance || distance_to_target < 5 || beam[6] >= 1.0) {
            // EXPLODE!
            beam[10] = true; // Mark as exploded
            beam[9] = explosion_duration; // Start explosion timer
            
            // Create explosion effect
            var explosion = [beam[2], beam[3], explosion_duration, explosion_duration];
            ds_list_add(explosion_effects, explosion);
            
            // Create shard at explosion location
            var new_shard = instance_create_layer(beam[2], beam[3], "Instances", obj_shard);
        }
    } else {
        // Handle explosion animation
        beam[9]--; // Decrease explosion timer
        if (beam[9] <= 0) {
            // Explosion finished, remove beam
            ds_list_delete(sparkle_beams, i);
        }
    }
    
    // Remove beam if lifetime expired
    beam[7]--; // Decrease lifetime
    if (beam[7] <= 0) {
        ds_list_delete(sparkle_beams, i);
    }
}
// Update explosion effects
for (var i = ds_list_size(explosion_effects) - 1; i >= 0; i--) {
    var explosion = ds_list_find_value(explosion_effects, i);
    explosion[2]--; // Decrease timer
    
    if (explosion[2] <= 0) {
        ds_list_delete(explosion_effects, i);
    }
}



// Send position over network
if (point_distance(x, y, last_sent_x, last_sent_y) > 16) {
    scr_networking();
    last_sent_x = x;
    last_sent_y = y;
}


// World boundaries (solid walls - no wrap lines!)
if (x < 50) {
    x = 50;
    velocity_x = 0; // Stop horizontal movement
}
if (x > room_width - 50) {
    x = room_width - 50;
    velocity_x = 0; // Stop horizontal movement
}
if (y < 50) {
    y = 50;
    velocity_y = 0; // Stop vertical movement
}
if (y > room_height - 50) {
    y = room_height - 50;
    velocity_y = 0; // Stop vertical movement
}


// IMPROVED MANUAL TEST: Press M to create proper path segments
if (keyboard_check_pressed(ord("M"))) {
    // Create neon segment following recent movement
    if (point_distance(x, y, last_paint_x, last_paint_y) > 5) {
        var neon_seg = [last_paint_x, last_paint_y, x, y, 0, c_red];
        ds_list_add(neon_segments, neon_seg);
        show_debug_message("Created NEON segment from path");
    }
    
    // Create weave segment following recent movement with sine wave
    if (point_distance(x, y, last_paint_x, last_paint_y) > 5) {
        var wave_offset = sin(current_time * 0.01) * 20;  // Sine wave effect
        var weave_seg = [last_paint_x + wave_offset, last_paint_y, x + wave_offset, y, weave_time, 100, c_blue];
        ds_list_add(weave_segments, weave_seg);
        show_debug_message("Created WEAVE segment from path with wave");
    }
    
    // Update paint position
    last_paint_x = x;
    last_paint_y = y;
}

// STRUCTURE DEBUG: Press S to see segment structures  
if (keyboard_check_pressed(ord("S"))) {
    if (ds_list_size(neon_segments) > 0) {
        var seg = ds_list_find_value(neon_segments, ds_list_size(neon_segments) - 1);
        show_debug_message("NEON structure: [" + string(seg[0]) + "," + string(seg[1]) + "," + string(seg[2]) + "," + string(seg[3]) + "," + string(seg[4]) + "," + string(seg[5]) + "]");
    }
    
    if (ds_list_size(weave_segments) > 0) {
        var seg = ds_list_find_value(weave_segments, ds_list_size(weave_segments) - 1);
        show_debug_message("WEAVE structure: [" + string(seg[0]) + "," + string(seg[1]) + "," + string(seg[2]) + "," + string(seg[3]) + "," + string(seg[4]) + "," + string(seg[5]) + "," + string(seg[6]) + "]");
    }
}

// WEAVE DEBUG: Press V to see weave status
if (keyboard_check_pressed(ord("V"))) {
    show_debug_message("=== WEAVE DEBUG ===");
    show_debug_message("living_weave_unlocked: " + string(living_weave_unlocked));
    show_debug_message("living_weave_active: " + string(living_weave_active));
    show_debug_message("weave_segments count: " + string(ds_list_size(weave_segments)));
    show_debug_message("current_speed: " + string(current_speed));
    
    if (ds_list_size(weave_segments) > 0) {
        var seg = ds_list_find_value(weave_segments, ds_list_size(weave_segments) - 1);
        show_debug_message("Last weave segment color: " + string(seg[6]));
        show_debug_message("Segment structure: [" + string(seg[0]) + "," + string(seg[1]) + "," + string(seg[2]) + "," + string(seg[3]) + "," + string(seg[4]) + "," + string(seg[5]) + "," + string(seg[6]) + "]");
    }
    show_debug_message("==================");
}
