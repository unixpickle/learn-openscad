clipHoleRadius = 5;
clipHoleFn = 80;

module sanderBody() {
    difference() {
        minkowski() {
            cylinder(h=1.1, r=50, center=true, $fn=190);
            sphere(r=2.5, $fn=30);
        }

        for (i = [0, 90, 180, 270]) {
            rotate([0, 0, i]) translate([32, 0, 0]) cylinder(h=100, r=clipHoleRadius, $fn=clipHoleFn);
        }
    }

    // Hex key to stick into screwdriver
    screwSize = 4;
    linear_extrude(40) polygon([for (i = [0:6]) [cos(i*360/6)*screwSize, sin(i*360/6)*screwSize]]);
    cylinder(h=10, r=10);
}

module clipPlug() {
    rotate([180, 0, 0]) {
        // Small hole for the peg
        cylinder(h=2.5001, r=clipHoleRadius, $fn=clipHoleFn);
        
        // A divoted larger handle that can be printed without supports.
        translate([0, 0, 2.5]) linear_extrude(clipHoleRadius*1.5, scale=2.0) circle(r=clipHoleRadius, $fn=clipHoleFn);
        translate([0, 0, clipHoleRadius*1.5+2.5]) rotate([180, 0, 0]) linear_extrude(clipHoleRadius*1.5, scale=2.0) circle(r=clipHoleRadius, $fn=clipHoleFn);
    }
}

sanderBody();

//clipPlug();

