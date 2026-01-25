// Convert rotational movement into lateral movement with a 3D print.
// I've learned that this is called a linear actuator.
//
// The main body is print-in-place, with a linear track and a circular
// track, each with a "peg" printed in place to stick into the tracks.
// The rotating peg is not actually a full disc, but a cutout of one, to
// reduce friction while still staying stuck in place in the board.
//
// There are poles on top of both pegs, which can be connected by a connection
// (a long thin rectangular object with holes at each end).
// The connector is locked into place by squeezing caps onto the tops of
// the poles, such that the connector itself can change angles a bit as the
// rotational peg is spun.
//
// There is a hex cutout in the bottom of the radial (rotating) peg, with a
// hexagonal drill bit that can be squeezed into it and inserted into a drill
// to test the actuator at higher speeds/torque.

thickness = 10;
boardWidth = 75;
boardLength = 155;

linearPegRadius = 5;
radialPegRadius = 30;
radialPegMargin = 5;

poleRadius = 5;
poleJutSize = 2;
poleCapSize = 4;
poleCapRadius = poleRadius+3;
poleHeight = 20;

connectionClearance = 0.5;
connectionThickness = 5;

linearCutoutLength = 60;
hexCutoutRadius = 4;
hexDrillBitLength = 30;

pegClearanceMiddle = 0.6;
pegClearanceEnds = 1.0;

linearCutoutY = (boardLength - linearCutoutLength) / 2 - 5;
radialCutoutY = linearCutoutY - linearCutoutLength/2 - radialPegRadius - thickness*2;
linearPegClosestY = linearCutoutY - linearCutoutLength/2 + linearPegRadius + thickness/2 + 5;
swivelPegY = radialCutoutY - radialPegRadius + poleRadius + thickness/2 + 2;

connectionLength = linearPegClosestY - swivelPegY;

module cutoutProfile(radius, hole=false) {
    polygon([
        [0, -thickness/2],
        [0, thickness/2],
        [radius + (hole ? pegClearanceEnds : 0), thickness/2],
        [radius + thickness/2 + (hole ? pegClearanceMiddle : 0), 0],
        [radius + (hole ? pegClearanceEnds : 0), -thickness/2],
    ]);
}

module cutoutCylinder(radius, hole=false) {
    rotate_extrude($fn=100) cutoutProfile(radius, hole=hole);
}

module cutoutRect(radius, length) {
    translate([0, length/2, 0]) rotate([90, 0, 0]) linear_extrude(length) union() {
        cutoutProfile(radius, hole=true);
        translate([0.0001, 0, 0]) rotate([0, 0, 180]) cutoutProfile(radius, hole=true);
    }
}

module body() {
    difference() {
        cube([boardWidth, boardLength, thickness-0.01], center=true);
        translate([0, linearCutoutY, 0])
            cutoutRect(linearPegRadius, linearCutoutLength);
        translate([0, radialCutoutY, 0])
            cutoutCylinder(radialPegRadius, hole=true);
    }
}


module pegs() {
    // Large rotating peg
    difference() {
        translate([0, radialCutoutY, 0]) cutoutCylinder(radialPegRadius);

        // Instead of a circle rotating inside another circle, we just have a slice of the circle, which should reduce friction.
        translate([radialPegRadius/2+poleRadius+radialPegMargin, 0, 0])
            cube([radialPegRadius, boardLength, thickness+0.1], center=true);
        translate([-radialPegRadius/2-poleRadius-radialPegMargin, 0, 0])
            cube([radialPegRadius, boardLength, thickness+0.1], center=true);

        // Cutout in center of bottom for hexagon drill bit
        translate([0, radialCutoutY, -thickness/2-0.01])
            linear_extrude(thickness/2)
            polygon([for (i=[0:6]) [sin(i*60)*hexCutoutRadius, cos(i*60)*hexCutoutRadius]]);
    }
    
    // Small linear movement peg
    translate([0, linearPegClosestY, 0]) cutoutCylinder(linearPegRadius);
}

module pole(r) {
    cylinder(h=poleHeight, r=r, $fn=50);
    
    // Jut out on pole that connection sits on.
    translate([0, 0, poleHeight-connectionThickness-poleJutSize*2-poleCapSize])
        rotate_extrude($fn=50)
        polygon([
            [r, 0],
            [r+poleJutSize, poleJutSize],
            [r, poleJutSize*2]
        ]);
}

module poles(extraRadius=0) {
    translate([0, linearPegClosestY, thickness/2-0.01])
    pole(r=poleRadius+extraRadius);
translate([0, swivelPegY, thickness/2-0.01])
    pole(r=poleRadius+extraRadius);
}

module connection() {
    difference() {
        extraWidth = 5;
        extraLength = 10;
        translate([0, (linearPegClosestY + swivelPegY)/2, thickness/2+poleHeight-connectionThickness/2-poleCapSize])
            cube([linearPegRadius*2+extraWidth, connectionLength+poleRadius*2+extraLength, connectionThickness], center=true);
        poles(extraRadius=connectionClearance);
    }
}

module connectionCaps() {
    difference() {
        union() {
            capZ = poleHeight+thickness/2-poleCapSize-0.1;
            translate([0, linearPegClosestY, capZ]) cylinder(h=poleCapSize, r=poleCapRadius, $fn=80);
            translate([0, swivelPegY, capZ]) cylinder(h=poleCapSize, r=poleCapRadius, $fn=80);
        }
        poles(extraRadius=0.01);
    }
}

module drillBit() {
    translate([0, boardLength/2+30, -thickness/2-0.01])
        linear_extrude(hexDrillBitLength)
        polygon([for (i=[0:6]) [sin(i*60)*hexCutoutRadius, cos(i*60)*hexCutoutRadius]]);
}

module mainBody() {
    body();
    pegs();
    poles();
}

// Un-comment one of these to create that part.
mainBody();
//connection();
//connectionCaps();
//drillBit();