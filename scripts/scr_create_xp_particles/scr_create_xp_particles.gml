/ CREATE NEW SCRIPT: scr_create_xp_particles

function scr_create_xp_particles(start_x, start_y, xp_amount, gem_amount) {
    // Create XP particles
    var particle_count = min(10, floor(xp_amount / 10)); // 1 particle per 10 XP, max 10
    
    for (var i = 0; i < particle_count; i++) {
        var particle = [
            start_x + random_range(-20, 20),    // [0] Current X
            start_y + random_range(-20, 20),    // [1] Current Y
            start_x,                            // [2] Start X
            start_y,                            // [3] Start Y
            20,                                 // [4] Target X (UI position - will update)
            gui_height - 90,                    // [5] Target Y (XP position in UI)
            0,                                  // [6] Progress (0-1)
            random_range(60, 90),               // [7] Travel time
            random_range(-5, 5),                // [8] X wobble
            random_range(-5, 5),                // [9] Y wobble
            c_lime,                             // [10] Color (XP = green)
            "XP",                               // [11] Type
            i * 3                               // [12] Delay frames
        ];
        ds_list_add(global.xp_particles, particle);
    }
    
    // Create gem particle
    if (gem_amount > 0) {
        var gem_particle = [
            start_x,                            // [0] Current X
            start_y,                            // [1] Current Y
            start_x,                            // [2] Start X
            start_y,                            // [3] Start Y
            20,                                 // [4] Target X
            gui_height - 60,                    // [5] Target Y (Gem position in UI)
            0,                                  // [6] Progress
            90,                                 // [7] Travel time
            0,                                  // [8] X wobble
            0,                                  // [9] Y wobble
            c_fuchsia,                          // [10] Color (Gem = pink)
            "GEM",                              // [11] Type
            particle_count * 3 + 10             // [12] Delay (after XP)
        ];
        ds_list_add(global.xp_particles, gem_particle);
    }
}