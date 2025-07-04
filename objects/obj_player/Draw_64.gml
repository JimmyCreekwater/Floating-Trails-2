// REPLACE ENTIRE obj_player Draw_64.gml with this icon-based UI design

// Get GUI dimensions
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Set default drawing settings
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ========== BOTTOM DOCK UI ==========
var dock_height = 160;
var dock_y = gui_height - dock_height;

// Draw dock background
draw_set_color(c_black);
draw_set_alpha(0.9);
draw_roundrect(0, dock_y - 10, gui_width, gui_height, false);

// Dock top border
draw_set_color(c_white);
draw_set_alpha(0.3);
draw_line_width(0, dock_y - 10, gui_width, dock_y - 10, 2);

// ===== ABILITY ICONS =====
var icon_size = 80;
var icon_padding = 20;
var icon_y = dock_y + 20;
var total_abilities = 5; // Color, Neon, Weave, Sparkle

// Calculate starting X to center all icons
var total_width = (icon_size * total_abilities) + (icon_padding * (total_abilities - 1));
var start_x = (gui_width - total_width) / 2;

// 0. DRAWING STATUS ICON (new first icon)
var drawing_x = start_x - (icon_size + icon_padding); // Shift everything right
var center_x = drawing_x + icon_size/2;
var center_y = icon_y + icon_size/2;

// Adjust start_x to accommodate new icon
start_x = drawing_x;

// Icon background
draw_set_color(drawing_enabled ? c_lime : c_dkgray);
draw_set_alpha(0.8);
draw_roundrect(drawing_x, icon_y, drawing_x + icon_size, icon_y + icon_size, false);

// Pencil/brush icon
draw_set_color(c_white);
draw_set_alpha(drawing_enabled ? 1 : 0.3);

// Simple pencil shape
draw_line_width(center_x - 15, center_y + 15, center_x + 10, center_y - 10, 4);
draw_triangle(center_x + 10, center_y - 10, center_x + 15, center_y - 15, center_x + 20, center_y - 5, false);

// Pencil tip
draw_set_color(drawing_enabled ? my_trail_color : c_gray);
draw_circle(center_x - 15, center_y + 15, 3, false);

// Text below icon
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(center_x, icon_y + icon_size + 5, "DRAW [SPACE]");
draw_set_color(drawing_enabled ? c_lime : c_gray);
draw_text(center_x, icon_y + icon_size + 20, drawing_enabled ? "PAINTING" : "MOVE ONLY");


// 1. COLOR PICKER ICON
var color_x = start_x;
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// Icon background
draw_set_color(c_dkgray);
draw_set_alpha(0.8);
draw_roundrect(color_x, icon_y, color_x + icon_size, icon_y + icon_size, false);

// Color wheel representation
var center_x = color_x + icon_size/2;
var center_y = icon_y + icon_size/2;
for (var i = 0; i < 8; i++) {
    var angle = i * 45;
    var px = center_x + lengthdir_x(20, angle);
    var py = center_y + lengthdir_y(20, angle);
    draw_set_color(color_palette[i]);
    draw_set_alpha(1);
    draw_circle(px, py, 6, false);
}

// Current color in center
draw_set_color(my_trail_color);
draw_circle(center_x, center_y, 12, false);
draw_set_color(c_white);
draw_circle(center_x, center_y, 12, true);

// Text below icon
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(center_x, icon_y + icon_size + 5, "COLOR [C]");
draw_set_color(my_trail_color);
var color_names = ["Red", "Green", "Blue", "Yellow", "Pink", "Cyan", "Orange", "White", "Purple", "Aqua"];
draw_text(center_x, icon_y + icon_size + 20, color_names[current_color_index]);

// 2. NEON TRAIL ICON
var neon_x = color_x + icon_size + icon_padding;
center_x = neon_x + icon_size/2;
center_y = icon_y + icon_size/2;

// Icon background
if (neon_trail_unlocked) {
    draw_set_color(neon_trail_active ? c_lime : c_dkgray);
} else {
    draw_set_color(c_black);
}
draw_set_alpha(0.8);
draw_roundrect(neon_x, icon_y, neon_x + icon_size, icon_y + icon_size, false);

// Neon glow effect icon
if (neon_trail_unlocked) {
    draw_set_alpha(neon_trail_active ? 1 : 0.3);
    // Outer glow
    draw_set_color(c_white);
    draw_set_alpha(0.2);
    draw_circle(center_x, center_y, 25, false);
    // Mid glow
    draw_set_color(c_aqua);
    draw_set_alpha(0.4);
    draw_circle(center_x, center_y, 18, false);
    // Core
    draw_set_color(c_white);
    draw_set_alpha(neon_trail_active ? 1 : 0.5);
    draw_circle(center_x, center_y, 10, false);
} else {
    // Lock symbol
    draw_set_color(c_gray);
    draw_set_alpha(0.5);
    draw_text(center_x, center_y, "🔒");
}

