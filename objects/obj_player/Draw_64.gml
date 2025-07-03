// MASSIVE UI: GIANT text, HUGE layout, SUPER READABLE
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
// Set large, readable font
draw_set_font(-1); // Default font
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// UI positioning - MASSIVE panel
var panel_x = 30;
var panel_y = 30;
var panel_width = 700;  // Much wider
var panel_height = 400; // Much taller
var text_size = 50;     // HUGE text spacing (was 24, now 50)
// Background panel with border
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);
draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, true);
// Line counter for easy positioning
var line = 0;
// LEVEL (MASSIVE and prominent)
draw_set_color(c_lime);
draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "LEVEL: " + string(player_level), 3.0, 3.0, 0); // 3x scale!
line++;
// XP Progress
if (player_level < 6) {
    var current_xp = ink_xp;
    var needed_xp = xp_needed[player_level];
    var prev_xp = (player_level > 1) ? xp_needed[player_level - 1] : 0;
    var level_progress = (current_xp - prev_xp) / (needed_xp - prev_xp);
    
    draw_set_color(c_white);
    draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "XP: " + string(current_xp) + " / " + string(needed_xp), 2.5, 2.5, 0); // 2.5x scale!
    line++;
    
    // MASSIVE XP Progress bar
    var bar_x = panel_x + 25;
    var bar_y = panel_y + 25 + (line * text_size);
    var bar_width = 500; // Much wider
    var bar_height = 40; // Much taller
    
    draw_set_color(c_gray);
    draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
    draw_set_color(c_lime);
    draw_rectangle(bar_x, bar_y, bar_x + (bar_width * level_progress), bar_y + bar_height, false);
    draw_set_color(c_white);
    draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);
    line += 1.8; // Extra space after progress bar
} else {
    draw_set_color(c_yellow);
    draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "MAX LEVEL!", 2.8, 2.8, 0);
    line++;
}
// Currencies (HUGE and colorful)
draw_set_color(c_aqua);
draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "SHARDS: " + string(shards), 2.2, 2.2, 0);
line++;
draw_set_color(c_fuchsia);
draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "GEMS: " + string(gems), 2.2, 2.2, 0);
line++;
// Rewards section (if you've implemented Phase 4B)
if (variable_instance_exists(id, "neon_trail_unlocked")) {
    line += 0.5; // Gap
    draw_set_color(c_yellow);
    draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "NEON TRAIL:", 2.0, 2.0, 0);
    
    if (neon_trail_unlocked) {
        draw_set_color(neon_trail_active ? c_lime : c_white);
        draw_text_transformed(panel_x + 350, panel_y + 25 + (line * text_size), (neon_trail_active ? "ON (N)" : "OFF (N)"), 2.0, 2.0, 0);
    } else {
        draw_set_color(c_gray);
        var progress_text = "";
        if (player_level >= 5) {
            progress_text = "UNLOCKED!";
        } else if (shards >= 250) {
            progress_text = "UNLOCKED!";
        } else {
            var shards_needed = 250 - shards;
            progress_text = "Need Lv5 OR " + string(shards_needed) + " shards";
        }
        draw_text_transformed(panel_x + 350, panel_y + 25 + (line * text_size), progress_text, 1.8, 1.8, 0);
    }
}

// Sparkle Pulse section
if (variable_instance_exists(id, "sparkle_pulse_unlocked")) {
    line += 0.5; // Gap
    draw_set_color(c_orange);
    draw_text_transformed(panel_x + 25, panel_y + 25 + (line * text_size), "SPARKLE PULSE:", 2.0, 2.0, 0);
    
    if (sparkle_pulse_unlocked) {
        // Determine status and color
        var status_text = "";
        var status_color = c_white;
        
		if (sparkle_pulse_active) {
		    if (pulse_generation_cooldown > 0) {
		        var cooldown_seconds = ceil(pulse_generation_cooldown / 60);
		        status_text = "READY IN " + string(cooldown_seconds) + "s (Q)";
		        status_color = c_orange;
		    } else {
		        status_text = "PRESS Q TO FIRE!";
		        status_color = c_lime;
		    }
		} else {
		    status_text = "MODE OFF (P)";
		    status_color = c_white;
		}

        
        draw_set_color(status_color);
        draw_text_transformed(panel_x + 400, panel_y + 25 + (line * text_size), status_text, 2.0, 2.0, 0);
    } else {
        draw_set_color(c_gray);
        var progress_text = "Need " + string(max(0, 15 - gems)) + " gems + " + string(max(0, 3 - event_tickets)) + " events";
        draw_text_transformed(panel_x + 400, panel_y + 25 + (line * text_size), progress_text, 1.6, 1.6, 0);
    }
    line++; // Move to next line
} 

