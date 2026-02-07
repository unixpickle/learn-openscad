cornerRadius = 5;
width = 50;
depth = 37;
cutoutRadius = depth;
height = 78+cutoutRadius;
thickness = 4;
textCutout = 0.3;

difference() {
    minkowski() {
        x = thickness*2 - cornerRadius*2;
        cube([width+x, depth+x, height+x], center=true);
        sphere(r=cornerRadius, $fn=50);
    }
    
    // Interior cutout
    minkowski() {
        translate([0, 0, cornerRadius*2+0.01]) cube([width-cornerRadius*2, depth-cornerRadius*2, height-cornerRadius*2], center=true);
        sphere(r=cornerRadius, $fn=30);
    }
    
    // Top cutout
    translate([0, depth/2, height/2])
        rotate([0, 90, 0])
        cylinder(r=cutoutRadius, h=width+cornerRadius*2+0.1, center=true, $fn=130);
    
    // Text cutout
    translate([0, -depth/2-textCutout, height/2-10])
        rotate([90, 0, 180])
        linear_extrude(height=textCutout*2)
        text("Essence", size=6, font="Arial:style=Bold", halign="center", valign="center");
}

// Wedge stand for an angle
rotate([90, 0, 90]) translate([0, 0, -width/2]) linear_extrude(width) polygon([
    [-depth/2 - thickness, height/2-cutoutRadius],
    [-depth/2, height/2-cutoutRadius],
    [-depth/2, -height/2],
    [-depth/2+1, -height/2 - thickness],
    [-depth/2 - thickness, -height/2-thickness],
    [-depth/2 - thickness - height/4, height/2-cutoutRadius],
]);