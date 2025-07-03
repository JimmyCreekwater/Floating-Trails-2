// REPLACE ENTIRE obj_player Draw_64.gml with this modern UI design

// Get GUI dimensions
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Set default drawing settings
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ========== BOTTOM DOCK UI ==========
// Modern dock-style interface at bottom of screen

var dock_height = 180;
var dock_y = gui_height - dock_height;
var dock_padding = 30;
var section_spacing = 80;

// Draw dock background
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_roundrect(10, dock_y - 10, gui_width - 10, gui_height - 10, false);

// Dock border
draw_set_color(c_white);
draw_set_alpha(0.5);
draw_roundrect(10, dock_y - 10, gui_width - 10, gui_height - 10, true);

// ===== LEFT SECTION: Player Stats =====
var left_x = dock_padding;
var left_y = dock_y + 20;

// LEVEL - HUGE
draw_set_color(c_lime);
draw_set_alpha(1);
draw_text_transformed(left_x, left_y, "LEVEL " + string(player_level), 3, 3, 0);

// XP Bar
if (player_level < 10) {
    var xp_y = left_y + 50;
    var current_xp = ink_xp;
    var needed_xp = xp_needed[player_level];
    var prev_xp = (player_level > 1) ? xp_needed[player_level - 1] : 0;
    var level_progress = (current_xp - prev_xp) / (needed_xp - prev_xp);
    
    // XP Text
    draw_set_color(c_white);
    draw_text_transformed(left_x, xp_y, "XP: " + string(current_xp) + "/" + string(needed_xp), 1.5, 1.5, 0);
    
    // XP Bar
    var bar_y = xp_y + 25;
    var bar_width = 250;
    var bar_height = 20;
    
    draw_set_color(c_dkgray);
    draw_roundrect(left_x, bar_y, left_x + bar_width, bar_y + bar_height, false);
    
    draw_set_color(c_lime);
    draw_roundrect(left_x, bar_y, left_x + (bar_width * level_progress), bar_y + bar_height, false);
    
    draw_set_color(c_white);
    draw_set_alpha(0.7);
    draw_roundrect(left_x, bar_y, left_x + bar_width, bar_y + bar_height, true);
    draw_set_alpha(1);
} else {
    draw_set_color(c_yellow);
    draw_text_transformed(left_x, left_y + 50, "MAX LEVEL!", 2, 2, 0);
}

// Currencies
var currency_y = left_y + 100;
draw_set_color(c_aqua);
draw_text_transformed(left_x, currency_y, "SHARDS: " + string(shards), 1.8, 1.8, 0);

draw_set_color(c_fuchsia);
draw_text_transformed(left_x + 150, currency_y, "GEMS: " + string(gems), 1.8, 1.8, 0);

// ===== CENTER SECTION: Active Tools =====
var center_x = gui_width / 2 - 200;
var tools_y = dock_y + 20;

draw_set_color(c_white);
draw_text_transformed(center_x, tools_y, "ACTIVE TOOLS", 2, 2, 0);

var tool_y = tools_y + 35;
var tool_spacing = 30;

// Current Color
draw_set_color(c_white);
draw_text_transformed(center_x, tool_y, "COLOR:", 1.5, 1.5, 0);
draw_set_color(my_trail_color);
draw_roundrect(center_x + 80, tool_y, center_x + 120, tool_y + 20, false);
draw_set_color(c_white);
draw_text_transformed(center_x + 130, tool_y, "[C]", 1.2, 1.2, 0);
tool_y += tool_spacing;

// Neon Trail
if (neon_trail_unlocked) {
    draw_set_color(neon_trail_active ? c_lime : c_gray);
    draw_text_transformed(center_x, tool_y, "NEON: " + (neon_trail_active ? "ON" : "OFF") + " [N]", 1.5, 1.5, 0);
} else {
    draw_set_color(c_dkgray);
    draw_text_transformed(center_x, tool_y, "NEON: LOCKED (Lv5)", 1.3, 1.3, 0);
}
tool_y += tool_spacing;

// Living Weave
if (living_weave_unlocked) {
    draw_set_color(living_weave_active ? c_lime : c_gray);
    var weave_text = "WEAVE: " + (living_weave_active ? "ON" : "OFF") + " [W]";
    if (living_weave_active) {
        weave_text = "WEAVE: " + weave_mode_names[weave_mode] + " [W/R]";
    }
    draw_text_transformed(center_x, tool_y, weave_text, 1.5, 1.5, 0);
} else {
    draw_set_color(c_dkgray);
    draw_text_transformed(center_x, tool_y, "WEAVE: LOCKED (Lv8)", 1.3, 1.3, 0);
}
tool_y += tool_spacing;