// Text below icon
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(center_x, icon_y + icon_size + 5, "NEON [N]");
if (neon_trail_unlocked) {
    draw_set_color(neon_trail_active ? c_lime : c_gray);
    draw_text(center_x, icon_y + icon_size + 20, neon_trail_active ? "ACTIVE" : "OFF");
} else {
    draw_set_color(c_gray);
    draw_text(center_x, icon_y + icon_size + 20, "Level 5");
}

// 3. LIVING WEAVE ICON
var weave_x = neon_x + icon_size + icon_padding;
center_x = weave_x + icon_size/2;
center_y = icon_y + icon_size/2;

// Icon background
if (living_weave_unlocked) {
    draw_set_color(living_weave_active ? c_lime : c_dkgray);
} else {
    draw_set_color(c_black);
}
draw_set_alpha(0.8);
draw_roundrect(weave_x, icon_y, weave_x + icon_size, icon_y + icon_size, false);

// Wave pattern icon
if (living_weave_unlocked) {
    draw_set_alpha(living_weave_active ? 1 : 0.3);
    draw_set_color(c_aqua);
    
    // Draw mini wave pattern
    for (var wx = -25; wx < 25; wx += 2) {
        var wy = sin(wx * 0.3 + current_time * 0.01) * 10;
        draw_circle(center_x + wx, center_y + wy, 2, false);
    }
} else {
    // Lock symbol
    draw_set_color(c_gray);
    draw_set_alpha(0.5);
    draw_text(center_x, center_y, "🔒");
}

// Text below icon
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(center_x, icon_y + icon_size + 5, "WEAVE [W]");
if (living_weave_unlocked) {
    draw_set_color(living_weave_active ? c_lime : c_gray);
    draw_text(center_x, icon_y + icon_size + 20, living_weave_active ? weave_mode_names[weave_mode] : "OFF");
    if (living_weave_active) {
        draw_set_color(c_yellow);
        draw_text(center_x, icon_y + icon_size + 35, "[R] to change");
    }
} else {
    draw_set_color(c_gray);
    draw_text(center_x, icon_y + icon_size + 20, "Level 8");
}

// 4. SPARKLE PULSE ICON
var sparkle_x = weave_x + icon_size + icon_padding;
center_x = sparkle_x + icon_size/2;
center_y = icon_y + icon_size/2;

// Icon background
if (sparkle_pulse_unlocked) {
    draw_set_color(sparkle_pulse_active ? c_lime : c_dkgray);
} else {
    draw_set_color(c_black);
}
draw_set_alpha(0.8);
draw_roundrect(sparkle_x, icon_y, sparkle_x + icon_size, icon_y + icon_size, false);

// Sparkle burst icon
if (sparkle_pulse_unlocked) {
    draw_set_alpha(sparkle_pulse_active ? 1 : 0.3);
    
    // Draw sparkle burst
    for (var i = 0; i < 8; i++) {
        var angle = i * 45 + sin(current_time * 0.01) * 10;
        var dist = 15 + sin(current_time * 0.02 + i) * 5;
        var sx = center_x + lengthdir_x(dist, angle);
        var sy = center_y + lengthdir_y(dist, angle);
        
        draw_set_color(c_yellow);
        draw_circle(sx, sy, 3, false);
        draw_set_color(c_white);
        draw_circle(sx, sy, 1, false);
    }
    
    // Center burst
    draw_set_color(c_yellow);
    draw_circle(center_x, center_y, 8, false);
} else {
    // Lock symbol
    draw_set_color(c_gray);
    draw_set_alpha(0.5);
    draw_text(center_x, center_y, "🔒");
}

// Text below icon
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(center_x, icon_y + icon_size + 5, "SPARKLE [P]");
if (sparkle_pulse_unlocked) {
    if (sparkle_pulse_active) {
        if (pulse_generation_cooldown > 0) {
            draw_set_color(c_orange);
            var cooldown_seconds = ceil(pulse_generation_cooldown / 60);
            draw_text(center_x, icon_y + icon_size + 20, "RELOAD: " + string(cooldown_seconds) + "s");
        } else {
            draw_set_color(c_yellow);
            draw_text(center_x, icon_y + icon_size + 20, "READY!");
            draw_text(center_x, icon_y + icon_size + 35, "[Q] to fire");
        }
    } else {
        draw_set_color(c_gray);
        draw_text(center_x, icon_y + icon_size + 20, "OFF");
    }
} else {
    draw_set_color(c_gray);
    draw_text(center_x, icon_y + icon_size + 20, "15 Gems");
    draw_text(center_x, icon_y + icon_size + 35, "3 Events");
}

