$fn = 130;

arm_length = 200;
finger_length = 30;
finger_radius = 3;
arm_radius = 5;

nose_radius = 7.0;
nose_length = 40.0;

module arm() {
    translate([0, 3, 0]) linear_extrude(height=arm_length, twist=80, scale=0.7) translate([5.0, 0, 0])
        polygon([
            [cos(0)*arm_radius*0.90,   sin(0)*arm_radius*0.90],
            [cos(15)*arm_radius*1.05,  sin(15)*arm_radius*1.05],
            [cos(30)*arm_radius*0.97,  sin(30)*arm_radius*0.97],
            [cos(45)*arm_radius*1.01,  sin(45)*arm_radius*1.01],
            [cos(60)*arm_radius*0.95,  sin(60)*arm_radius*0.95],
            [cos(75)*arm_radius*1.02,  sin(75)*arm_radius*1.02],
            [cos(90)*arm_radius*0.99,  sin(90)*arm_radius*0.99],
            [cos(105)*arm_radius*1.05, sin(105)*arm_radius*1.05],
            [cos(120)*arm_radius*0.92, sin(120)*arm_radius*0.92],
            [cos(135)*arm_radius*1.03, sin(135)*arm_radius*1.03],
            [cos(150)*arm_radius*0.95, sin(150)*arm_radius*0.95],
            [cos(165)*arm_radius*1.03, sin(165)*arm_radius*1.03],
            [cos(180)*arm_radius*0.94, sin(180)*arm_radius*0.94],
            [cos(195)*arm_radius*1.07, sin(195)*arm_radius*1.07],
            [cos(210)*arm_radius*0.94, sin(210)*arm_radius*0.94],
            [cos(225)*arm_radius*1.04, sin(225)*arm_radius*1.04],
            [cos(240)*arm_radius*0.98, sin(240)*arm_radius*0.98],
            [cos(255)*arm_radius*1.03, sin(255)*arm_radius*1.03],
            [cos(270)*arm_radius*0.93, sin(270)*arm_radius*0.93],
            [cos(285)*arm_radius*1.01, sin(285)*arm_radius*1.01],
            [cos(300)*arm_radius*0.96, sin(300)*arm_radius*0.96],
            [cos(315)*arm_radius*1.04, sin(315)*arm_radius*1.04],
            [cos(330)*arm_radius*0.96, sin(330)*arm_radius*0.96],
            [cos(345)*arm_radius*1.05, sin(345)*arm_radius*1.05]
        ]);

    translate([0, 0, arm_length-5]) rotate([0, 35, 0]) linear_extrude(height=finger_length, scale=0.7) circle(finger_radius);
    translate([0, 0, arm_length-10]) rotate([0, -40, 0]) linear_extrude(height=finger_length, scale=0.7) circle(finger_radius);
        translate([2, 0, arm_length-30]) rotate([0, 40, 30]) linear_extrude(height=finger_length*0.8, scale=0.7) circle(finger_radius);
}

module nose() {
    difference() {
        // carrot body
        linear_extrude(height=nose_length, scale=0.3) circle(r=nose_radius);
        
        // ridges in the carrot
        translate([0, 0, nose_length*0.22]) rotate_extrude() translate([nose_radius*(1-0.7*0.22)+0.8, 0, 0]) circle(r=1);
        translate([0, 0, nose_length*0.5]) rotate_extrude() translate([nose_radius*(1-0.7*0.5)+0.8, 0, 0]) circle(r=1);
        translate([0, 0, nose_length*0.8]) rotate_extrude() translate([nose_radius*(1-0.7*0.8)+0.8, 0, 0]) circle(r=1);
    }
    
    // rounded tip
    sphere_radius = nose_radius * 0.305;
    end_radius = nose_radius * 0.3;
    sphere_tip_height = sphere_radius-sqrt(sphere_radius*sphere_radius - end_radius*end_radius);
    translate([0, 0, nose_length-(sphere_radius-sphere_tip_height)-0.0001]) 
        intersection() {
            sphere(sphere_radius);
            translate([0, 0, 5 + sphere_radius-sphere_tip_height]) cube([10, 10, 10], center=true);
        }
        
    // stake to go into the body
    rotate([180, 0, 0]) linear_extrude(height=20, scale=0.3) circle(r=4);
}

module topHat() {
    difference() {
        union() {
            scale([0.8, 1, 1]) cylinder(h=40, r=40);
            translate([0, 0, -0.01]) scale([0.8, 1, 1]) cylinder(h=5, r=60);
        }
        translate([0, 0, -0.02]) scale([0.8, 1, 1]) cylinder(h=38, r=35);
    }
}

//arm();

//nose();

topHat();