// A 3D printable house key.
// This has been changed to not reflect an actual key.

$fn = 40;

teeth_thickness = 0.96;
thickness = 1.92;
round_cut_size = 6;
groove_thickness = 0.96;

difference() {
    linear_extrude(thickness) scale([0.1, 0.1, 0.1]) polygon([
        // Teeth of key
        [0, 0],
        [27, 20],
        [40, 25],
        [53, 20],
        [68, 35],
        [82, 23],
        [93, 23],
        [107, 30],
        [123, 22],
        [130, 22],
        [145, 34],
        [161, 24],
        [172, 24],
        [190, 51],
        [207, 32],
        // End of teeth
        [225, 51],
        [261, 52],
        [271, 71],
        [315, 71],
        [320, 87],
        [352, 86],
        [413, 140],
        [527, 40],
        [527, -24],
        [413, -123],
        [352, -69],
        [320, -66],
        [315, -53],
        [269, -53],
        [267, -32],
        [260, -28],
        [250, -31],
        [246, -34],
        [19, -34],
        [0, -10],
    ]);
    
    // Depth cutout for jagged / teeth part
    translate([0, 1.2, teeth_thickness]) cube([26.3, 100, 1.0]);
    translate([26.3, 1.2, round_cut_size + teeth_thickness]) rotate([0, 90, 90]) cylinder(h=4.2, r=round_cut_size);
    
    // Groove on top
    translate([26.7-0.01, 0, 0]) rotate([90, 0, 0]) rotate([0, 90, 0]) translate([0, 0, -26.7]) linear_extrude(26.7) polygon([[0, thickness], [-(1.1+1.3)-0.2, thickness+0.01], [-(1.1+1.3), groove_thickness]]);
    
    // Groove on bottom
    translate([26.7-0.01, 0, 0]) rotate([90, 0, 0]) rotate([0, 90, 0]) translate([0, 0, -26.7]) linear_extrude(26.7) polygon([[0.3, 0], [-(1.1+1.3), 0], [0.2, thickness - groove_thickness]]);
    
    // Cutout on top
    translate([43, -4.3, 0]) cube([5, 10, 100]);
}