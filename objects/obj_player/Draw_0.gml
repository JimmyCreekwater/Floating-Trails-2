// Draw player (default)
draw_self();
// WORKING NEON TRAIL EFFECT
// LAYERED ART EFFECTS: Both Neon and Living Weave together
// LAYER 1: NEON TRAIL FOUNDATION (scaling with brush size)
if (neon_trail_active && neon_trail_unlocked) {
    for (var i = 0; i < ds_list_size(neon_segments); i++) {
        var segment = ds_list_find_value(neon_segments, i);
        var alpha_ratio = segment[4] / neon_fade_time;
        
        if (alpha_ratio > 0.1) { // Only draw if visible
            var brush_size = (array_length(segment) > 6) ? segment[6] : 2; // Get stored brush size or default
            
            // Scale neon effect with brush size
            var neon_width_base = brush_size * 6; // Base glow width
            var neon_width_core = brush_size * 3; // Core width
            
            // Two-layer neon effect with scaling
            draw_set_alpha(0.6 * alpha_ratio);
            draw_set_color(c_white); // White for better visibility (as you preferred)
            draw_line_width(segment[0], segment[1], segment[2], segment[3], neon_width_base);
            
            draw_set_alpha(0.9 * alpha_ratio);
            draw_set_color(segment[5] != undefined ? segment[5] : c_white);
            draw_line_width(segment[0], segment[1], segment[2], segment[3], neon_width_core);
        }
    }
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// LIVING WEAVE: TRUE PLAYER-DRIVEN KINETIC ART
if (living_weave_active && living_weave_unlocked) {
    for (var i = 0; i < ds_list_size(global.painted_trail_segments); i++) {
        var segment = ds_list_find_value(global.painted_trail_segments, i);
        var start_x = segment[0];
        var start_y = segment[1];
        var end_x = segment[2];
        var end_y = segment[3];
        var creation_time = segment[4];
        var segment_color = segment[5];
        var brush_size = segment[6];
        var creation_speed = segment[7];
        var movement_direction = segment[8];
        var speed_intensity = segment[9];
        var direction_change = segment[10];
        var personal_offset = segment[11];
        var was_sprinting = segment[12];
        var was_crouching = segment[13];
        
        // Calculate line properties
        var line_length = point_distance(start_x, start_y, end_x, end_y);
        var line_dir = point_direction(start_x, start_y, end_x, end_y);
        var perp_dir = line_dir + 90;
        
        // PLAYER-DRIVEN ANIMATION PARAMETERS
        if (player_connected) {
            // RESPONSIVE TO CURRENT PLAYER ACTION
            var wave_frequency = 0.2 + (creation_speed * 0.3);  // Directly based on movement speed when created
            var wave_amplitude = brush_size * (1 + speed_intensity * 2); // Brush size + speed intensity
            var animation_speed = 0.01 + (current_speed * 0.02); // Current movement affects animation speed
            var directional_influence = cos(degtorad(movement_direction)) * 0.5; // Direction affects wave pattern
            
            // Sprint/crouch effects
            if (was_sprinting) {
                wave_frequency *= 1.5;
                animation_speed *= 1.3;
            }
            if (was_crouching) {
                wave_amplitude *= 0.7;
                animation_speed *= 0.6;
            }
            
            // Direction change creates turbulence
            var turbulence = direction_change * 0.1;
            wave_amplitude += turbulence * brush_size;
            
        } else {
            // DISCONNECTED: Random autonomous animation
            var time_since_disconnect = (current_time - disconnection_time) * 0.001;
            var random_factor = sin(random_animation_seed + i * 0.1 + time_since_disconnect) * 0.5;
            
            var wave_frequency = 0.3 + random_factor * 0.2;
            var wave_amplitude = brush_size * (1 + abs(random_factor));
            var animation_speed = 0.015 + random_factor * 0.01;
            var directional_influence = random_factor * 0.3;
        }
        
        // Time-based animation with player influence
        var time_offset = (current_time - creation_time) * animation_speed + personal_offset;
        var pulse_intensity = 1 + 0.3 * sin(time_offset * 2) + directional_influence;
        
        // Apply final wave amplitude
        var final_wave_amplitude = wave_amplitude * pulse_intensity;
        
        // Draw animated wave segments
        var wave_segments = max(3, line_length / 6);
        
        draw_set_alpha(0.8);
        draw_set_color(segment_color);
        
        for (var seg = 0; seg < wave_segments - 1; seg++) {
            var t1 = seg / (wave_segments - 1);
            var t2 = (seg + 1) / (wave_segments - 1);
            
            // Base positions along line
            var x1 = lerp(start_x, end_x, t1);
            var y1 = lerp(start_y, end_y, t1);
            var x2 = lerp(start_x, end_x, t2);
            var y2 = lerp(start_y, end_y, t2);
            
            // Player-driven wave calculation
            var wave_phase1 = (t1 * line_length * wave_frequency) + time_offset;
            var wave_phase2 = (t2 * line_length * wave_frequency) + time_offset;
            
            // Add movement direction influence to wave pattern
            var directional_phase_shift = sin(degtorad(movement_direction + t1 * 180)) * 0.3;
            
            var wave1 = sin(wave_phase1 + directional_phase_shift) * final_wave_amplitude;
            var wave2 = sin(wave_phase2 + directional_phase_shift) * final_wave_amplitude;
            
            // Apply wave perpendicular to line
            var wave_x1 = x1 + lengthdir_x(wave1, perp_dir);
            var wave_y1 = y1 + lengthdir_y(wave1, perp_dir);
            var wave_x2 = x2 + lengthdir_x(wave2, perp_dir);
            var wave_y2 = y2 + lengthdir_y(wave2, perp_dir);
            
            // Draw flowing ribbon segment
            draw_line_width(wave_x1, wave_y1, wave_x2, wave_y2, brush_size);
        }
        
        // Update personal time offset for variety
        segment[11] += 0.001; // Slight individual variation
    }
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}



// LAYER 2: LIVING WEAVE OVERLAY (flowing waves on top)
// LIVING WEAVE NOTE: The weave effect is now applied during painting,
// not as a separate overlay. This creates true kinetic art transformation.

// LAYER 3: SPARKLE ENHANCEMENT (if both effects active)
if (living_weave_active && neon_trail_active) {
    draw_set_alpha(0.4);
    draw_set_color(c_yellow);
    for (var i = 0; i < ds_list_size(weave_segments); i += 3) {
        var segment = ds_list_find_value(weave_segments, i);
        var sparkle_x = segment[0] + random_range(-5, 5);
        var sparkle_y = segment[1] + random_range(-5, 5);
        draw_circle(sparkle_x, sparkle_y, 1, false);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// ANIMATED SPARKLE BEAM RENDERING
if (sparkle_pulse_active && sparkle_pulse_unlocked) {
    
    // Draw active beams
    for (var i = 0; i < ds_list_size(sparkle_beams); i++) {
        var beam = ds_list_find_value(sparkle_beams, i);
        
        if (!beam[10]) { // If not exploded yet
            // Draw sparkling beam projectile
            var beam_alpha = 0.8;
            var sparkle_intensity = 1 + 0.5 * sin(current_time / 50);
            
            // Beam core
            draw_set_color(c_yellow);
            draw_set_alpha(beam_alpha);
            draw_circle(beam[2], beam[3], 3 * sparkle_intensity, false);
            
            // Beam glow
            draw_set_alpha(beam_alpha * 0.4);
            draw_circle(beam[2], beam[3], 6 * sparkle_intensity, false);
            
            // Sparkling trail behind beam
            for (var trail_step = 1; trail_step <= 5; trail_step++) {
                var trail_ratio = trail_step / 5;
                var trail_x = lerp(beam[2], beam[0], trail_ratio * 0.3);
                var trail_y = lerp(beam[3], beam[1], trail_ratio * 0.3);
                
                draw_set_alpha(beam_alpha * (1 - trail_ratio) * 0.6);
                draw_set_color(merge_color(c_yellow, c_white, trail_ratio));
                draw_circle(trail_x, trail_y, (3 - trail_step * 0.5) * sparkle_intensity, false);
            }
            
            // Directional sparkles
            for (var spark = 0; spark < 3; spark++) {
                var spark_angle = point_direction(beam[0], beam[1], beam[2], beam[3]) + random_range(-30, 30);
                var spark_dist = random_range(8, 15);
                var spark_x = beam[2] + lengthdir_x(spark_dist, spark_angle);
                var spark_y = beam[3] + lengthdir_y(spark_dist, spark_angle);
                
                draw_set_alpha(beam_alpha * 0.3);
                draw_set_color(c_white);
                draw_circle(spark_x, spark_y, 1, false);
            }
        }
    }
    
    // Draw explosion effects
    for (var i = 0; i < ds_list_size(explosion_effects); i++) {
        var explosion = ds_list_find_value(explosion_effects, i);
        var explosion_progress = 1 - (explosion[2] / explosion[3]);
        var explosion_size = explosion_progress * 25; // Grows to 25 pixels
        var explosion_alpha = 1 - explosion_progress;
        
        // Explosion rings
        for (var ring = 0; ring < 3; ring++) {
            var ring_delay = ring * 0.2;
            var ring_progress = max(0, explosion_progress - ring_delay);
            var ring_size = ring_progress * (explosion_size + ring * 5);
            var ring_alpha = explosion_alpha * (1 - ring * 0.3);
            
            draw_set_alpha(ring_alpha * 0.6);
            draw_set_color(merge_color(c_yellow, c_orange, ring * 0.3));
            draw_circle(explosion[0], explosion[1], ring_size, true);
        }
        
        // Explosion sparkles
        for (var spark = 0; spark < 8; spark++) {
            var spark_angle = (spark / 8) * 360 + (explosion_progress * 180);
            var spark_dist = explosion_progress * 20;
            var spark_x = explosion[0] + lengthdir_x(spark_dist, spark_angle);
            var spark_y = explosion[1] + lengthdir_y(spark_dist, spark_angle);
            
            draw_set_alpha(explosion_alpha);
            draw_set_color(c_white);
            draw_circle(spark_x, spark_y, 2, false);
        }
    }
    
    // Reset drawing settings
    draw_set_alpha(1);
    draw_set_color(c_white);
}


