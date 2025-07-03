// REPLACE ENTIRE obj_player Draw_0.gml with this simplified version

// Draw player sprite
draw_self();

// REPLACE the Living Wave Animation section in Draw_0.gml with this:

// PERMANENT LIVING WAVE ANIMATIONS
// These waves dance forever at the speed they were created
if (living_weave_unlocked && ds_list_size(global.permanent_wave_segments) > 0) {
    // Only draw waves in view for performance
    var cam_x = camera_get_view_x(view_camera[0]);
    var cam_y = camera_get_view_y(view_camera[0]);
    var cam_w = camera_get_view_width(view_camera[0]);
    var cam_h = camera_get_view_height(view_camera[0]);
    
    for (var i = 0; i < ds_list_size(global.permanent_wave_segments); i++) {
        var wave_data = ds_list_find_value(global.permanent_wave_segments, i);
        
        var start_x = wave_data[0];
        var start_y = wave_data[1];
        var end_x = wave_data[2];
        var end_y = wave_data[3];
        
        // Skip if segment is off-screen
        if (max(start_x, end_x) < cam_x - 100 || min(start_x, end_x) > cam_x + cam_w + 100 ||
            max(start_y, end_y) < cam_y - 100 || min(start_y, end_y) > cam_y + cam_h + 100) {
            continue;
        }
        
        var creation_time = wave_data[4];
        var locked_frequency = wave_data[5];
        var locked_amplitude = wave_data[6];
        var segment_color = wave_data[7];
        var brush_size = wave_data[8];
        var creation_speed = wave_data[9];
        var segment_weave_mode = (array_length(wave_data) > 10) ? wave_data[10] : 0; // Default to wave if old data
        
        // Calculate animation based on LOCKED creation speed
        var time_elapsed = (current_time - creation_time) * 0.001;
        var animation_speed = 0.5 + (creation_speed * 0.3);
        var animated_time = time_elapsed * animation_speed;
        
        // Line properties
        var line_length = point_distance(start_x, start_y, end_x, end_y);
        var line_dir = point_direction(start_x, start_y, end_x, end_y);
        var perp_dir = line_dir + 90;
        
        draw_set_alpha(0.8);
        draw_set_color(segment_color);
        
        switch (segment_weave_mode) {
            case 0: // WAVE FLOW
                var wave_segments = max(3, line_length / 6);
                
                for (var seg = 0; seg < wave_segments - 1; seg++) {
                    var t1 = seg / (wave_segments - 1);
                    var t2 = (seg + 1) / (wave_segments - 1);
                    
                    var x1 = lerp(start_x, end_x, t1);
                    var y1 = lerp(start_y, end_y, t1);
                    var x2 = lerp(start_x, end_x, t2);
                    var y2 = lerp(start_y, end_y, t2);
                    
                    var wave_phase1 = (t1 * line_length * locked_frequency) + animated_time;
                    var wave_phase2 = (t2 * line_length * locked_frequency) + animated_time;
                    
                    var wave1 = sin(wave_phase1) * locked_amplitude;
                    var wave2 = sin(wave_phase2) * locked_amplitude;
                    
                    var wave_x1 = x1 + lengthdir_x(wave1, perp_dir);
                    var wave_y1 = y1 + lengthdir_y(wave1, perp_dir);
                    var wave_x2 = x2 + lengthdir_x(wave2, perp_dir);
                    var wave_y2 = y2 + lengthdir_y(wave2, perp_dir);
                    
                    draw_line_width(wave_x1, wave_y1, wave_x2, wave_y2, brush_size);
                }
                break;
                
            case 1: // LIGHTNING STRIKE
                var zig_segments = max(4, line_length / 20);
                var zig_amplitude = locked_amplitude * 1.5;
                
                // Animated electricity effect
                var spark_intensity = 0.5 + 0.5 * sin(animated_time * 10);
                draw_set_alpha(0.6 * spark_intensity);
                
                for (var seg = 0; seg < zig_segments - 1; seg++) {
                    var t1 = seg / (zig_segments - 1);
                    var t2 = (seg + 1) / (zig_segments - 1);
                    
                    var x1 = lerp(start_x, end_x, t1);
                    var y1 = lerp(start_y, end_y, t1);
                    var x2 = lerp(start_x, end_x, t2);
                    var y2 = lerp(start_y, end_y, t2);
                    
                    // Animated zigzag with occasional "jumps"
                    var zig_offset1 = (seg % 2 == 0 ? 1 : -1) * zig_amplitude;
                    var zig_offset2 = ((seg + 1) % 2 == 0 ? 1 : -1) * zig_amplitude;
                    
                    // Add random sparks
                    if (sin(animated_time * 20 + seg) > 0.8) {
                        zig_offset1 *= 1.5;
                        zig_offset2 *= 1.5;
                    }
                    
                    var zig_x1 = x1 + lengthdir_x(zig_offset1, perp_dir);
                    var zig_y1 = y1 + lengthdir_y(zig_offset1, perp_dir);
                    var zig_x2 = x2 + lengthdir_x(zig_offset2, perp_dir);
                    var zig_y2 = y2 + lengthdir_y(zig_offset2, perp_dir);
                    
                    draw_line_width(zig_x1, zig_y1, zig_x2, zig_y2, brush_size * spark_intensity);
                }
                break;
                
            case 2: // CANDY SWIRL
                var spiral_segments = max(6, line_length / 5);
                var spiral_radius = locked_amplitude;
                
                // Draw two rotating spirals
                for (var spiral = 0; spiral < 2; spiral++) {
                    var spiral_color = (spiral == 0) ? segment_color : merge_color(segment_color, c_white, 0.7);
                    draw_set_color(spiral_color);
                    draw_set_alpha(0.7);
                    
                    for (var seg = 0; seg < spiral_segments - 1; seg++) {
                        var t1 = seg / (spiral_segments - 1);
                        var t2 = (seg + 1) / (spiral_segments - 1);
                        
                        var x1 = lerp(start_x, end_x, t1);
                        var y1 = lerp(start_y, end_y, t1);
                        var x2 = lerp(start_x, end_x, t2);
                        var y2 = lerp(start_y, end_y, t2);
                        
                        // Animated spiral rotation
                        var spiral_angle1 = (t1 * 720) + (spiral * 180) + (animated_time * 50);
                        var spiral_angle2 = (t2 * 720) + (spiral * 180) + (animated_time * 50);
                        
                        var spiral_x1 = x1 + lengthdir_x(spiral_radius, spiral_angle1);
                        var spiral_y1 = y1 + lengthdir_y(spiral_radius, spiral_angle1);
                        var spiral_x2 = x2 + lengthdir_x(spiral_radius, spiral_angle2);
                        var spiral_y2 = y2 + lengthdir_y(spiral_radius, spiral_angle2);
                        
                        draw_line_width(spiral_x1, spiral_y1, spiral_x2, spiral_y2, brush_size * 0.8);
                    }
                }
                break;
                
            case 3: // HEARTBEAT PULSE
                var pulse_segments = max(4, line_length / 15);
                var pulse_base_amp = locked_amplitude * 0.75;
                
                // Animated heartbeat
                var heartbeat_rate = 1.2; // beats per second
                var beat_phase = animated_time * heartbeat_rate * 2 * pi;
                var beat_intensity = abs(sin(beat_phase));
                
                draw_set_alpha(0.6 + 0.2 * beat_intensity);
                
                for (var seg = 0; seg < pulse_segments - 1; seg++) {
                    var t1 = seg / (pulse_segments - 1);
                    var t2 = (seg + 1) / (pulse_segments - 1);
                    
                    var x1 = lerp(start_x, end_x, t1);
                    var y1 = lerp(start_y, end_y, t1);
                    var x2 = lerp(start_x, end_x, t2);
                    var y2 = lerp(start_y, end_y, t2);
                    
                    // Heartbeat pattern with animation
                    var beat_shape1 = t1 * 4 * pi;
                    var beat_shape2 = t2 * 4 * pi;
                    var beat1 = sin(beat_shape1) * exp(-t1 * 2) * pulse_base_amp * (1 + beat_intensity);
                    var beat2 = sin(beat_shape2) * exp(-t2 * 2) * pulse_base_amp * (1 + beat_intensity);
                    
                    var beat_x1 = x1 + lengthdir_x(beat1, perp_dir);
                    var beat_y1 = y1 + lengthdir_y(beat1, perp_dir);
                    var beat_x2 = x2 + lengthdir_x(beat2, perp_dir);
                    var beat_y2 = y2 + lengthdir_y(beat2, perp_dir);
                    
                    draw_line_width(beat_x1, beat_y1, beat_x2, beat_y2, brush_size * (0.8 + 0.2 * beat_intensity));
                }
                break;
        }
    }
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// ANIMATED SPARKLE BEAM RENDERING (this stays as-is since it's a projectile effect)
if (sparkle_pulse_active && sparkle_pulse_unlocked) {
    // Draw active beams
    for (var i = 0; i < ds_list_size(sparkle_beams); i++) {
        var beam = ds_list_find_value(sparkle_beams, i);
        
        if (!beam[10]) { // If not exploded yet
            var beam_alpha = 0.8;
            var sparkle_intensity = 1 + 0.5 * sin(current_time / 50);
            
            // Beam core
            draw_set_color(c_yellow);
            draw_set_alpha(beam_alpha);
            draw_circle(beam[2], beam[3], 3 * sparkle_intensity, false);
            
            // Beam glow
            draw_set_alpha(beam_alpha * 0.4);
            draw_circle(beam[2], beam[3], 6 * sparkle_intensity, false);
            
            // Sparkling trail
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
        var explosion_size = explosion_progress * 25;
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
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}