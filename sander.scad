module clip() {
    layerHeight = 0.2;
    topLayers = 6;
    width = 20;
    length = 10;

    translate([length - 0.3, 0, 6.5]) cube([3, width, 7], center=true);
    translate([length - 0.3, 0, 10]) rotate([0, 45, 0]) cube([4, width, 4], center=true);

    difference() {
        translate([0, width/2]) rotate([90, 0, 0]) linear_extrude(width, convexity=2) polygon([
            [0, 0],
            [3, 0],
            [3, 3],
            [length, 3],
            [length+3, 0],
            [length+4, 1],
            [length+2-topLayers*layerHeight, 3+topLayers*layerHeight],
            [-1, 3+topLayers*layerHeight],
            [-1, 0],
        ]);
        translate([20, 0, 0]) cube([20, width-1, 2.9], center=true);
    }
}

translate([0, 0, -2]) minkowski() {
    cylinder(h=1.1, r=50, center=true, $fn=190);
    sphere(r=2.5, $fn=30);
}

for (i = [0, 90, 180, 270]) {
    rotate([0, 0, i]) translate([30, 0, 0]) clip();
}

// Hex key to stick into screwdriver
screwSize = 3;
linear_extrude(40) polygon([for (i = [0:6]) [cos(i*360/6)*screwSize, sin(i*360/6)*screwSize]]);
cylinder(h=10, r=10);