/* 
Author: Mark Flores
Purpose: Create a gmsh .geo file that scripts a composite
laminate (flat plate) given a width, length, and thickness.

Inputs: 
W	- Width
L	- Length
T	- Thickness
nply	- Number of Plies/Lamina
tply	- Thickness of a Single Ply/Lamina

Mesh: 
lc_# 	- Characteristic Length of Edge/Point

*/

// - - - - - - - - - - - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - - - - - - - - - - - -
W = 10; 		// mm 25.4mm/1”
L = 10; 		// mm
T = 10; 		// mm
nply =10; 		// integer
tply = T/nply; 		// mm
// - - - - - - - - - - - - - - - - - - - - - - -
// Do you want an Unstructured Mesh in xy
// - - - - - - - - - - - - - - - - - - - - - - - 
lc_S = 1; 		// element size = 1 (xy)
// - - - - - - - - - - - - - - - - - - - - - - -
// Do you want a Structured Mesh in xy? 
// - - - - - - - - - - - - - - - - - - - - - - -
struct=0; 	// 1) Yes 2) No
nnX = 11; 	// Number of Nodes in X 
nnY = 11; 	// Number of Nodes in Y
// - - - - - - - - - - - - - - - - - - - - - - -
// How many elements do you want for each ply
// - - - - - - - - - - - - - - - - - - - - - - - 
nep = 1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - - -
// To Perform Mesh Refinement, Scroll down
// - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
x=W/2; y=L/2; z=T/2; lc=lc_S;
p01 = newp; Point(p01) = { x, y, z, lc};	// Cartesian Quadrant I
p02 = newp; Point(p02) = {-x, y, z, lc};	// Cartesian Quadrant II	
p03 = newp; Point(p03) = {-x,-y, z, lc};	// Cartesian Quadrant III	
p04 = newp; Point(p04) = { x,-y, z, lc};	// Cartesian Quadrant IV	
l01 = newl;  Line(l01) = {p01,p02};
l02 = newl;  Line(l02) = {p02,p03};
l03 = newl;  Line(l03) = {p03,p04};
l04 = newl;  Line(l04) = {p04,p01};
ll01=newll; Line Loop(ll01) = {l01:l04}; 
s01=news; Plane Surface(s01) = {ll01};
For i In {0:(nply-1)}
  If (i==0)
  numv[]=Extrude {0,0,-tply} {Surface{s01}; Layers{nep}; Recombine;};
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
  v01[{i}] = newv; Physical Volume(v01[i])=numv[]; 
  bnd[]={numsf}; front[{i}]  =newreg; Physical Surface(front[i])=bnd[]; 
  bnd[]={numsb};  back[{i}]  =newreg; Physical Surface(back[i])=bnd[]; 
  bnd[]={numv[2]}; top[{i}]  =newreg; Physical Surface(top[i])=bnd[]; 
  bnd[]={numv[4]}; bot[{i}]  =newreg; Physical Surface(bot[i])=bnd[]; 
  bnd[]={numv[3]}; left[{i}] =newreg; Physical Surface(left[i])=bnd[]; 
  bnd[]={numv[5]}; right[{i}]=newreg; Physical Surface(right[i])=bnd[]; 
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Structured Mesh
// - - - - - - - - - - - - - - - - - - - - - - -
If (struct==1)
Transfinite Line {l01, l03} = nnX;
Transfinite Line {l02, l04} = nnY;
Transfinite Surface {s01}; 
EndIf

// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement - Box 
// - - - - - - - - - - - - - - - - - - - - - - -
mesh_reduce = 2; 	// Reduce
xc = 0.0;		// Center of Box w/Respect to X 
yc = 0.0;  		// Center of Box w/Respect to Y
zc = 0.0; 		// Center of Box w/Respect to Z
xL = 1.5; 		// Length w/Respect to X
yL = 1.5;		// Length w/Respect to Y
zL = T*10; 		// Length w/Respect to Z	
Field[1] = Box; 
Field[1].VIn  = lc_S/mesh_reduce; 
Field[1].VOut = lc_S; 
Field[1].XMax = xc + xL; 
Field[1].XMin = xc - xL;  
Field[1].YMax = yc + yL; 
Field[1].YMin = yc - yL; 
Field[1].ZMax = zc + zL; 
Field[1].ZMin = zc - zL; 
// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement - Cylinder (Circle Only - No Ellipses)
// - - - - - - - - - - - - - - - - - - - - - - -
mesh_reduce = 10; 	// Reduce
mesh_radius = 2; 	// Radius of Cylinder
xc = 0.0;		// Center of Cylinder w/Respect to X 
yc = 0.0;  		// Center of Cylinder w/Respect to Y
zc = 0.0; 		// Center of Cylinder w/Respect to Z
xL = 0.0; 		// Length w/Respect to X (0.0 for Z Only)
yL = 0.0;		// Length w/Respect to Y (0.0 for Z Only)
zL = T*10; 		// Length w/Respect to Z
Field[2] = Cylinder; 
Field[2].Radius = mesh_radius;
Field[2].VIn 	= lc_S/mesh_reduce;  
Field[2].VOut	= lc_S; 
Field[2].XAxis 	= xL; 
Field[2].XCenter= xc; 
Field[2].YAxis 	= yL;
Field[2].YCenter= yc; 
Field[2].ZAxis 	= zL; 
Field[2].ZCenter= zc;

Background Field = 2; // 0) No Mesh Refinement 1) Box 2) Cylinder 

Recombine Surface "*";














