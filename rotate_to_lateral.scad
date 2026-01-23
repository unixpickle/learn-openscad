// Convert rotational movement into lateral movement with a 3D print.

thickness = 10;
boardWidth = 75;
boardLength = 155;

linearPegRadius = 5;
radialPegRadius = 30;
swivelPegRadius = 5;
linearCutoutLength = 60;
hexCutoutRadius = 4;
hexDrillBitLength = 30;
clearance = 1;

pegHeight = 20;

module cutoutProfile(radius) {
    polygon([
        [0, -thickness/2],
        [0, thickness/2],
        [radius, thickness/2],
        [radius+thickness/2, 0],
        [radius, -thickness/2],
    ]);
}

module cutoutCylinder(radius) {
    rotate_extrude($fa=1) cutoutProfile(radius);
}

module cutoutRect(radius, length) {
    translate([0, length/2, 0]) rotate([90, 0, 0]) linear_extrude(length) union() {
        cutoutProfile(radius);
        translate([0.0001, 0, 0]) rotate([0, 0, 180]) cutoutProfile(radius);
    }
}

// Body with cutouts
linearCutoutY = (boardLength - linearCutoutLength) / 2 - 5;
radialCutoutY = linearCutoutY - linearCutoutLength/2 - radialPegRadius - thickness*2;
difference() {
    cube([boardWidth, boardLength, thickness-0.01], center=true);
    translate([0, linearCutoutY, 0])
        cutoutRect(linearPegRadius + clearance, linearCutoutLength);
    translate([0, radialCutoutY, 0])
        cutoutCylinder(radialPegRadius+clearance);
}

// Pegs
linearPegClosestY = linearCutoutY - linearCutoutLength/2 + linearPegRadius + thickness/2 + 5;
swivelPegY = radialCutoutY - radialPegRadius + swivelPegRadius + thickness/2 + 2;
difference() {
    translate([0, radialCutoutY, 0]) cutoutCylinder(radialPegRadius);
    scale([1, 1, 1.001]) translate([0, swivelPegY, 0])
        cutoutCylinder(swivelPegRadius + clearance);
    
    // Cutout in spinner for hexagon drill bit
    translate([0, radialCutoutY, -thickness/2-0.01])
        linear_extrude(thickness/2)
        polygon([for (i=[0:6]) [sin(i*60)*hexCutoutRadius, cos(i*60)*hexCutoutRadius]]);

}
translate([0, linearPegClosestY, 0]) cutoutCylinder(linearPegRadius);
translate([0, swivelPegY, 0]) cutoutCylinder(swivelPegRadius);

// Connection between linear and swivel pegs
connectionLength = linearPegClosestY - swivelPegY;
connectionThickness = 2;
translate([0, linearPegClosestY, thickness/2-0.01])
    cylinder(h=pegHeight, r=linearPegRadius, $fn=40);
translate([0, swivelPegY, thickness/2-0.01])
    cylinder(h=pegHeight, r=linearPegRadius, $fn=40);
translate([0, (linearPegClosestY + swivelPegY)/2, thickness/2+pegHeight-connectionThickness/2])
    cube([linearPegRadius*2, connectionLength, connectionThickness], center=true);

// Drill bit to print with this
/*translate([0, boardLength/2+30, -thickness/2-0.01])
        linear_extrude(hexDrillBitLength)
        polygon([for (i=[0:6]) [sin(i*60)*hexCutoutRadius, cos(i*60)*hexCutoutRadius]]);*/