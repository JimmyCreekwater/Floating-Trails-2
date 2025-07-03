// ===== obj_game - ASYNC NETWORKING EVENT =====
// Copy this entire block into obj_game Async - Networking Event

var msg_type = async_load[? "type"]; // FIXED: renamed from event_type to msg_type

if (msg_type == network_type_connect) {
    var socket = async_load[? "socket"];
    if (global.server >= 0) { // Server behavior
        var new_player_id = ds_map_size(global.ghosts) + 1; // FIXED: was ds_list_size
        ds_map_add(global.ghosts, socket, new_player_id);
        // Send the new player their ID
        var buffer = buffer_create(2, buffer_grow, 1); // FIXED: was 1, now 2 for two bytes
        buffer_write(buffer, buffer_u8, 1); // Message type 1: Player ID
        buffer_write(buffer, buffer_u8, new_player_id);
        network_send_raw(socket, buffer, buffer_get_size(buffer));
        buffer_delete(buffer);
    }
} else if (msg_type == network_type_disconnect) {
    var socket = async_load[? "socket"];
    if (ds_map_exists(global.ghosts, socket)) {
        var p_id = global.ghosts[? socket];
        // FIXED: Correct way to destroy ghost instances
        with (obj_ghost) {
            if (player_id == p_id) {
                instance_destroy();
            }
        }
        ds_map_delete(global.ghosts, socket);
    }
} else if (msg_type == network_type_data) {
    var socket = async_load[? "socket"];
    var buffer_id = async_load[? "buffer"];
    var buffer = buffer_create_from_id(buffer_id);

    var message_type = buffer_read(buffer, buffer_u8);

    if (message_type == 1) { // Player ID
        global.player_id = buffer_read(buffer, buffer_u8);
    } else if (message_type == 2) { // Player position
        var p_id = buffer_read(buffer, buffer_u8);
        var p_x = buffer_read(buffer, buffer_f32);
        var p_y = buffer_read(buffer, buffer_f32);
        
        if (p_id != global.player_id) {
            var ghost = noone;
            with (obj_ghost) {
                if (player_id == p_id) {
                    ghost = id;
                    break;
                }
            }

            if (ghost == noone) {
                ghost = instance_create_layer(p_x, p_y, "Instances", obj_ghost);
                ghost.player_id = p_id;
            }
            
            ghost.target_x = p_x;
            ghost.target_y = p_y;
        }
    }

    buffer_delete(buffer);
}
