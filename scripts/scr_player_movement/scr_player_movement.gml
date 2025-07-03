function scr_player_movement() {
    var input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
    var input_y = keyboard_check(vk_down) - keyboard_check(vk_up);
    
    // NEW: Speed modifiers for artistic control
    if (keyboard_check(vk_shift)) {
        max_speed = sprint_speed;  // Sprint = thick lines
    } else if (keyboard_check(vk_control)) {
        max_speed = crouch_speed;  // Crouch = thin lines
    } else {
        max_speed = base_speed;    // Normal = medium lines
    }
    
    if (input_x != 0 || input_y != 0) {
        var target_direction = point_direction(0, 0, input_x, input_y);
        var direction_diff = angle_difference(target_direction, move_direction);
        move_direction += direction_diff * turn_speed;
        current_speed = min(current_speed + acceleration, max_speed);
    } else {
        current_speed *= friction;
    }
    
    velocity_x = lengthdir_x(current_speed, move_direction);
    velocity_y = lengthdir_y(current_speed, move_direction);
    x += velocity_x;
    y += velocity_y;
    
    if (current_speed > 0.1) {
        direction = move_direction;
    }
}
