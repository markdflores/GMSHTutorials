/*
Author: Mark Flores
Purpose: Create a hole in a plate. Open Hole Compression..
Inputs:
W	- Width
L	- Length
T	- Thickness
D	- Diameter of Hole
nply	- Number of Plies
tply 	- Thickness of Plies
lc_# - Characteristic Length of inputs
*/

// - - - - - - - - - - - - - - - - - - - - - 
// Inputs
// - - - - - - - - - - - - - - - - - - - - - 

W = 3*25.4; 		// mm 	Hole in plate standards - 12*25.4
L = 3*25.4; 		// mm
T = 4;		// mm
nply = 4; 	// integer
tply = T/nply; 	// mm
D = 6.35; 		// mm		1/4” diameter
x_D = -5;		// X-Coordinate value for center of circle
y_D = 5;		// Y-Coordinate value for center of circle
lc_S = 2; 		// element size for square… 
nep = 1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - 
// Start of Code 
// - - - - - - - - - - - - - - - - - - - - - 
For i In {0:(nply-1)}
	s = Sqrt(2)/2;
	// Outer Rectangle
	x = W/2; y = L/2; z = T/2; lc = lc_S;
	p01[{i}]=newp; Point(p01[i]) = { x, y, z-tply*i, lc}; 
	p02[{i}]=newp; Point(p02[i]) = {-x, y, z-tply*i, lc}; 
	p03[{i}]=newp; Point(p03[i]) = {-x,-y, z-tply*i, lc}; 
	p04[{i}]=newp; Point(p04[i]) = { x,-y, z-tply*i, lc};
	l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]}; 
	l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]}; 
	l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]}; 
	l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]}; 
	ll01[{i}]=newll; Line Loop(ll01[i]) = {l01[i],l02[i],l03[i],l04[i]}; 
	// Hole In Plate!!
	x = D*s; y = D*s; z = T/2; lc = lc_S;
	p00[{i}]=newp; Point(p00[i]) = { 0-x_D,    0-y_D, 	z-tply*i, lc};	
	p11[{i}]=newp; Point(p11[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p12[{i}]=newp; Point(p12[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p13[{i}]=newp; Point(p13[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p14[{i}]=newp; Point(p14[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l11[{i}]=newl;Circle(l11[i]) = {p11[i],p00[i],p12[i]}; 
	l12[{i}]=newl;Circle(l12[i]) = {p12[i],p00[i],p13[i]}; 
	l13[{i}]=newl;Circle(l13[i]) = {p13[i],p00[i],p14[i]}; 
	l14[{i}]=newl;Circle(l14[i]) = {p14[i],p00[i],p11[i]}; 
	ll11[{i}]=newll; Line Loop(ll11[i]) = {l11[i],l12[i],l13[i],l14[i]}; 
	s01[{i}]=news; Plane Surface(s01[i]) = {ll01[i],ll11[i]};
	Extrude {0,0,-tply} { Surface{s01[i]}; Layers{nep}; Recombine;}
EndFor

tol=0.000;
For i In {0:(nply-1)}
	s = Sqrt(2)/2;
	// Outer Rectangle
	// Hole In Plate!!
	x = (D-tol)*s; y = (D-tol)*s; z = T/2; lc = lc_S;
	p20[{i}]=newp; Point(p20[i]) = { 0-x_D,    0-y_D, 	z-tply*i, lc};	
	p21[{i}]=newp; Point(p21[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p22[{i}]=newp; Point(p22[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p23[{i}]=newp; Point(p23[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p24[{i}]=newp; Point(p24[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l21[{i}]=newl;Circle(l21[i]) = {p21[i],p20[i],p22[i]}; 
	l22[{i}]=newl;Circle(l22[i]) = {p22[i],p20[i],p23[i]}; 
	l23[{i}]=newl;Circle(l23[i]) = {p23[i],p20[i],p24[i]}; 
	l24[{i}]=newl;Circle(l24[i]) = {p24[i],p20[i],p21[i]}; 
	ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]}; 
	s21[{i}]=news; Plane Surface(s21[i]) = {ll21[i],ll21[i]};
	Extrude {0,0,-tply} { Surface{s21[i]}; Layers{nep}; Recombine;}
EndFor

Field[1] = Box; 
Field[1].VIn = lc_S/4;  
Field[1].VOut= lc_S; 
Field[1].XMax = 12.7-x_D; 
Field[1].XMin =-12.7-x_D; 
Field[1].YMax = 12.7-y_D; 
Field[1].YMin =-12.7-y_D; 
Field[1].ZMax = 100; 
Field[1].ZMin =-100; 

Background Field = 1; 


Recombine Surface "*";


 




