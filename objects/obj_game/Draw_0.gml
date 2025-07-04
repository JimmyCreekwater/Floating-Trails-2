// Draw the trail canvas as background layer (existing code)
if (surface_exists(trail_canvas)) {
    draw_surface(trail_canvas, 0, 0);
}

// Update and draw shape fill surface
if (surface_exists(shape_fill_surface)) {
    // Fade the surface
    surface_set_target(shape_fill_surface);
    gpu_set_blendmode_ext(bm_dest_color, bm_zero);
    draw_set_color(c_white);
    draw_set_alpha(0.98); // Slow fade
    draw_rectangle(0, 0, room_width, room_height, false);
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    
    // Draw it
    draw_surface(shape_fill_surface, 0, 0);
}