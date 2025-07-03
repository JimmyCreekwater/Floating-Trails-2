// ===== scr_camera_control =====
// Create this as a Script Asset in Game Maker Studio

function scr_camera_control() {
    // FIXED: Check if player exists first
    if (!instance_exists(obj_player)) return;
    
    var camera = view_camera[0];
    
    // FIXED: Get player position safely
    var player_x = 0;
    var player_y = 0;
    with (obj_player) {
        player_x = x;
        player_y = y;
    }
    
    var target_x = player_x - view_wport[0] / 2;
    var target_y = player_y - view_hport[0] / 2;

    var cam_x = camera_get_view_x(camera);
    var cam_y = camera_get_view_y(camera);

    // CUSTOMIZE: Change 0.1 to 0.05 for smoother camera, 0.2 for snappier
    camera_set_view_pos(camera, lerp(cam_x, target_x, 0.1), lerp(cam_y, target_y, 0.1));
}
