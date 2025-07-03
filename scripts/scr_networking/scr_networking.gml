// ===== scr_networking =====
// Create this as a Script Asset in Game Maker Studio

function scr_networking() {
    // Check if player exists
    if (!instance_exists(obj_player)) return;
    
    var buffer = buffer_create(9, buffer_grow, 1);
    buffer_write(buffer, buffer_u8, 2); // Message type 2: Player position
    buffer_write(buffer, buffer_u8, global.player_id);
    
    // FIXED: Get player position safely
    with (obj_player) {
        buffer_write(buffer, buffer_f32, x);
        buffer_write(buffer, buffer_f32, y);
    }

    if (global.server >= 0) { // Server sends to all clients
        // FIXED: Correct way to iterate through ds_map
        var keys = ds_map_keys_to_array(global.ghosts);
        for (var i = 0; i < array_length(keys); i++) {
            var socket = keys[i];
            network_send_raw(socket, buffer, buffer_get_size(buffer));
        }
    } else if (global.client >= 0) { // Client sends to server
        network_send_raw(global.client, buffer, buffer_get_size(buffer));
    }

    buffer_delete(buffer);
}
