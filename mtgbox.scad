/* [Box Paremeters] */
Card_thickness = 0.8; // [0.8:Dragon Shields Double Sleeved, 0.75:Ultra Pro Eclipse Double Sleeved, 0.75:Ultra Pro Eclipse Single Sleeved, 0.73:Ultimate Guard Katana Double Sleeved, 0.65:Ultimate Guard Supreme Single Sleeved ]

// Defined in number of cards. Modify this vector in the file to add more sections
Section_sizes = [15, 15, 15]; 
Section_extra_space = 0.4;

Mid_wall_style = 1; // [-1:Cutout, 1:Tab]

/* [Top (Cutout / Tab)]  */

Vertical_ratios = [2.5,2.5,1.5]; // [1:0.5:5]
Top_cut_depth = 5; // [3:1:10]

/* [Side Cutouts] */
Horizontal_ratios = [1,3.5,1]; // [1:0.5:5]

Side_cut_depth = 5; // [2:10]
Side_cut_angle = 60;

/* [Hidden] */
function add(v) = [for(p=v) 1]*v;
function select(vector, indices) = [ for (index = indices) vector[index] ];

box_width = 69.5;
box_height = 70;
wall_thickness = 0.8;

module box_wall(horizontal_ratios = Horizontal_ratios, vertical_ratios = Vertical_ratios, side_cut_depth = Side_cut_depth, Top_cut_depth = Top_cut_depth, h = box_height, w = box_width, Tab = Mid_wall_style){
  //Calculation helpers
  horizontal_ratios_sum = add(horizontal_ratios);
  vertical_ratios_sum = add(vertical_ratios);

  hi = vertical_ratios * h / vertical_ratios_sum;
  h1 = hi[0];
  h2 = hi[1]; 
  h3 = hi[2];

  wi = horizontal_ratios * w / horizontal_ratios_sum;
  w1 = wi[0]; 
  w2 = wi[1];
  w3 = wi[2];
  
  curve_radius = Top_cut_depth;

  // Wall points 
  bottom_left_corner = [0,0];
  
  left_cut_bottom_entrance = [0,h1];
  left_cut_bottom_entrance_flat = [wall_thickness, h1];
  left_cut_bottom_end = [side_cut_depth, h1+side_cut_depth*tan(Side_cut_angle)];
  left_cut_top_end = [side_cut_depth, h1+h2-side_cut_depth*tan(Side_cut_angle)];
  left_cut_top_entrance_flat = [wall_thickness, h1+h2];
  left_cut_top_entrance = [0, h1+h2];

  top_left_corner = [0, h];
  
  top_cut_left_entrance = [w1+curve_radius, h];
  top_cut_left_bottom = [w1+curve_radius, h+(Tab)*Top_cut_depth];
  top_cut_right_bottom = [w1+w2-curve_radius, h+(Tab)*Top_cut_depth];
  top_cut_right_entrance = [w1+w2-curve_radius, h];
  
  top_right_corner = [w, h];

  right_cut_top_entrance = [w, h1+h2];
  right_cut_top_entrance_flat = [w-wall_thickness, h1+h2];
  right_cut_top_end = [w-side_cut_depth, h1+h2-side_cut_depth*tan(Side_cut_angle)];
  right_cut_bottom_end = [w-side_cut_depth, h1+side_cut_depth*tan(Side_cut_angle)];
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
      
  if(Tab == 1){
    rotate([90,0,0])
    linear_extrude(height=wall_thickness, center=true)
    translate([-w/2, 0, -h/2])
    union() {
      polygon(points=points);
      translate(top_cut_left_entrance) circle(r = curve_radius);
      translate(top_cut_right_entrance) circle(r = curve_radius);
    }
  }

  if(Tab == -1){
    rotate([90,0,0])
    linear_extrude(height=wall_thickness, center=true)
    translate([-w/2, 0, -h/2])
    difference() {
      polygon(points=points);
      translate(top_cut_left_entrance) circle(r = curve_radius);
      translate(top_cut_right_entrance) circle(r = curve_radius);
    }
  }
}

box_depth = add(Section_sizes)*Card_thickness + len(Section_sizes) * (Section_extra_space + wall_thickness);

box_wall(Tab = -1);
for( i = [0:len(Section_sizes)-2] ) {
  mid_wall_depth = add(select(Section_sizes,[0:i])) * Card_thickness + (i+1) * (Section_extra_space+wall_thickness);
  #translate([0,mid_wall_depth,0]) box_wall(side_cut_depth = 0);
}
translate([0,box_depth,0]) box_wall(Tab=-1);

// Side walls
external_box_depth = box_depth+wall_thickness;
translate([-box_width/2+wall_thickness/2, box_depth/2, 0]) rotate([0,0,90]) box_wall(horizontal_ratios = [1,0,1] , Top_cut_depth= 0, w = external_box_depth);
translate([box_width/2-wall_thickness/2, box_depth/2, 0]) rotate([0,0,90]) box_wall(horizontal_ratios = [1,0,1], Top_cut_depth= 0, w = external_box_depth);

// Bottom
translate([-box_width/2,-wall_thickness/2,0]) cube([box_width, external_box_depth, wall_thickness]);
