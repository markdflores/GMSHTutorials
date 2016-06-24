/* 
Author: Mark Flores
Purpose: Create a gmsh .geo file that scripts a composite
laminate (flat plate) given a width, length, and thickness.

Also add a dimple given a radius and depth. This .geo file 
uses the compound surface feature to combine surfaces and then
extrudes the surface to create a solid. 

Problems: 
1) Sometimes it creates prism elements instead of hexahedral elements. 
2) Each compound surface has a unique mesh. 
3) No periodic boundary conditions for the surface. 

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
W = 20; 		// mm
L = 20; 		// mm
T = 4; 		// mm
nply =2; 		// integer
tply = T/nply; 	// mm 
R1 = 5; 
d = 0.5;
R2 = (R1^2+d^2)/(2*d);  
lc_S = 0.25; 		// element size = 1 (xy)
nep =1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
s=Sqrt(2)/2; 
For i In {0:(nply-1)}
  x=W/2; y=L/2; z=T/2-tply*i; lc=lc_S;
  p01[{i}]=newp; Point(p01[i]) = { x, y, z, lc};
  p02[{i}]=newp; Point(p02[i]) = {-x, y, z, lc};	
  p03[{i}]=newp; Point(p03[i]) = {-x,-y, z, lc};	
  p04[{i}]=newp; Point(p04[i]) = { x,-y, z, lc};	
  l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]};
  l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]};
  l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]};
  l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]};
  ll01[{i}]=newll; Line Loop(ll01[i]) = {l01[i],l02[i],l03[i],l04[i]}; 
  //s01[{i}]=news; Ruled Surface(s01[i]) = {ll01[i]};
 
  // - - - - Dimple Addition - - - - 
  x=0; y=0;
  p10[{i}]=newp; Point(p10[i]) = { x, y, z, lc};
  x=0; y=0; z=T/2+R2-d-tply*i;
  p11[{i}]=newp; Point(p11[i]) = { x, y, z, lc};
  x=0; y=0; z=T/2-d-tply*i;  
  p12[{i}]=newp; Point(p12[i]) = {-x, y, z, lc};
  x=R1*s; y=R1*s; z=T/2-tply*i; lc=lc_S;
  p15[{i}]=newp; Point(p15[i]) = { x, y, z, lc};
  p16[{i}]=newp; Point(p16[i]) = {-x, y, z, lc};	
  p17[{i}]=newp; Point(p17[i]) = {-x,-y, z, lc};	
  p18[{i}]=newp; Point(p18[i]) = { x,-y, z, lc};
  l11[{i}]=newl;Circle(l11[i]) = {p15[i],p10[i],p16[i]};
  l12[{i}]=newl;Circle(l12[i]) = {p16[i],p10[i],p17[i]};
  l13[{i}]=newl;Circle(l13[i]) = {p17[i],p10[i],p18[i]};
  l14[{i}]=newl;Circle(l14[i]) = {p18[i],p10[i],p15[i]};
  l15[{i}]=newl;Circle(l15[i]) = {p15[i],p11[i],p12[i]};
  l16[{i}]=newl;Circle(l16[i]) = {p16[i],p11[i],p12[i]};
  l17[{i}]=newl;Circle(l17[i]) = {p17[i],p11[i],p12[i]};
  l18[{i}]=newl;Circle(l18[i]) = {p18[i],p11[i],p12[i]};
  ll11[{i}]=newll; Line Loop(ll11[i]) = {l11[i],-l15[i],l16[i]};
  ll12[{i}]=newll; Line Loop(ll12[i]) = {l12[i],-l16[i],l17[i]};
  ll13[{i}]=newll; Line Loop(ll13[i]) = {l13[i],-l17[i],l18[i]};
  ll14[{i}]=newll; Line Loop(ll14[i]) = {l14[i],-l18[i],l15[i]};
  ll15[{i}]=newll; Line Loop(ll15[i]) = {l11[i],l12[i],l13[i],l14[i]}; 

  s01[{i}]=news; Ruled Surface(s01[i]) = {ll01[i],ll15[i]};
  s11[{i}]=news; Ruled Surface(s11[i]) = {ll11[i]};
  s12[{i}]=news; Ruled Surface(s12[i]) = {ll12[i]};
  s13[{i}]=news; Ruled Surface(s13[i]) = {ll13[i]};
  s14[{i}]=news; Ruled Surface(s14[i]) = {ll14[i]};

  cs[{i}]=newreg; 
  //Compound Surface(cs[i]) = {s01[i], s11[i], s12[i], s13[i], s14[i]} 
	//Boundary {{l11[i],l12[i],l13[i],l14[i]},{l15[i],l16[i],l17[i],l18[i]}};
  Compound Surface(cs[i]) = {s01[i], s11[i], s12[i], s13[i], s14[i]};
  Extrude {0,0,-tply} {Surface{cs[i]}; Layers{nep}; Recombine;}


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
Field[1] = Box; 
Field[1].VIn = lc_S/2; 
Field[1].VOut= lc; 
Field[1].XMax= 6; 
Field[1].XMin=-6;  
Field[1].YMax= 6; 
Field[1].YMin=-6; 
Field[1].ZMax= 20; 
Field[1].ZMin=-20; 

Background Field = 1; // Field 1 or Field 0 - no mesh refinement

//Mesh.RemeshAlgorithm=1;

Recombine Surface "*";














