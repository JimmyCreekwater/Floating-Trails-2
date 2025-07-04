// ===== obj_player - STEP EVENT =====
// ALL movement, painting, and update logic goes here

// Player movement
scr_player_movement();

// Camera control
scr_camera_control();

// SPACE KEY: Toggle drawing on/off
if (keyboard_check_pressed(vk_space) && drawing_toggle_cooldown <= 0) {
    drawing_enabled = !drawing_enabled;
	// When turning drawing back ON, start fresh
if (drawing_enabled) {
    ds_list_clear(shape_path_points);
}
    reward_notification = drawing_enabled ? "Drawing ON" : "Drawing OFF (Move Only)";
    reward_notification_timer = 60;
    drawing_toggle_cooldown = 15;
    
    // Clear path when toggling off
    if (!drawing_enabled) {
        ds_list_clear(shape_path_points);
    }
}
if (drawing_toggle_cooldown > 0) drawing_toggle_cooldown--;

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

// Paint trails when moving (PERMANENT LIVING ART SYSTEM)
if (current_speed > 0.5 && drawing_enabled) {
    var paint_distance = point_distance(x, y, last_paint_x, last_paint_y);
    var paint_threshold = max(1, 3 - current_speed);
    
    if (paint_distance > paint_threshold) {
        // Draw on canvas WITH PERMANENT EFFECTS
        if (surface_exists(obj_game.trail_canvas)) {
            surface_set_target(obj_game.trail_canvas);
            
            draw_set_color(my_trail_color);
            
            // Calculate brush size
            var base_brush_size = 2;
            var speed_ratio = current_speed / base_speed;
            var speed_brush_modifier = lerp(0.5, 1.5, speed_ratio);
            
            var mode_brush_modifier = 1;
            if (keyboard_check(vk_shift)) {
                mode_brush_modifier = 1.8;
            } else if (keyboard_check(vk_control)) {
                mode_brush_modifier = 0.6;
            }
            
            var final_brush_size = base_brush_size * speed_brush_modifier * mode_brush_modifier;
            
            // PERMANENT LIVING WEAVE: Bake the wave pattern directly onto canvas
          // REPLACE the Living Weave painting section in Step_0.gml with this expanded version:

// PERMANENT LIVING WEAVE: Bake the wave pattern directly onto canvas
if (living_weave_active && living_weave_unlocked) {
    var line_length = point_distance(last_paint_x, last_paint_y, x, y);
    var line_dir = point_direction(last_paint_x, last_paint_y, x, y);
    var time_offset = current_time * 0.01;
    
    switch (weave_mode) {
        case 0: // WAVE FLOW (original)
            var wave_segments = max(3, line_length / 8);
            var wave_frequency = 0.3 + (current_speed * 0.1);
            var wave_amplitude = final_brush_size * 4;
            
            // Multi-layer wave for depth
            draw_set_alpha(0.2);
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
            break;
            
        case 1: // LIGHTNING STRIKE (ZigZag)
            var zig_segments = max(4, line_length / 20);
            var zig_amplitude = final_brush_size * 5;
            
            // Electric glow
            draw_set_alpha(0.3);
            draw_set_color(merge_color(my_trail_color, c_white, 0.5));
            
            for (var seg = 0; seg < zig_segments - 1; seg++) {
                var t1 = seg / (zig_segments - 1);
                var t2 = (seg + 1) / (zig_segments - 1);
                
                var x1 = lerp(last_paint_x, x, t1);
                var y1 = lerp(last_paint_y, y, t1);
                var x2 = lerp(last_paint_x, x, t2);
                var y2 = lerp(last_paint_y, y, t2);
                
                // Sharp zigzag pattern
                var zig_offset1 = (seg % 2 == 0 ? 1 : -1) * zig_amplitude;
                var zig_offset2 = ((seg + 1) % 2 == 0 ? 1 : -1) * zig_amplitude;
                
                var perp_dir = line_dir + 90;
                var zig_x1 = x1 + lengthdir_x(zig_offset1, perp_dir);
                var zig_y1 = y1 + lengthdir_y(zig_offset1, perp_dir);
                var zig_x2 = x2 + lengthdir_x(zig_offset2, perp_dir);
                var zig_y2 = y2 + lengthdir_y(zig_offset2, perp_dir);
                
                draw_line_width(zig_x1, zig_y1, zig_x2, zig_y2, final_brush_size * 3);
            }
            
            // Sharp core
            draw_set_alpha(0.8);
            draw_set_color(my_trail_color);
            for (var seg = 0; seg < zig_segments - 1; seg++) {
                var t1 = seg / (zig_segments - 1);
                var t2 = (seg + 1) / (zig_segments - 1);
                
                var x1 = lerp(last_paint_x, x, t1);
                var y1 = lerp(last_paint_y, y, t1);
                var x2 = lerp(last_paint_x, x, t2);
                var y2 = lerp(last_paint_y, y, t2);
                
                var zig_offset1 = (seg % 2 == 0 ? 1 : -1) * zig_amplitude;
                var zig_offset2 = ((seg + 1) % 2 == 0 ? 1 : -1) * zig_amplitude;
                
                var perp_dir = line_dir + 90;
                var zig_x1 = x1 + lengthdir_x(zig_offset1, perp_dir);
                var zig_y1 = y1 + lengthdir_y(zig_offset1, perp_dir);
                var zig_x2 = x2 + lengthdir_x(zig_offset2, perp_dir);
                var zig_y2 = y2 + lengthdir_y(zig_offset2, perp_dir);
                
                draw_line_width(zig_x1, zig_y1, zig_x2, zig_y2, final_brush_size);
            }
            break;
            
        case 2: // CANDY SWIRL
            var spiral_segments = max(6, line_length / 5);
            var spiral_radius = final_brush_size * 4;
            
            // Draw two intertwining spirals
            for (var spiral = 0; spiral < 2; spiral++) {
                var spiral_color = (spiral == 0) ? my_trail_color : merge_color(my_trail_color, c_white, 0.7);
                draw_set_color(spiral_color);
                draw_set_alpha(0.8);
                
                for (var seg = 0; seg < spiral_segments - 1; seg++) {
                    var t1 = seg / (spiral_segments - 1);
                    var t2 = (seg + 1) / (spiral_segments - 1);
                    
                    var x1 = lerp(last_paint_x, x, t1);
                    var y1 = lerp(last_paint_y, y, t1);
                    var x2 = lerp(last_paint_x, x, t2);
                    var y2 = lerp(last_paint_y, y, t2);
                    
                    // Spiral offset
                    var spiral_angle1 = (t1 * 720) + (spiral * 180) + time_offset * 20;
                    var spiral_angle2 = (t2 * 720) + (spiral * 180) + time_offset * 20;
                    
                    var spiral_x1 = x1 + lengthdir_x(spiral_radius, spiral_angle1);
                    var spiral_y1 = y1 + lengthdir_y(spiral_radius, spiral_angle1);
                    var spiral_x2 = x2 + lengthdir_x(spiral_radius, spiral_angle2);
                    var spiral_y2 = y2 + lengthdir_y(spiral_radius, spiral_angle2);
                    
                    draw_line_width(spiral_x1, spiral_y1, spiral_x2, spiral_y2, final_brush_size * 1.5);
                }
            }
            
            // Center guide line
            draw_set_alpha(0.4);
            draw_set_color(my_trail_color);
            draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size * 0.5);
            break;
            
        case 3: // HEARTBEAT PULSE
            var pulse_segments = max(4, line_length / 15);
            var pulse_base_amp = final_brush_size * 3;
            
            // Outer pulse glow
            draw_set_alpha(0.2);
            draw_set_color(merge_color(my_trail_color, c_red, 0.3));
            
            for (var seg = 0; seg < pulse_segments - 1; seg++) {
                var t1 = seg / (pulse_segments - 1);
                var t2 = (seg + 1) / (pulse_segments - 1);
                
                var x1 = lerp(last_paint_x, x, t1);
                var y1 = lerp(last_paint_y, y, t1);
                var x2 = lerp(last_paint_x, x, t2);
                var y2 = lerp(last_paint_y, y, t2);
                
                // Heartbeat pattern
                var beat_phase1 = t1 * 4 * pi;
                var beat_phase2 = t2 * 4 * pi;
                var beat1 = sin(beat_phase1) * exp(-t1 * 2) * pulse_base_amp * 2;
                var beat2 = sin(beat_phase2) * exp(-t2 * 2) * pulse_base_amp * 2;
                
                var perp_dir = line_dir + 90;
                var beat_x1 = x1 + lengthdir_x(beat1, perp_dir);
                var beat_y1 = y1 + lengthdir_y(beat1, perp_dir);
                var beat_x2 = x2 + lengthdir_x(beat2, perp_dir);
                var beat_y2 = y2 + lengthdir_y(beat2, perp_dir);
                
                draw_line_width(beat_x1, beat_y1, beat_x2, beat_y2, final_brush_size * 3);
            }
			
// Shape detection check
if (drawing_enabled && shape_check_cooldown <= 0) {
    shape_check_cooldown = 30; // Check every half second
    
    // Check if we're drawing a recognized shape
    current_shape_preview = scr_recognize_shape();
    
    // Check if shape is complete (back at start)
    if (ds_list_size(shape_path_points) > 8) {
        var first = ds_list_find_value(shape_path_points, 0);
        var last = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
        var close_dist = point_distance(first[0], first[1], last[0], last[1]);
        
        if (close_dist < 30 && current_shape_preview != "") {
            // Shape completed!
            var shape_value = global.shape_points[? current_shape_preview];
            ink_xp += shape_value;
            gems += floor(shape_value / 50);
            
            reward_notification = current_shape_preview + " COMPLETE! +" + string(shape_value) + " XP";
            reward_notification_timer = 180;
            
            // Create visual effect
            create_shape_completion_effect(current_shape_preview);
            
            // Clear path
            ds_list_clear(shape_path_points);
            current_shape_preview = "";
        }
    }
}
if (shape_check_cooldown > 0) shape_check_cooldown--;

// Update shape flash animations
for (var i = ds_list_size(shape_flash_list) - 1; i >= 0; i--) {
    var shape_data = ds_list_find_value(shape_flash_list, i);
    shape_data[6]--; // Decrease timer
    
    // Spawn particles at the right moment
    if (shape_data[6] == 90 && !shape_data[9]) {
        shape_data[9] = true; // Mark as spawned
        var bonus_xp = 50 + floor(shape_data[7] / 100);
        scr_create_xp_particles(shape_data[1], shape_data[2], bonus_xp, 1);
    }
    
    // Update fill alpha (fade out in last second)
    if (shape_data[6] < 60) {
        shape_data[8] = shape_data[6] / 60;
    }
    
    if (shape_data[6] <= 0) {
        // Cleanup shape points list
        ds_list_destroy(shape_data[0]);
        ds_list_delete(shape_flash_list, i);
    }
}

// Update XP particles
for (var i = ds_list_size(global.xp_particles) - 1; i >= 0; i--) {
    var particle = ds_list_find_value(global.xp_particles, i);
    
    // Handle delay
    if (particle[12] > 0) {
        particle[12]--;
        continue;
    }
    
    // Update progress
    particle[6] += 1 / particle[7];
    
    if (particle[6] >= 1) {
        // Reached target
        ds_list_delete(global.xp_particles, i);
    } else {
        // Move particle with easing
        var ease = 1 - power(1 - particle[6], 3); // Cubic ease-in
        
        // World to GUI conversion
        var gui_start_x = (particle[2] - camera_get_view_x(view_camera[0])) * (display_get_gui_width() / camera_get_view_width(view_camera[0]));
        var gui_start_y = (particle[3] - camera_get_view_y(view_camera[0])) * (display_get_gui_height() / camera_get_view_height(view_camera[0]));
        
        particle[0] = lerp(gui_start_x, particle[4], ease) + sin(particle[6] * pi * 4) * particle[8];
        particle[1] = lerp(gui_start_y, particle[5], ease) + cos(particle[6] * pi * 4) * particle[9];
    }
}

            // Core pulse
            draw_set_alpha(0.8);
            draw_set_color(my_trail_color);
            for (var seg = 0; seg < pulse_segments - 1; seg++) {
                var t1 = seg / (pulse_segments - 1);
                var t2 = (seg + 1) / (pulse_segments - 1);
                
                var x1 = lerp(last_paint_x, x, t1);
                var y1 = lerp(last_paint_y, y, t1);
                var x2 = lerp(last_paint_x, x, t2);
                var y2 = lerp(last_paint_y, y, t2);
                
                var beat_phase1 = t1 * 4 * pi;
                var beat_phase2 = t2 * 4 * pi;
                var beat1 = sin(beat_phase1) * exp(-t1 * 2) * pulse_base_amp;
                var beat2 = sin(beat_phase2) * exp(-t2 * 2) * pulse_base_amp;
                
                var perp_dir = line_dir + 90;
                var beat_x1 = x1 + lengthdir_x(beat1, perp_dir);
                var beat_y1 = y1 + lengthdir_y(beat1, perp_dir);
                var beat_x2 = x2 + lengthdir_x(beat2, perp_dir);
                var beat_y2 = y2 + lengthdir_y(beat2, perp_dir);
                
                draw_line_width(beat_x1, beat_y1, beat_x2, beat_y2, final_brush_size);
            }
            break;
    }
    
    // Store animation data for PERMANENT kinetic effect
    var wave_data = [
        last_paint_x, last_paint_y, x, y,           // Line segment
        current_time,                                // Creation time
        0.3 + (current_speed * 0.1),                 // Locked frequency
        final_brush_size * 2,                        // Locked amplitude  
        my_trail_color,                              // Color
        final_brush_size,                            // Brush size
        current_speed,                               // Creation speed
        weave_mode                                   // Weave mode when created
    ];
    ds_list_add(global.permanent_wave_segments, wave_data);
}
                
            } else {
                // Normal straight line painting
                draw_set_alpha(0.2);
                draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size * 2);
                
                draw_set_alpha(0.7);
                draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size);
            }
            
            // PERMANENT NEON EFFECT: Bake the glow directly onto canvas
            if (neon_trail_active && neon_trail_unlocked) {
                // Permanent neon glow layers
                draw_set_alpha(0.15);
                draw_set_color(c_white);
                draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size * 8);
                
                draw_set_alpha(0.3);
                draw_set_color(merge_color(my_trail_color, c_white, 0.5));
                draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size * 5);
                
                draw_set_alpha(0.6);
                draw_set_color(my_trail_color);
                draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size * 3);
                
                // Bright core
                draw_set_alpha(0.9);
                draw_set_color(merge_color(my_trail_color, c_white, 0.7));
                draw_line_width(last_paint_x, last_paint_y, x, y, final_brush_size);
            }
            
            // Add brush dot
            draw_set_alpha(0.7);
            draw_set_color(my_trail_color);
            draw_circle(x, y, final_brush_size / 2, false);
            
            draw_set_alpha(1);
            surface_reset_target();
        }
        
        // XP tracking
        var pixels_painted = 0;
        var steps = max(1, paint_distance);
        for (var i = 0; i <= steps; i++) {
            var check_x = floor(lerp(last_paint_x, x, i / steps));
            var check_y = floor(lerp(last_paint_y, y, i / steps));
            var pixel_key = string(check_x) + "," + string(check_y);
            
            if (!ds_map_exists(global.painted_pixels, pixel_key)) {
                ds_map_add(global.painted_pixels, pixel_key, id);
                ds_map_add(painted_pixels_this_session, pixel_key, true);
                pixels_painted++;
                global.total_pixels_painted++;
            }
        }
        
        // Award XP and check level up
        if (pixels_painted > 0) {
            ink_xp += pixels_painted;
            
            if (player_level < 10 && ink_xp >= xp_needed[player_level]) {
                player_level++;
                just_leveled_up = true;
                level_up_timer = 120;
                
                // Unlock checks
                if (!neon_trail_unlocked && player_level >= 5) {
                    neon_trail_unlocked = true;
                    reward_notification = "NEON TRAIL UNLOCKED! Press N to toggle";
                    reward_notification_timer = 240;
                }
                
                if (!sparkle_pulse_unlocked && gems >= 15 && event_tickets >= 3) {
                    sparkle_pulse_unlocked = true;
                    reward_notification = "SPARKLE PULSE UNLOCKED! Press P to toggle";
                    reward_notification_timer = 240;
                }
                
                if (player_level >= 8 && !living_weave_unlocked) {
                    living_weave_unlocked = true;
                    reward_notification = "LIVING WEAVE UNLOCKED! Press W to transform your trails!";
                    reward_notification_timer = 180;
                }
            }
        }
		
		// Track path for shape detection// Track path for shape detection when drawing
