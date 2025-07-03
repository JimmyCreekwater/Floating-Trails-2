// SAFETY: Initialize missing variables for old shard instances
if (!variable_instance_exists(id, "flash_phase")) {
    // Old shard - initialize all missing variables
    max_lifespan = 720;
    current_lifespan = max_lifespan;
    flash_phase = 0;
    flash_timer = 0;
    warning_time = 180;
    urgent_time = 60;
}
// Calculate alpha and color based on lifespan and flash phase
var base_alpha = 0.5 + sin(sparkle_timer * 0.2) * 0.3;
var final_alpha = base_alpha;
var shard_color = c_aqua;
// LIFESPAN VISUAL EFFECTS
switch (flash_phase) {
    case 0: // Stable - normal appearance
        final_alpha = base_alpha;
        shard_color = c_aqua;
        break;
        
    case 1: // Slow warning flash
        final_alpha = base_alpha * (0.7 + 0.3 * sin(flash_timer * 0.3));
        shard_color = merge_color(c_aqua, c_yellow, 0.3); // Slight yellow tint
        break;
        
    case 2: // Fast warning flash
        final_alpha = base_alpha * (0.5 + 0.5 * sin(flash_timer * 0.6));
        shard_color = merge_color(c_aqua, c_orange, 0.5); // Orange tint
        break;
        
    case 3: // Urgent flash
        final_alpha = base_alpha * (0.3 + 0.7 * sin(flash_timer * 1.2));
        shard_color = merge_color(c_aqua, c_red, 0.7); // Red tint
        break;
}
// Size scaling for urgency
var size_multiplier = 1.0;
if (flash_phase >= 2) {
    size_multiplier = 1.0 + 0.2 * sin(flash_timer * 0.8); // Slight size pulsing
}
// Draw glow effect
draw_set_color(shard_color);
draw_set_alpha(final_alpha * 0.3);
draw_circle(x, y, 12 * size_multiplier, false);
// Draw core shard
draw_set_alpha(final_alpha);
draw_circle(x, y, 6 * size_multiplier, false);
// Draw outline
draw_set_color(c_white);
draw_set_alpha(final_alpha);
draw_circle(x, y, 6 * size_multiplier, true);
// Reset drawing settings
draw_set_alpha(1);
draw_set_color(c_white);
