/* [Box Paremeters] */
CardThickness = 0.8; // [0.8:Dragon Shields Double Sleeved, 0.75:Ultra Pro Eclipse Double Sleeved, 0.75:Ultra Pro Eclipse Single Sleeved, 0.73:Ultimate Guard Katana Double Sleeved, 0.65:Ultimate Guard Supreme Single Sleeved ]
SectionExtraSpace = 0.4;
SectionSizes = [15, 15, 15];
Tab = 1; // [-1:Down, 1:Up]

/* [Cutouts] */
vertical_ratios = [1,1.5,1]; // [1:0.5:5]
horizontal_ratios = [1,1,1]; // [1:0.5:5]

side_cut_depth = 6; // [2:10]
angle = 60;

top_cut_depth = 10; //

//top_chamfer = 15;

//top_indent_width = 20;
//top_indent_height = 45;
//top_indent_side =  32;

/* [Hidden] */
function add(v) = [for(p=v) 1]*v;
function select(vector, indices) = [ for (index = indices) vector[index] ];

box_width = 69.5;
box_height = 70;
wall_thickness = 0.8;

module box_wall(horizontal_ratios = horizontal_ratios, vertical_ratios = vertical_ratios, side_cut_depth = side_cut_depth, top_cut_depth = top_cut_depth, h = box_height, w = box_width, Tab = Tab){
  //Calculation helpers
  horizontal_ratios_sum = add(horizontal_ratios);
  vertical_ratios_sum = add(vertical_ratios);

  hi = vertical_ratios * h / vertical_ratios_sum;
  h1 = hi[0];
  h2 = hi[1]; 
  h3 = hi[2];
  //echo(hi);

  wi = horizontal_ratios * w / horizontal_ratios_sum;
  w1 = wi[0]; 
  w2 = wi[1];
  w3 = wi[2];
  //echo(wi);
  
  // Wall points 
  bottom_left_corner = [0,0];
  left_cut_bottom_entrance = [0,h1];
  left_cut_bottom_entrance_flat = [wall_thickness, h1];
  left_cut_bottom_end = [side_cut_depth, h1+side_cut_depth*tan(angle)];
  left_cut_top_end = [side_cut_depth, h1+h2-side_cut_depth*tan(angle)];
  left_cut_top_entrance_flat = [wall_thickness, h1+h2];
  left_cut_top_entrance = [0, h1+h2];
  top_left_corner = [0, h];
  top_cut_left_entrance = [w1, h];
  top_cut_left_bottom = [w1*1.15, h+(Tab)*top_cut_depth];
  top_cut_center_bottom = [w/2, h+(Tab)*top_cut_depth*1.25];
  top_cut_right_bottom = [w1*0.85+w2, h+(Tab)*top_cut_depth];
  top_cut_right_entrance = [w1+w2, h];
  top_right_corner = [w, h];
  right_cut_top_entrance = [w, h1+h2];
  right_cut_top_entrance_flat = [w-wall_thickness, h1+h2];
  right_cut_top_end = [w-side_cut_depth, h1+h2-side_cut_depth*tan(angle)];
  right_cut_bottom_end = [w-side_cut_depth, h1+side_cut_depth*tan(angle)];
  right_cut_bottom_entrance_flat = [w-wall_thickness, h1];
  right_cut_bottom_entrance = [w, h1];
  bottom_right_corner = [w, 0];
  
  points = [
      bottom_left_corner,
      left_cut_bottom_entrance,
      left_cut_bottom_entrance_flat,
      left_cut_bottom_end,
      left_cut_top_end,
      left_cut_top_entrance_flat,
      left_cut_top_entrance,
      top_left_corner,
      top_cut_left_entrance,
      top_cut_left_bottom,
      top_cut_center_bottom,
      top_cut_right_bottom,
      top_cut_right_entrance,
      top_right_corner,
      right_cut_top_entrance,
      right_cut_top_entrance_flat,
      right_cut_top_end,
      right_cut_bottom_end,
      right_cut_bottom_entrance_flat,
      right_cut_bottom_entrance,
      bottom_right_corner 
  ];

  rotate([90,0,0])
  linear_extrude(height=wall_thickness, center=true)
    translate([-w/2, 0, -h/2])
      polygon(points=points);
}

radius = 20;
angles = [45, 135];
fn = 12;

module sector(radius, angles, fn = 24) {
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [radius * cos(a), radius * sin(a)]
        ],
        [[radius * cos(angles[1]), radius * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        #polygon(points);
    }
}

box_depth = add(SectionSizes)*CardThickness + len(SectionSizes) * (SectionExtraSpace + wall_thickness);

box_wall(Tab = -1);
for( i = [0:len(SectionSizes)-2] ) {
  mid_wall_depth = add(select(SectionSizes,[0:i])) * CardThickness + (i+1) * (SectionExtraSpace+wall_thickness);
  #translate([0,mid_wall_depth,0]) box_wall(side_cut_depth = 0);
}
translate([0,box_depth,0]) box_wall(Tab=-1);

// Side walls
external_box_depth = box_depth+wall_thickness;
translate([-box_width/2+wall_thickness/2, box_depth/2, 0]) rotate([0,0,90]) box_wall(horizontal_ratios = [1,0,1] , top_cut_depth= 0, w = external_box_depth);
translate([box_width/2-wall_thickness/2, box_depth/2, 0]) rotate([0,0,90]) box_wall(horizontal_ratios = [1,0,1], top_cut_depth= 0, w = external_box_depth);

// Bottom
translate([-box_width/2,-wall_thickness/2,0]) cube([box_width, external_box_depth, wall_thickness]);
