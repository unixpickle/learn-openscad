layerHeight = 0.2;
topLayers = 6;
width = 20;
length = 10;

translate([length/2+1.5, 0, 1]) cube([length+15, width+1, 3], center=true);
translate([length - 0.3, 0, 9]) cube([3, width, 7], center=true);

difference() {
    translate([0, width/2, 2.15]) rotate([90, 0, 0]) linear_extrude(width, convexity=2) polygon([
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
    translate([20, 0, 0]) cube([20, width-1, 5.6], center=true);
}

/*translate([-20, 0, 4]) cube([2, 10, 7], center=true);
translate([-15, 0, 7.01]) cube([10, 10, 1], center=true);
translate([-8, 0, 5]) rotate([0, 45, 0]) cube([5, 10, 1], center=true);*/