// # swivel
//
// This is a project intended to be used to take 3D scans of small objects.
// The idea is that there is a platform which can be rotated freely using a ball
// bearing.
// The base has holes so that things such as backdrops or phone holders can be
// mounted around the swivel.

$fa = 1;
$fs = 0.4;

thickness = 5;
topSize = 235;

ballRadius = 10;
loopRadius = 50;
ballCount = floor(2 * PI * loopRadius / (ballRadius * 2));
ridgeThickness = 5;
ridgeHeight = ballRadius*1.5;
ridgeSlack = 0.4;

topThickness = 5;
topGrooveThickness = 3;
topGrooveCount = 200;
topRadius = 195/2;
topRidgeThickness = 2;
topRidgeJut = ridgeThickness - topRidgeThickness;
topRidgeHeight = ballRadius;

backdropThickness = 5;
backdropHeight = 150;

module ridge(r) {
    translate([0, 0, 0.0001]) difference() {
        cylinder(h = thickness + ridgeHeight, r = r+ridgeThickness/2);
        translate([0, 0, -0.05]) cylinder(h = thickness + ridgeHeight + 0.1, r = r-ridgeThickness/2);
    }
}

module base() {
    difference() {
        linear_extrude(thickness) square(topSize, center=true);
        
        minX = -(topSize - 20) / 2;
        spanX = topSize - 20;

        for (i = [0:9]) {
            for (j = [0:1]) {
                translate([minX + spanX/9 * i, minX + spanX * j, -0.01]) linear_extrude(thickness+0.02) circle(5);
            }
        }
        for (i = [1:8]) {
            for (j = [0:1]) {
                translate([minX + spanX * j, minX + spanX/9 * i, -0.01]) linear_extrude(thickness+0.02) circle(5);
            }
        }
    }

    ridge(loopRadius - ballRadius - ridgeSlack/2 - ridgeThickness/2);
    ridge(loopRadius + ballRadius + ridgeSlack/2 + ridgeThickness/2);
}

module balls(ballCount) {
    for (i = [0:ballCount-1]) {
        theta = i * 360 / ballCount;
        translate([cos(theta)*loopRadius, sin(theta)*loopRadius, thickness+ballRadius + 0.2]) sphere(r=ballRadius);
    }
}

module topRidge(r) {
    translate([0, 0, thickness+ballRadius*2+0.8001]) rotate_extrude() translate([r, 0, 0]) rotate([0, 0, 180]) polygon([
        [-topRidgeThickness/2, 0],
        [-topRidgeThickness/2, topRidgeHeight-topRidgeJut/2],
        [-(topRidgeThickness/2 + topRidgeJut/2), topRidgeHeight],
        [topRidgeThickness/2 + topRidgeJut/2, topRidgeHeight],
        [topRidgeThickness/2, topRidgeHeight-topRidgeJut/2],
        [topRidgeThickness/2, 0],
    ]);
}

function pol(r, a) = [r*cos(a), r*sin(a)];

module top() {
    translate([0, 0, thickness + ballRadius*2 + 0.2 + topGrooveThickness])
        cylinder(h = topThickness-topGrooveThickness, r = topRadius);
    lowRadius = topRadius - (2 * PI * topRadius)/topGrooveCount;
    points = [
        for (i = [0 : topGrooveCount-1])
            pol((i % 2 == 1) ? topRadius : lowRadius, 360*i/topGrooveCount)
    ];
    translate([0, 0, thickness + ballRadius*2 + 0.8])
        linear_extrude(height = topThickness + 0.01)
        polygon(points);
}

module peg() {
    rotate_extrude() polygon([[0, 0], [3, 0], [5, 2], [5, 20], [0, 25]]);
}

module backdrop() {
    difference() {
        translate([0, 0, 20]) cylinder(h=backdropHeight, r=topSize/2+backdropThickness/2-10);
        cylinder(h=backdropHeight+100, r=topSize/2-backdropThickness/2-10);
        cube([topSize/2, topSize/2, backdropHeight+100]);
    }
    translate([topSize/2-10, -(topSize-20)/9/2, 0]) peg();
    translate([-topSize/2+10, -(topSize-20)/9/2, 0]) peg();
    translate([-(topSize-20)/9/2, -topSize/2+10, 0]) peg();
    translate([-(topSize-20)/9/2, topSize/2-10, 0]) peg();
}

//base();
//balls(ballCount);
//top();
//topRidge(loopRadius-ballRadius-ridgeSlack/2-ridgeThickness*1.5-0.4);
//topRidge(loopRadius+ballRadius+ridgeSlack/2+ridgeThickness*1.5+0.4);
backdrop();