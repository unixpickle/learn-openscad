// Creating screws with various profiles.
//
// A profile is defined as a piecewise-linear function of
// phase (0 to 1), and y values are the inset distance from
// the outer cylinder of the screw, defined as a multiple of
// pitch/2.

$fn = 100;

// A 45 degree vertically symmetric screw
simple_45deg_iso = [
  [0, 1],
  [0.5, 0],
  [1, 1],
];

// A buttress screw with a 45 degree bottom flank
// so that it can be 3D printed.
buttress = [
  [0, 1],
  [0.2, 0],
  [0.3, 0],
  [0.8, 1],
  [1, 1],
];

// A print-optimized trapezoidal thread.
printable_trapezoid = [
  [0.0, 0.4],
  [0.15, 0.4],
  [0.35, 0],
  [0.65, 0],
  [0.85, 0.4],
  [1.0, 0.4],
];

// Create a screw for the given profile.
module screw(profile, h=10, r=3, segments=256, pitch=2) {
    linear_extrude(h, twist = -360 * h / pitch)
      polygon([
        for (i = [0:segments])
          let (
            theta = i / segments * 360,
            y = lookup(theta/360, profile),
            rad = r - pitch/2 * y
          ) [cos(theta)*rad, sin(theta)*rad]
      ]);
}

// Lay out some profiles side-by-side.
profiles = [simple_45deg_iso, buttress, printable_trapezoid];
for (i = [0:len(profiles)-1])
  translate([i * 8, 0, 0])
    screw(profiles[i]);
