/* 
Author: Mark Flores
Purpose: Create a gmsh .geo file that scripts a composite
laminate (flat plate) given a width, length, and thickness. 
-With a Foam Core Inside a composite with equal thickness… 

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
W = 50; 		// mm
L = 50; 		// mm
T_c = 3; 		// mm composite
T_f = 6; 		// mm foam core
nply =3; 		// integer
tply = T_c/nply; 	// mm 

lc_S = 2; 		// element size = 1 (xy)
nep =1; 		// number of elements in z for each ply
nep_f=10;		// Number of elements in z for foam core
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
// Top 
x=W/2; y=L/2; z=T_f/2+T_c; lc=lc_S;
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

// Foam Core
p11=newp; Point(p11) = { x, y, z-tply*i, lc};
p12=newp; Point(p12) = {-x, y, z-tply*i, lc};	
p13=newp; Point(p13) = {-x,-y, z-tply*i, lc};	
p14=newp; Point(p14) = { x,-y, z-tply*i, lc};	
l11=newl;  Line(l11) = {p11,p12};
l12=newl;  Line(l12) = {p12,p13};
l13=newl;  Line(l13) = {p13,p14};
l14=newl;  Line(l14) = {p14,p11};
ll11=newll; Line Loop(ll11) = {l11,l12,l13,l14}; 
s11=news; Plane Surface(s11) = {ll11};
Extrude {0,0,-T_f} {Surface{s11}; Layers{nep_f}; Recombine;}

// Bottom Composite
x=W/2; y=L/2; z=-T_f/2; lc=lc_S;
For i In {0:(nply-1)}
  p21[{i}]=newp; Point(p21[i]) = { x, y, z-tply*i, lc};
  p22[{i}]=newp; Point(p22[i]) = {-x, y, z-tply*i, lc};	
  p23[{i}]=newp; Point(p23[i]) = {-x,-y, z-tply*i, lc};	
  p24[{i}]=newp; Point(p24[i]) = { x,-y, z-tply*i, lc};	
  l21[{i}]=newl;  Line(l21[i]) = {p21[i],p22[i]};
  l22[{i}]=newl;  Line(l22[i]) = {p22[i],p23[i]};
  l23[{i}]=newl;  Line(l23[i]) = {p23[i],p24[i]};
  l24[{i}]=newl;  Line(l24[i]) = {p24[i],p21[i]};
  ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]}; 
  s21[{i}]=news; Plane Surface(s21[i]) = {ll21[i]};
  Extrude {0,0,-tply} {Surface{s21[i]}; Layers{nep}; Recombine;}
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