if (drawing_enabled && current_speed > 0.5) {
    var paint_distance = point_distance(x, y, last_paint_x, last_paint_y);
    
    if (paint_distance > 8) { // Add points every 8 pixels
        var new_point = [x, y, current_time];
        ds_list_add(shape_path_points, new_point);
        
        // Limit path length for performance
        while (ds_list_size(shape_path_points) > 200) {
            ds_list_delete(shape_path_points, 0);
        }
        
        // Debug path tracking
        if (ds_list_size(shape_path_points) % 20 == 0) {
            show_debug_message("Path points: " + string(ds_list_size(shape_path_points)));
        }
    }
    
    // Real-time shape completion check
    if (ds_list_size(shape_path_points) >= 12) {
        var first_point = ds_list_find_value(shape_path_points, 0);
        var current_point = [x, y, current_time];
        var close_distance = point_distance(first_point[0], first_point[1], current_point[0], current_point[1]);
        
        // Shape completed when we return close to start
        if (close_distance < 40) {
            show_debug_message("SHAPE COMPLETION DETECTED! Distance: " + string(close_distance));
            
            // Try closed shape detection
            var shape_result = scr_detect_closed_shape();
            if (shape_result > 0) {
                show_debug_message("Closed shape confirmed: " + string(shape_result));
                
                // Try to recognize what shape it is
                var recognized_shape = scr_recognize_shape();
                if (recognized_shape != "") {
                    var shape_bonus = global.shape_points[? recognized_shape];
                    ink_xp += shape_bonus;
                    gems += floor(shape_bonus / 50);
                    
                    reward_notification = recognized_shape + " RECOGNIZED! +" + string(shape_bonus) + " XP";
                    reward_notification_timer = 240;
                } else {
                    // Generic shape completion
                    ink_xp += 50;
                    gems += 1;
                    reward_notification = "SHAPE COMPLETE! +50 XP, +1 Gem";
                    reward_notification_timer = 180;
                }
                
                // Level up check
                if (player_level < 10 && ink_xp >= xp_needed[player_level]) {
                    player_level++;
                    just_leveled_up = true;
                    level_up_timer = 120;
                }
                
                // Clear path for next shape
                ds_list_clear(shape_path_points);
            }
        }
    }
    
    // Auto-clear stale paths
    if (ds_list_size(shape_path_points) > 0) {
        var last_point = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
        if (current_time - last_point[2] > 180) { // 3 seconds idle
            ds_list_clear(shape_path_points);
            show_debug_message("Path cleared - too much time elapsed");
        }
    }
} else {
    // Not drawing - clear any incomplete paths
    if (ds_list_size(shape_path_points) > 0) {
        if (!shape_clearing_timer) shape_clearing_timer = 0;
        shape_clearing_timer++;
        
        if (shape_clearing_timer > 60) { // 1 second delay
            ds_list_clear(shape_path_points);
            shape_clearing_timer = 0;
            show_debug_message("Path cleared - stopped drawing");
        }
    }
}
	last_paint_x = x;
    last_paint_y = y;
}