// ===== LEFT SIDE: PLAYER STATS =====
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var stats_x = 20;
var stats_y = dock_y + 10;

// Level
draw_set_color(c_lime);
draw_text_transformed(stats_x, stats_y, "LV " + string(player_level), 2.5, 2.5, 0);

// XP Bar
if (player_level < 10) {
    var xp_y = stats_y + 45;
    var current_xp = ink_xp;
    var needed_xp = xp_needed[player_level];
    var prev_xp = (player_level > 1) ? xp_needed[player_level - 1] : 0;
    var level_progress = (current_xp - prev_xp) / (needed_xp - prev_xp);
    
    draw_set_color(c_white);
    draw_text(stats_x, xp_y, string(current_xp) + "/" + string(needed_xp) + " XP");
    
    // Progress bar
    var bar_width = 150;
    var bar_height = 8;
    var bar_y = xp_y + 20;
    
    draw_set_color(c_dkgray);
    draw_rectangle(stats_x, bar_y, stats_x + bar_width, bar_y + bar_height, false);
    draw_set_color(c_lime);
    draw_rectangle(stats_x, bar_y, stats_x + (bar_width * level_progress), bar_y + bar_height, false);
}

// Currencies
var currency_y = stats_y + 90;
draw_set_color(c_aqua);
draw_text_transformed(stats_x, currency_y, "◆ " + string(shards), 1.5, 1.5, 0);
draw_set_color(c_fuchsia);
draw_text_transformed(stats_x, currency_y + 25, "★ " + string(gems), 1.5, 1.5, 0);

// ===== RIGHT SIDE: CONTROLS =====
draw_set_halign(fa_right);
var controls_x = gui_width - 20;
var controls_y = dock_y + 20;

draw_set_color(c_white);
draw_set_alpha(0.7);
draw_text(controls_x, controls_y, "WASD: Move");
draw_text(controls_x, controls_y + 20, "SHIFT: Sprint");
draw_text(controls_x, controls_y + 40, "CTRL: Crouch");
draw_text(controls_x, controls_y + 60, "TAB: Debug");
draw_text(controls_x, controls_y + 80, "F11: Fullscreen");
draw_text(controls_x, controls_y + 100, "SPACE: Toggle Draw");

// ========== NOTIFICATIONS ==========
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Level up notification
if (level_up_timer > 0) {
    level_up_timer--;
    
    var notif_y = dock_y - 150;
    var pulse = 1 + sin(level_up_timer * 0.3) * 0.1;
    
    draw_set_color(c_yellow);
    draw_set_alpha(0.95);
    draw_roundrect_ext(gui_width/2 - 200, notif_y - 60, gui_width/2 + 200, notif_y + 60, 20, 20, false);
    
    draw_set_color(c_black);
    draw_set_alpha(1);
    draw_text_transformed(gui_width/2, notif_y - 20, "LEVEL UP!", 3 * pulse, 3 * pulse, 0);
    draw_text_transformed(gui_width/2, notif_y + 20, "Level " + string(player_level), 2, 2, 0);
}

// Reward notifications
if (reward_notification_timer > 0) {
    reward_notification_timer--;
    
    var notif_y = dock_y - 60;
    
    draw_set_color(c_aqua);
    draw_set_alpha(0.9);
    draw_roundrect_ext(gui_width/2 - 250, notif_y - 25, gui_width/2 + 250, notif_y + 25, 15, 15, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text_transformed(gui_width/2, notif_y, reward_notification, 1.5, 1.5, 0);
}

// ========== DEBUG INFO ==========
if (keyboard_check(vk_tab)) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(0.8);
    
    var debug_x = gui_width - 20;
    var debug_y = 20;
    
    draw_text(debug_x, debug_y, "FPS: " + string(fps));
    draw_text(debug_x, debug_y + 20, "Speed: " + string_format(current_speed, 1, 2));
    draw_text(debug_x, debug_y + 40, "Segments: " + string(ds_list_size(global.permanent_wave_segments)));
    draw_text(debug_x, debug_y + 60, "Pixels: " + string(global.total_pixels_painted));
    draw_text(debug_x, debug_y + 80, "Weave Mode: " + string(weave_mode));
}

// Reset drawing settings
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Debug info for SHAPES CREATION
if (keyboard_check(ord("H"))) {
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_text(20, 200, "=== SHAPE DEBUG ===");
    draw_text(20, 220, "Drawing: " + (drawing_enabled ? "ON" : "OFF"));
    draw_text(20, 240, "Path Points: " + string(ds_list_size(shape_path_points)));
    draw_text(20, 260, "Speed: " + string_format(current_speed, 1, 2));
    draw_text(20, 280, "Active Shapes: " + string(ds_list_size(shape_flash_list)));
    draw_text(20, 300, "Min points needed: 20");
    draw_text(20, 320, "Close distance: < 20 pixels");
}