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
W = 10; 		// mm
L = 10; 		// mm
T = 10; 		// mm
nply =10; 		// integer
tply = T/nply; 	// mm 

lc_S = 1; 		// element size = 1 (xy)
nep =1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
x=W/2; y=L/2; z=T/2; lc=lc_S;
For i In {0:(nply-1)}
  p01[{i}]=newp; Point(p01[i]) = { x, y, z-tply*i, lc};
  p02[{i}]=newp; Point(p02[i]) = {-x, y, z-tply*i, lc};	
  p03[{i}]=newp; Point(p03[i]) = {-x,-y, z-tply*i, lc};	
  p04[{i}]=newp; Point(p04[i]) = { x,-y, z-tply*i, lc};	
  l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]};
  l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]};
  l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]};
  l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]};
  ll01[{i}]=newll; Line Loop(ll01[i]) = {l01[i],l02[i],l03[i],l04[i]}; 
  s01[{i}]=news; Plane Surface(s01[i]) = {ll01[i]};
  Extrude {0,0,-tply} {Surface{s01[i]}; Layers{nep}; Recombine;}
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Structured Mesh
// - - - - - - - - - - - - - - - - - - - - - - -
//Transfinite Line {l01, l03} = 21; 	// 20 elements
//Transfinite Line {l02, l04} = 25; 	// 24 elements
//Transfinite Surface {s01}; 

// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - - - - - - - - - - - -
//Field[1] = Box; 
//Field[1].VIn = lc_S/2; 
//Field[1].VOut= lc; 
//Field[1].XMax= 1.5; 
//Field[1].XMin=-1.5;  
//Field[1].YMax= 1.5; 
//Field[1].YMin=-1.5; 
//Field[1].ZMax= 20; 
//Field[1].ZMin=-20; 

//Background Field = 1; // Field 1 or Field 0 - no mesh refinement

Recombine Surface "*";