// AUTO-CLEAR old path points
if (ds_list_size(shape_path_points) > 0) {
    var last_point = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
    var time_since_last = current_time - last_point[2];
    
    // If more than 2 seconds since last point, clear the path
    if (time_since_last > 2000) {
        ds_list_clear(shape_path_points);
    }
}

// Track path for shape detection
if (ds_list_size(shape_path_points) == 0) {
    // First point
    var path_point = [x, y, current_time];
    ds_list_add(shape_path_points, path_point);
} else {
    // Add new point if we've moved enough
    var last_path_point = ds_list_find_value(shape_path_points, ds_list_size(shape_path_points) - 1);
    var dist_from_last = point_distance(x, y, last_path_point[0], last_path_point[1]);
    
    if (dist_from_last > 10) {
        var path_point = [x, y, current_time];
        ds_list_add(shape_path_points, path_point);
        
        // Limit path length
        while (ds_list_size(shape_path_points) > max_path_points) {
            ds_list_delete(shape_path_points, 0);
        }
    }
}
        } else {
    // Not drawing - clear path if we have points
    if (ds_list_size(shape_path_points) > 0) {
        // Check if we've stopped for more than 30 frames
        if (!drawing_enabled || current_speed <= 0.5) {
            if (!variable_instance_exists(id, "stop_timer")) {
                stop_timer = 0;
            }
            stop_timer++;
            
            if (stop_timer > 30) {
                ds_list_clear(shape_path_points);
                stop_timer = 0;
                show_debug_message("Path cleared - stopped drawing");
            }
        }
    }
}

        last_paint_x = x;
        last_paint_y = y;



