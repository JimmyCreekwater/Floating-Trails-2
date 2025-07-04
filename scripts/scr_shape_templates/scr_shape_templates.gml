function scr_shape_templates() {
    // Define shape templates with relative points (0-1 scale)
    global.shape_templates = ds_map_create();
    
    // SQUARE
    var square = ds_list_create();
    ds_list_add(square, [0, 0]);      // Top-left
    ds_list_add(square, [1, 0]);      // Top-right
    ds_list_add(square, [1, 1]);      // Bottom-right
    ds_list_add(square, [0, 1]);      // Bottom-left
    ds_list_add(square, [0, 0]);      // Close
    global.shape_templates[? "Square"] = square;
    
    // TRIANGLE
    var triangle = ds_list_create();
    ds_list_add(triangle, [0.5, 0]);   // Top
    ds_list_add(triangle, [1, 1]);     // Bottom-right
    ds_list_add(triangle, [0, 1]);     // Bottom-left
    ds_list_add(triangle, [0.5, 0]);   // Close
    global.shape_templates[? "Triangle"] = triangle;
    
    // CIRCLE (12 points)
    var circle = ds_list_create();
    for (var i = 0; i <= 12; i++) {
        var angle = (i / 12) * 360;
        var px = 0.5 + lengthdir_x(0.5, angle);
        var py = 0.5 + lengthdir_y(0.5, angle);
        ds_list_add(circle, [px, py]);
    }
    global.shape_templates[? "Circle"] = circle;
    
    // STAR (5 points)
    var star = ds_list_create();
    for (var i = 0; i <= 10; i++) {
        var angle = (i / 10) * 360 - 90;
        var radius = (i % 2 == 0) ? 0.5 : 0.2;
        var px = 0.5 + lengthdir_x(radius, angle);
        var py = 0.5 + lengthdir_y(radius, angle);
        ds_list_add(star, [px, py]);
    }
    global.shape_templates[? "Star"] = star;
    
    // Shape point values
    global.shape_points = ds_map_create();
    global.shape_points[? "Square"] = 50;
    global.shape_points[? "Triangle"] = 75;
    global.shape_points[? "Circle"] = 100;
    global.shape_points[? "Star"] = 150;
    global.shape_points[? "Community"] = 200;
}