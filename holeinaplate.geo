/*
Author: Mark Flores
Purpose: Create a hole in a plate with a given width, length,thickness, and hole diameter. 
The program allows you to insert
1) a singular hole anywhere in the boundary of the composite
	- given any x-,y-coordinate value inside composite
	- must be in the width and length dimensions specified
2) the singular hole with 
	- a laminate where out-of-plane direction aligns with composite
	- a solid 
Inputs:
W	- Width
L	- Length
T	- Thickness
D	- Diameter of Hole
nply	- Number of Plies
tply 	- Thickness of Plies
lc_# 	- Characteristic Length of inputs
tol	- tolerances to ensure 3-D outputs and/or discretization.
*/
// - - - - - - - - - - - - - - - - - - - - - 
// Inputs
// - - - - - - - - - - - - - - - - - - - - - 
W = 3*25.4; 		
L = 3*25.4; 			
T = 4;				
nply = 4; 			
tply = T/nply; 		
D = 6.35; 				
x_D = -10;		// X-Coordinate value for center of circle
y_D = 10;		// Y-Coordinate value for center of circle
// - - - - Mesh - - - -
lc_S = 2; 		// element size for composite (outer edges)
lc_R = lc_S/2; 		// element size for hole 
nep = 1; 		// number of elements in z for each ply
//
mesh_refine_type = 1;   // 1) box 2) cylinder
mesh_refine_x = 12.7; 	// X-Coordinate for box
mesh_refine_y = 12.7; 	// Y-Coordinate for box
mesh_refine_lc = 4; 	// How much you want to reduce mesh size. lc_S/mesh_refine_lc
mesh_refine_R = D*2; 	// Radius of mesh refinement. ( >= D Diameter) 
// - - - - - - - - - - - - - - - - - - - - - 
// Do you want to fill in the hole 
// - - - - - - - - - - - - - - - - - - - - - 
fih = 0; //1) yes 0) no
// - - - - - - - - - - - - - - - - - - - - - 
// Do you want to fill in the hole with something
// - - - - - - - - - - - - - - - - - - - - - 
fihws = 2; 	// 1) laminated composite 2) solid

