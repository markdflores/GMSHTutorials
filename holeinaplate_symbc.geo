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
W = 2*25.4;	// mm 		
L = 2*25.4; 	// mm		
T = 3;		// mm	
nply = 1; 	// integer		
tply = T/nply; 	// mm
R = 6.35/2; 	// mm			
// - - - - - - - - - - - - - - - - - - - - - 
// Unstructured Mesh in XY
// - - - - - - - - - - - - - - - - - - - - - 
lc_S = 2; 		// element size for composite (outer edges)
lc_R = lc_S/2; 		// element size for hole 
// - - - - - - - - - - - - - - - - - - - - - 
// How many elements do you want for each ply
// - - - - - - - - - - - - - - - - - - - - - 
nep = 1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - 
// Mesh Refinement - Scroll Down
// - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - 
// Start of Code - Edit at Your Own Risk
// - - - - - - - - - - - - - - - - - - - - - 
s = Sqrt(2)/2;
// - - - - - - - - - - - - - - - - - - - - - 
// Hole in a Plate with symmetric boundary conditions
// - - - - - - - - - - - - - - - - - - - - - 
x = W/2; y = L/2; z = T/2; lc = lc_S;
p01=newp; Point(p01) = { x, 0, z, lc}; 
p02=newp; Point(p02) = { x, y, z, lc}; 
p03=newp; Point(p03) = { 0, y, z, lc};
x = R*s; y = R*s; lc = lc_R;
p04=newp; Point(p04) = { 0, 0, z, lc};	
p05=newp; Point(p05) = { R, 0, z, lc}; 
p06=newp; Point(p06) = { x, y, z, lc}; 
p07=newp; Point(p07) = { 0, R, z, lc}; 
// - - - - - - - - - - - - - - - - - - - - - 
// Create Lines
// - - - - - - - - - - - - - - - - - - - - - 
l01=newl;  Line(l01) = {p01,p02}; 
l02=newl;  Line(l02) = {p02,p03}; 
l03=newl;Circle(l03) = {p05,p04,p06}; 
l04=newl;Circle(l04) = {p06,p04,p07}; 
l05=newl;  Line(l05) = {p05,p01};
l06=newl;  Line(l06) = {p03,p07};
// - - - - - - - - - - - - - - - - - - - - - 
// Create Plane Surface
// - - - - - - - - - - - - - - - - - - - - - 
ll01=newll; Line Loop(ll01) = {l01,l02,l06,-l03,-l04,l05};
s01=news; Plane Surface(s01) = {ll01};
// - - - - - - - - - - - - - - - - - - - - - 
// Create Volume/s
// - - - - - - - - - - - - - - - - - - - - - 
For i In {0:(nply-1)} 	// Start of Composite
  If (i==0)
  numv[]=Extrude {0,0,-tply} { Surface{s01}; Layers{nep}; Recombine;};
  numsf[]={s01};		// For Boundary Conditions Front
  numsb[]={numv[0]};		// For Boundary Conditions Back
  Else
  numv[]=Extrude {0,0,-tply} {Surface{numv[0]}; Layers{nep}; Recombine;};
  numsf[]={numsb[]};		// For Boundary Conditions Front
  numsb[]={numv[0]};		// For Boundary Conditions Back  
  EndIf
  // - - - - - - - - - - - - - - - - - - - - - - -
  // Boundary Conditions for Each Ply
  // - - - - - - - - - - - - - - - - - - - - - - -
  //Printf( " %g   " , numv[2]);
  v01[{i}]=newv; Physical Volume(v01[i])=numv[]; 
  bnd[]={numsf}; front[{i}]  =newreg; Physical Surface(front[i])=bnd[]; 
  bnd[]={numsb};  back[{i}]  =newreg; Physical Surface(back[i])=bnd[]; 
  bnd[]={numv[3]}; top[{i}]  =newreg; Physical Surface(top[i])=bnd[]; 
  bnd[]={numv[7]}; bot[{i}]  =newreg; Physical Surface(bot[i])=bnd[]; 
  bnd[]={numv[4]}; left[{i}] =newreg; Physical Surface(left[i])=bnd[]; 
  bnd[]={numv[2]}; right[{i}]=newreg; Physical Surface(right[i])=bnd[];
  bnd[]={numv[5]:numv[6]}; hole[{i}]=newreg; Physical Surface(hole[i])=bnd[]; 
EndFor 			// End of Composite
// - - - - - - - - - - - - - - - - - - - - - 
// Mesh Refinement - Scroll Down
// - - - - - - - - - - - - - - - - - - - - - 
mesh_refine_x = 12.7; 	// X-Coordinate for box
mesh_refine_y = 12.7; 	// Y-Coordinate for box
mesh_refine_lc = 8; 	// How much you want to reduce mesh size. lc_S/mesh_refine_lc
mesh_refine_R = R*4; 	// Radius of mesh refinement. ( >= D Diameter) 
x_D = 0.0;		// Center of Box/Cylinder in X
y_D = 0.0;		// Center of Box/Cylinder in X
Field[1] = Box; 
Field[1].VIn = lc_S/mesh_refine_lc;  
Field[1].VOut= lc_S; 
Field[1].XMax = mesh_refine_x+x_D; 
Field[1].XMin =-mesh_refine_x+x_D; 
Field[1].YMax = mesh_refine_y+y_D; 
Field[1].YMin =-mesh_refine_y+y_D; 
Field[1].ZMax = 100; 
Field[1].ZMin =-100; 
Field[2] = Cylinder; 
Field[2].Radius = mesh_refine_R;
Field[2].VIn 	= lc_S/mesh_refine_lc;  
Field[2].VOut	= lc_S; 
Field[2].XAxis 	= 0; 
Field[2].XCenter= x_D; 
Field[2].YAxis 	= 0;
Field[2].YCenter= y_D; 
Field[2].ZAxis 	= 100; 
Field[2].ZCenter= 0; 

Background Field = 2; 

Recombine Surface "*";


 