// Q KEY SPARKLE BEAM: Manual activation system
if (keyboard_check_pressed(ord("Q")) && sparkle_pulse_unlocked && sparkle_pulse_active && pulse_generation_cooldown <= 0) {
    // Create beam at current position
    var beam_start_x = x;
    var beam_start_y = y;
    
    // Calculate target point in movement direction
    var movement_dir = point_direction(last_paint_x, last_paint_y, x, y);
    movement_dir += random_range(-30, 30);
    
    var target_x = beam_start_x + lengthdir_x(beam_max_distance, movement_dir);
    var target_y = beam_start_y + lengthdir_y(beam_max_distance, movement_dir);
    
    // Create animated beam
    var new_beam = [beam_start_x, beam_start_y, beam_start_x, beam_start_y, target_x, target_y, 0.0, beam_lifetime, beam_speed, 0, false];
    ds_list_add(sparkle_beams, new_beam);
    
    // Set cooldown
    pulse_generation_cooldown = 60;
    
    // Show activation message
    reward_notification = "SPARKLE BEAM FIRED!";
    reward_notification_timer = 60;
    
    // Limit number of active beams
    while (ds_list_size(sparkle_beams) > 20) {
        ds_list_delete(sparkle_beams, 0);
    }
}

if (pulse_generation_cooldown > 0) pulse_generation_cooldown--;