// - - - - - - - - - - - - - - - - - - - - - 
// Start of Code - Edit at Your Own Risk
// - - - - - - - - - - - - - - - - - - - - - 
s = Sqrt(2)/2;
tol=0.00001; // tol gets rid of unknown surface problem.
T_X = tply-tol;
// 
// - - - - Hole in a Plate
//
For i In {0:(nply-1)} 	// Start of Composite
// Outer Rectangle
x = W/2; y = L/2; z = T/2-tply*i; lc = lc_S;
p01[{i}]=newp; Point(p01[i]) = { x, y, z, lc}; 
p02[{i}]=newp; Point(p02[i]) = {-x, y, z, lc}; 
p03[{i}]=newp; Point(p03[i]) = {-x,-y, z, lc}; 
p04[{i}]=newp; Point(p04[i]) = { x,-y, z, lc};
l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]}; 
l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]}; 
l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]}; 
l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]}; 
ll01[{i}]=newll; Line Loop(ll01[i]) = {l01[i],l02[i],l03[i],l04[i]}; 
// Hole In Plate!!
x = D*s/2; y = D*s/2; lc = lc_R;
p00[{i}]=newp; Point(p00[i]) = { 0+x_D, 0+y_D, 	z, lc};	
p11[{i}]=newp; Point(p11[i]) = { x+x_D, y+y_D, 	z, lc}; 
p12[{i}]=newp; Point(p12[i]) = {-x+x_D, y+y_D, 	z, lc}; 
p13[{i}]=newp; Point(p13[i]) = {-x+x_D,-y+y_D, 	z, lc}; 
p14[{i}]=newp; Point(p14[i]) = { x+x_D,-y+y_D, 	z, lc};
l11[{i}]=newl;Circle(l11[i]) = {p11[i],p00[i],p12[i]}; 
l12[{i}]=newl;Circle(l12[i]) = {p12[i],p00[i],p13[i]}; 
l13[{i}]=newl;Circle(l13[i]) = {p13[i],p00[i],p14[i]}; 
l14[{i}]=newl;Circle(l14[i]) = {p14[i],p00[i],p11[i]}; 
ll11[{i}]=newll; Line Loop(ll11[i]) = {l11[i],l12[i],l13[i],l14[i]}; 
s01[{i}]=news; Plane Surface(s01[i]) = {ll01[i],ll11[i]};
Extrude {0,0,-T_X} { Surface{s01[i]}; Layers{nep}; Recombine;}
EndFor			// End of Composite
//
// - - - - Fill in Hole in a Plate
//
If (fih == 1) 	// Fill in Hole?
//
If (fihws == 1) // Fill in hole with laminate
nply_fep=nply; 
nep_fep=1; 
tol1=0.001;
tol2=0.00001; 
T_X = tply-tol2;  
EndIf 		// Fill in hole with laminate
If (fihws == 2) // Fill in hole with solid
nply_fep=1; 
nep_fep=nply; 
tol1=0.001;
tol2=0.00001; 
T_X = T;
EndIf 		// Fill in hole with solid
//
For i In {0:(nply_fep-1)}	// Start of Filler (Hole Fill)
x = (D/2-tol1)*s; y = (D/2-tol1)*s; z = T/2-tply*i; lc = lc_R;
p20[{i}]=newp; Point(p20[i]) = { 0+x_D, 0+y_D, 	z, lc};	
p21[{i}]=newp; Point(p21[i]) = { x+x_D, y+y_D, 	z, lc}; 
p22[{i}]=newp; Point(p22[i]) = {-x+x_D, y+y_D, 	z, lc}; 
p23[{i}]=newp; Point(p23[i]) = {-x+x_D,-y+y_D, 	z, lc}; 
p24[{i}]=newp; Point(p24[i]) = { x+x_D,-y+y_D, 	z, lc};
l21[{i}]=newl;Circle(l21[i]) = {p21[i],p20[i],p22[i]}; 
l22[{i}]=newl;Circle(l22[i]) = {p22[i],p20[i],p23[i]}; 
l23[{i}]=newl;Circle(l23[i]) = {p23[i],p20[i],p24[i]}; 
l24[{i}]=newl;Circle(l24[i]) = {p24[i],p20[i],p21[i]}; 
ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]}; 
s21[{i}]=news; Plane Surface(s21[i]) = {ll21[i],ll21[i]};
Extrude {0,0,-T_X} { Surface{s21[i]}; Layers{nep_fep}; Recombine;}
EndFor				// End of Filler (Hole File)
EndIf		// Fill in Hole?

If (mesh_refine_type == 1)
Field[1] = Box; 
Field[1].VIn = lc_S/mesh_refine_lc;  
Field[1].VOut= lc_S; 
Field[1].XMax = mesh_refine_x+x_D; 
Field[1].XMin =-mesh_refine_x+x_D; 
Field[1].YMax = mesh_refine_y+y_D; 
Field[1].YMin =-mesh_refine_y+y_D; 
Field[1].ZMax = 100; 
Field[1].ZMin =-100; 
EndIf
If (mesh_refine_type == 2)
Field[1] = Cylinder; 
Field[1].Radius = mesh_refine_R;
Field[1].VIn 	= lc_S/mesh_refine_lc;  
Field[1].VOut	= lc_S; 
Field[1].XAxis 	= 0; 
Field[1].XCenter= x_D; 
Field[1].YAxis 	= 0;
Field[1].YCenter= y_D; 
Field[1].ZAxis 	= 100; 
Field[1].ZCenter= 0; 
EndIf

Background Field = 1; 

Recombine Surface "*";


 


