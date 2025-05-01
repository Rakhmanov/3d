// Parametric Purge Bellow for Zerno Z1 Grinder (Accordion Shape)

// Parameters
diameter = 58.5;           // Outer diameter (mm)
folds = 8;                 // Number of accordion folds
wall_thickness = 0.8;      // Wall thickness (mm)
wave_depth = 8.0;          // Depth of each accordion wave (mm)
height_per_fold = 5.0;     // Height of each fold (mm)
press_fit_tolerance = 1;   // Tolerance for press-fit (mm)
sgmt = 120;                // Number of sgmt per fold (must be even for wave)
insert_lip_height = 10;    

// Derived parameters
total_height_accordion = folds * height_per_fold;
total_height = total_height_accordion + 2*insert_lip_height;
insert_lip_diameter = diameter - press_fit_tolerance;

// Module for accordion shape
module accordion() {
    for(i = [0 : folds - 1]) {
        outer_d = (i % 2 == 0) ? diameter : diameter - wave_depth;
        next_outer_d = (i % 2 == 0) ? diameter - wave_depth : diameter;
        fold(i, outer_d, next_outer_d);
    }
}

module fold(i, outer_d, next_outer_d) {
    // Make the first fold (bottom) thicker for better connection with insert
    bottom_wall_addition = (i == 0) ? 4.2 : 0;
    
    translate([0, 0, i * height_per_fold])
        difference() {
            // Outer shape
            cylinder(
                h = height_per_fold, 
                d1 = outer_d, 
                d2 = next_outer_d, 
                $fn = sgmt
            );
            
            // Inner cutout - thicker wall at bottom if it's the first fold
            translate([0, 0, -0.01])
                cylinder(
                    h = height_per_fold + 0.02, 
                    d1 = outer_d - 2*wall_thickness - bottom_wall_addition, 
                    d2 = next_outer_d - 2*wall_thickness, 
                    $fn = sgmt
                );
        }
}


// Module for insert lip
module insert_lip() {
    union() {
        // Main body of the lip
        difference() {
            cylinder(h = insert_lip_height, d = insert_lip_diameter - 2, $fn=100);
            translate([0, 0, -0.01])
                cylinder(h = insert_lip_height + 0.02, d = insert_lip_diameter - 6*wall_thickness, $fn=100);
        }
    }
}


module top_lip() {
    difference() {
        cylinder(h = insert_lip_height, d = diameter, $fn=100);
        translate([0,0,-0.01])
            cylinder(h = insert_lip_height + 0.02, d = insert_lip_diameter-3*wall_thickness, $fn=100);
    }
}
// Module for solid top cap with dynamic diameter
module top_cap() {
    top_diameter = (folds % 2 == 0) ?  diameter : diameter - wave_depth ;
    cylinder(h = 3*wall_thickness, d = top_diameter, $fn=100);
}

// Final assembly
module purge_bellow() {
    // Insert lip for press-fit
    insert_lip();

    // Accordion body
    translate([0,0,insert_lip_height])
       accordion();

    // Top lip for cap
    translate([0,0,insert_lip_height + total_height_accordion])
        top_lip();
}

// Render the bellow
translate([0,0,total_height])
    rotate(a = [0, 180, 0])
        purge_bellow();