// C KEY: Color Selection
if (keyboard_check_pressed(ord("C")) && color_change_cooldown <= 0) {
    current_color_index = (current_color_index + 1) % array_length(color_palette);
    my_trail_color = color_palette[current_color_index];
    color_change_cooldown = 30;
    
    reward_notification = "Color Changed!";
    reward_notification_timer = 60;
}

if (color_change_cooldown > 0) {
    color_change_cooldown--;
}

// Update animated sparkle beams
for (var i = ds_list_size(sparkle_beams) - 1; i >= 0; i--) {
    var beam = ds_list_find_value(sparkle_beams, i);
    
    if (!beam[10]) { // If not exploded yet
        // Move beam toward target
        var move_x = lengthdir_x(beam[8], point_direction(beam[2], beam[3], beam[4], beam[5]));
        var move_y = lengthdir_y(beam[8], point_direction(beam[2], beam[3], beam[4], beam[5]));
        
        beam[2] += move_x;
        beam[3] += move_y;
        beam[6] += 0.02;
        
        // Check if beam should explode
        var distance_traveled = point_distance(beam[0], beam[1], beam[2], beam[3]);
        var distance_to_target = point_distance(beam[2], beam[3], beam[4], beam[5]);
        
        if (distance_traveled >= beam_max_distance || distance_to_target < 5 || beam[6] >= 1.0) {
            // EXPLODE!
            beam[10] = true;
            beam[9] = explosion_duration;
            
            // Create explosion effect
            var explosion = [beam[2], beam[3], explosion_duration, explosion_duration];
            ds_list_add(explosion_effects, explosion);
            
            // Create 2-4 shards randomly
            var shard_count = irandom_range(2, 4);
            for (var shard_i = 0; shard_i < shard_count; shard_i++) {
                var random_distance = random_range(60, 120);
                var random_angle = random(360);
                
                var shard_x = beam[2] + lengthdir_x(random_distance, random_angle);
                var shard_y = beam[3] + lengthdir_y(random_distance, random_angle);
                
                var new_shard = instance_create_layer(shard_x, shard_y, "Instances", obj_shard);
            }
        }
    } else {
        // Handle explosion animation
        beam[9]--;
        if (beam[9] <= 0) {
            ds_list_delete(sparkle_beams, i);
        }
    }
    
    // Remove beam if lifetime expired
    beam[7]--;
    if (beam[7] <= 0) {
        ds_list_delete(sparkle_beams, i);
    }
}

