module paste_polygon(pow1, pow2, tipCut=0) {
    top = [
        for (i = [0:100])
        let (x = tipCut + (i / 50) * (1 - tipCut), y=sin(x*180)*0.25+pow(x, pow1)/pow(2, pow1))
        [x, y]
    ];
    bottom = [
        for (i = [0:100])
        let (x = 2 - (tipCut + (i / 50) * (1 - tipCut)), y=sin(x*180)*0.25+pow(x, pow2)/pow(2, pow2))
        [x, y]
    ];
    scale([115/2, 115/2, 1]) polygon(concat(top, bottom));
}

intersection() {
    difference() {
        linear_extrude(10, convexity=3) paste_polygon(0.5, 3);
        translate([29, 35, -0.1]) rotate([90, 0, 65]) linear_extrude(55)
            polygon([[3/2, 0], [-3/2, 0], [-3/2, 1], [-5, 11], [5, 11], [3/2, 1]]);
        translate([0, 0, 9.6]) linear_extrude(0.5, convexity=3, scale=1.0) paste_polygon(1.9, 2.2, tipCut=0.05);
        translate([0, 0, 9.6]) linear_extrude(0.5, convexity=3, scale=1.0) paste_polygon(0.7, 0.8, tipCut=0.05);
        translate([0, 0, 9.6]) linear_extrude(0.5, convexity=3, scale=1.0) paste_polygon(1.1, 1.3, tipCut=0.05);
    }
    translate([115/2, 115/2-38, -1]) cylinder(h=15, r=115/2, $fn=200);
}