// Sparkle Pulse
if (sparkle_pulse_unlocked) {
    var sparkle_color = sparkle_pulse_active ? c_lime : c_gray;
    var sparkle_text = "SPARKLE: ";
    
    if (sparkle_pulse_active) {
        if (pulse_generation_cooldown > 0) {
            sparkle_color = c_orange;
            var cooldown_seconds = ceil(pulse_generation_cooldown / 60);
            sparkle_text += "RELOADING (" + string(cooldown_seconds) + "s)";
        } else {
            sparkle_color = c_yellow;
            sparkle_text += "READY! [Q]";
        }
    } else {
        sparkle_text += "OFF [P]";
    }
    
    draw_set_color(sparkle_color);
    draw_text_transformed(center_x, tool_y, sparkle_text, 1.5, 1.5, 0);
} else {
    draw_set_color(c_dkgray);
    draw_text_transformed(center_x, tool_y, "SPARKLE: LOCKED", 1.3, 1.3, 0);
}

// ===== RIGHT SECTION: Controls Help =====
var right_x = gui_width - 400;
var controls_y = dock_y + 20;

draw_set_color(c_white);
draw_set_alpha(0.8);
draw_text_transformed(right_x, controls_y, "CONTROLS", 1.8, 1.8, 0);

var help_y = controls_y + 30;
draw_text_transformed(right_x, help_y, "Move: WASD", 1.3, 1.3, 0);
help_y += 22;
draw_text_transformed(right_x, help_y, "Sprint/Crouch: SHIFT/CTRL", 1.3, 1.3, 0);
help_y += 22;
draw_text_transformed(right_x, help_y, "Color: C | Neon: N", 1.3, 1.3, 0);
help_y += 22;

if (living_weave_unlocked) {
    draw_text_transformed(right_x, help_y, "Weave: W | Pattern: R", 1.3, 1.3, 0);
    help_y += 22;
}

if (sparkle_pulse_unlocked) {
    draw_text_transformed(right_x, help_y, "Sparkle: P | Fire: Q", 1.3, 1.3, 0);
}

// ========== NOTIFICATIONS ==========
// Level up notification
if (level_up_timer > 0) {
    level_up_timer--;
    
    var notif_y = dock_y - 200;
    var notif_width = 500;
    var notif_height = 120;
    var notif_x = (gui_width - notif_width) / 2;
    
    // Pulsing effect
    var pulse = 1 + sin(level_up_timer * 0.3) * 0.1;
    
    draw_set_color(c_yellow);
    draw_set_alpha(0.95);
    draw_roundrect_ext(notif_x, notif_y, notif_x + notif_width, notif_y + notif_height, 20, 20, false);
    
    draw_set_color(c_black);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_text_transformed(gui_width / 2, notif_y + 30, "LEVEL UP!", 3 * pulse, 3 * pulse, 0);
    draw_text_transformed(gui_width / 2, notif_y + 80, "Level " + string(player_level), 2, 2, 0);
    draw_set_halign(fa_left);
}

// Reward notifications
if (reward_notification_timer > 0) {
    var notif_y = dock_y - 80;
    var notif_width = string_width(reward_notification) * 2 + 80;
    var notif_height = 60;
    var notif_x = (gui_width - notif_width) / 2;
    
    draw_set_color(c_aqua);
    draw_set_alpha(0.9);
    draw_roundrect_ext(notif_x, notif_y, notif_x + notif_width, notif_y + notif_height, 15, 15, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_text_transformed(gui_width / 2, notif_y + 20, reward_notification, 1.8, 1.8, 0);
    draw_set_halign(fa_left);
}

// ========== DEBUG INFO (Top Right) ==========
if (keyboard_check(vk_tab)) {
    draw_set_color(c_white);
    draw_set_alpha(0.7);
    draw_set_halign(fa_right);
    var debug_x = gui_width - 20;
    var debug_y = 20;
    
    draw_text(debug_x, debug_y, "FPS: " + string(fps));
    draw_text(debug_x, debug_y + 20, "Speed: " + string_format(current_speed, 1, 2));
    draw_text(debug_x, debug_y + 40, "Segments: " + string(ds_list_size(global.permanent_wave_segments)));
    draw_text(debug_x, debug_y + 60, "Pixels: " + string(global.total_pixels_painted));
    
    draw_set_halign(fa_left);
}

// Reset drawing settings
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);