// Update explosion effects
for (var i = ds_list_size(explosion_effects) - 1; i >= 0; i--) {
    var explosion = ds_list_find_value(explosion_effects, i);
    explosion[2]--;
    
    if (explosion[2] <= 0) {
        ds_list_delete(explosion_effects, i);
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

// In obj_player Step_0.gml, find the W key toggle and add this RIGHT AFTER it:

// R KEY: Cycle through weave modes (make sure this is OUTSIDE the W key block)
if (keyboard_check_pressed(ord("R")) && living_weave_unlocked && living_weave_active && weave_mode_cooldown <= 0) {
    weave_mode = (weave_mode + 1) % weave_mode_count;
    reward_notification = "Weave Mode: " + weave_mode_names[weave_mode];
    reward_notification_timer = 90;
    weave_mode_cooldown = 20; // Prevent rapid cycling
    
    // Debug message to confirm it's working
    show_debug_message("Weave mode changed to: " + string(weave_mode) + " - " + weave_mode_names[weave_mode]);
}

// Make sure this cooldown decrease is also outside the W key block
if (weave_mode_cooldown > 0) weave_mode_cooldown--;

// Speed sampling for wave animation
speed_sample_timer++;
if (speed_sample_timer >= speed_sample_interval) {
    ds_list_add(movement_speed_history, current_speed);
    
    while (ds_list_size(movement_speed_history) > 10) {
        ds_list_delete(movement_speed_history, 0);
    }
    
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

// Shape detection check
<!-- last_shape_check++; -->
<!-- if (last_shape_check >= shape_check_interval) { -->
    <!-- last_shape_check = 0; -->
    
    <!-- var detected_shape_size = scr_detect_shapes(); -->
    <!-- if (detected_shape_size > 0) { -->
        <!-- ink_xp += 50; -->
        <!-- gems += 1; -->
        
        <!-- reward_notification = "SHAPE COMPLETED! +50 XP, +1 Gem"; -->
        <!-- reward_notification_timer = 180; -->
        
        <!-- if (player_level < 10 && ink_xp >= xp_needed[player_level]) { -->
            <!-- player_level++; -->
            <!-- just_leveled_up = true; -->
            <!-- level_up_timer = 120; -->
        <!-- } -->
    <!-- } -->
<!-- } -->

// N KEY: Neon trail toggle
if (keyboard_check_pressed(ord("N")) && neon_trail_unlocked) {
    neon_trail_active = !neon_trail_active;
    if (neon_trail_active) {
        reward_notification = "Neon Trail ON";
    } else {
        reward_notification = "Neon Trail OFF";
    }
    reward_notification_timer = 60;
}

// P KEY: Sparkle pulse mode toggle
if (keyboard_check_pressed(ord("P")) && sparkle_pulse_unlocked && pulse_toggle_cooldown <= 0) {
    sparkle_pulse_active = !sparkle_pulse_active;
    if (sparkle_pulse_active) {
        reward_notification = "Sparkle Pulse MODE ON - Press Q to fire!";
    } else {
        ds_list_clear(sparkle_beams);
        ds_list_clear(explosion_effects);
        reward_notification = "Sparkle Pulse MODE OFF";
    }
    reward_notification_timer = 90;
    pulse_toggle_cooldown = 30;
}

if (pulse_toggle_cooldown > 0) pulse_toggle_cooldown--;
if (reward_notification_timer > 0) reward_notification_timer--;

// Send position over network
if (point_distance(x, y, last_sent_x, last_sent_y) > 16) {
    scr_networking();
    last_sent_x = x;
    last_sent_y = y;
}

// World boundaries
if (x < 50) {
    x = 50;
    velocity_x = 0;
}
if (x > room_width - 50) {
    x = room_width - 50;
    velocity_x = 0;
}
if (y < 50) {
    y = 50;
    velocity_y = 0;
}
if (y > room_height - 50) {
    y = room_height - 50;
    velocity_y = 0;
}

// DEBUG KEYS (Optional - remove for release)
if (keyboard_check_pressed(ord("T"))) {
    var debug_result = scr_detect_shapes();
    show_debug_message("Shape detection result: " + string(debug_result));
    show_debug_message("Player position: " + string(x) + ", " + string(y));
    show_debug_message("Total painted pixels: " + string(global.total_pixels_painted));
    show_debug_message("Player XP: " + string(ink_xp));
    show_debug_message("Player Level: " + string(player_level));
}

// ADD to obj_player Step Event (at the very end):

// K KEY: Force create a test shape at current position
if (keyboard_check_pressed(ord("K"))) {
    show_debug_message("=== FORCING TEST SHAPE ===");
    
    // Create a fake circular path
    ds_list_clear(shape_path_points);
    
    var radius = 50;
    var points = 20;
    
    for (var i = 0; i < points; i++) {
        var angle = (i / points) * 360;
        var px = x + lengthdir_x(radius, angle);
        var py = y + lengthdir_y(radius, angle);
        var point = [px, py, 0];
        ds_list_add(shape_path_points, point);
    }
    
    // Force detection
    var result = scr_detect_closed_shape();
    show_debug_message("Force test result: " + string(result));
    
    if (result > 0) {
        // Also force the rewards
        ink_xp += 50;
        gems += 1;
        reward_notification = "TEST SHAPE! +50 XP, +1 Gem";
        reward_notification_timer = 180;
    }
}