// Living Weave Pattern status
if (variable_instance_exists(id, "living_weave_unlocked")) {
    if (living_weave_unlocked) {
        draw_set_color(living_weave_active ? c_lime : c_white);
        var status_text = "Living Weave: " + (living_weave_active ? "ON (W)" : "OFF (W)");
        if (living_weave_active) {
            status_text += " | Speed: " + string_format(wave_speed_multiplier, 1, 1) + "x";
        }
        draw_text(ui_x, ui_y + (line * 20), status_text);
        line++;
        
        // Show wave animation info when active
        if (living_weave_active) {
            draw_set_color(c_aqua);
            draw_text(ui_x, ui_y + (line * 20), "  Segments: " + string(ds_list_size(weave_segments)));
            line++;
        }
    } else {
        draw_set_color(c_gray);
        draw_text(ui_x, ui_y + (line * 20), "Living Weave: LOCKED (Level 8)");
        line++;
    }
} else {
    // Fallback if variable doesn't exist yet
    draw_set_color(c_gray);
    draw_text(ui_x, ui_y + (line * 20), "Living Weave: LOCKED");
    line++;
}

// COLOR SELECTION DISPLAY
draw_set_color(c_white);
draw_text(ui_x, ui_y + (line * 20), "Current Color (C):");
line++;
// Show current color as a colored rectangle
draw_set_color(my_trail_color);
draw_rectangle(ui_x + 20, ui_y + (line * 20) - 3, ui_x + 60, ui_y + (line * 20) + 12, false);
draw_set_color(c_white);
draw_rectangle(ui_x + 20, ui_y + (line * 20) - 3, ui_x + 60, ui_y + (line * 20) + 12, true);
// Color name
var color_names = ["Red", "Green", "Blue", "Yellow", "Pink", "Cyan", "Orange", "White", "Purple", "Aqua"];
draw_text(ui_x + 70, ui_y + (line * 20), color_names[current_color_index]);
line++;



// Center screen notifications (ENORMOUS)
var center_x = gui_width / 2;
// Level up notification
if (variable_instance_exists(id, "level_up_timer") && level_up_timer > 0) {
    level_up_timer--;
    
    var notif_width = 600;  // Much wider
    var notif_height = 150; // Much taller
    var notif_x = center_x - notif_width / 2;
    var notif_y = 250;
    
    draw_set_color(c_yellow);
    draw_set_alpha(0.95);
    draw_rectangle(notif_x, notif_y, notif_x + notif_width, notif_y + notif_height, false);
    
    draw_set_color(c_black);
    draw_set_alpha(1);
    draw_rectangle(notif_x, notif_y, notif_x + notif_width, notif_y + notif_height, true);
    
    draw_set_halign(fa_center);
    draw_set_color(c_black);
    draw_text_transformed(center_x, notif_y + 30, "LEVEL UP!", 4.0, 4.0, 0);  // MASSIVE!
    draw_text_transformed(center_x, notif_y + 90, "Level " + string(player_level), 3.0, 3.0, 0); // HUGE!
    draw_set_halign(fa_left);
}
// Reward notifications (if Phase 4B implemented)
if (variable_instance_exists(id, "reward_notification_timer") && reward_notification_timer > 0) {
    var notif_width = 800;  // Much wider
    var notif_height = 120; // Much taller
    var notif_x = center_x - notif_width / 2;
    var notif_y = 450;
    
    draw_set_color(c_fuchsia);
    draw_set_alpha(0.95);
    draw_rectangle(notif_x, notif_y, notif_x + notif_width, notif_y + notif_height, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(notif_x, notif_y, notif_x + notif_width, notif_y + notif_height, true);
    
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text_transformed(center_x, notif_y + 35, reward_notification, 2.5, 2.5, 0); // GIANT!
    draw_set_halign(fa_left);
}
// Reset all drawing settings
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

