// SAFETY: Initialize missing variables for old shard instances
if (!variable_instance_exists(id, "current_lifespan")) {
    // Old shard - initialize all missing variables with shorter lifespan
    max_lifespan = 360; // Give old shards 6 seconds to live
    current_lifespan = max_lifespan;
    flash_phase = 0;
    flash_timer = 0;
    warning_time = 180;
    urgent_time = 60;
}
// Rest of the Step code stays the same...
// (Keep all the existing Step_0.gml code after this safety check)


// Bobbing animation
bob_offset += 2;
y += sin(bob_offset * 0.1) * 0.5;
// NEW: LIFESPAN COUNTDOWN
current_lifespan--;
// Determine flash phase based on remaining time
if (current_lifespan <= 0) {
    // Time's up! Despawn with small effect
    instance_destroy();
} else if (current_lifespan <= urgent_time) {
    flash_phase = 3; // Urgent flash
} else if (current_lifespan <= warning_time) {
    if (current_lifespan <= urgent_time * 2) {
        flash_phase = 2; // Fast flash
    } else {
        flash_phase = 1; // Slow flash
    }
} else {
    flash_phase = 0; // Stable
}
// Flash timer for different phases
flash_timer++;
switch (flash_phase) {
    case 0: // Stable - normal sparkle
        sparkle_timer++;
        if (sparkle_timer >= 30) sparkle_timer = 0;
        break;
        
    case 1: // Slow flash (3-2 seconds remaining)
        sparkle_timer++;
        if (sparkle_timer >= 20) sparkle_timer = 0; // Slightly faster
        break;
        
    case 2: // Fast flash (2-1 seconds remaining)  
        sparkle_timer++;
        if (sparkle_timer >= 10) sparkle_timer = 0; // Much faster
        break;
        
    case 3: // Urgent flash (< 1 second remaining)
        sparkle_timer++;
        if (sparkle_timer >= 5) sparkle_timer = 0; // Very fast
        break;
}
// Check for collection by player
if (instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) < collection_range) {
        // Collected!
        obj_player.shards += shard_value;
        instance_destroy();
    }
}
