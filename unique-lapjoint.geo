/*
Author: 
Mark Flores
Purpose: 
Create a gmsh .geo file that scripts a unique lapjoint. 
Inputs: 
W	- Width
L	- Length
T	- Thickness
R	- Radiu
nply	- Number of Plies
tply	- Lamina/Ply Thickness
Mesh: 
lc_# 	- Characteristic Length for Edges/Points
progr	- Bias in nodes if you like… 
*/

// - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - -
W = 25.4; 		// mm
L = 101.6; 		// mm
T = 4; 			// mm
R = 6.35; 		// mm
nply = 4; 		// integer
tply = T/nply; 		// mm
lc_W = 2; 		// characteristic length for width (element size = 0.5)
lc_R = lc_W/2; 
nep = 1; 	// Number of element per ply
t_W = 21; 	// transfinite Line Number of nodes
t_L = 11; 	// Transfinite Line Number of nodes

// - - - - - - - - - - - - -
// Start of Code - Edit at your own risk
// - - - - - - - - - - - - -
s=Sqrt(2)/2;
For i In {0:(nply-1)}
	x = R*s; y = R*s; z = T/2; lc = lc_R;
	angle_deg = 30; angle_rad = angle_deg*Pi/180;
	x1 = R*Sin(angle_rad); y1 = R*Cos(angle_rad);
	p00[{i}] = newp; Point(p00[i]) = { 0, 0, z-tply*i,lc};
	p01[{i}] = newp; Point(p01[i]) = { x1, y1, z-tply*i,lc};		
	p02[{i}] = newp; Point(p02[i]) = { x,-y, z-tply*i,lc};		
	p03[{i}] = newp; Point(p03[i]) = {-x,-y, z-tply*i,lc};		
	p04[{i}] = newp; Point(p04[i]) = {-x1, y1, z-tply*i,lc};		
	x = W/2; y = L/2; z = T/2; lc = lc_W;
	p05[{i}] = newp; Point(p05[i]) = { x, 3*R, z-tply*i,lc};		
	p06[{i}] = newp; Point(p06[i]) = { x, y,   z-tply*i,lc};		
	p07[{i}] = newp; Point(p07[i]) = {-x, y,   z-tply*i,lc};		
	p08[{i}] = newp; Point(p08[i]) = {-x, 3*R, z-tply*i,lc};
	l01[{i}] = newl;Circle(l01[i]) = {p01[i],p00[i],p02[i]};
	l02[{i}] = newl;Circle(l02[i]) = {p02[i],p00[i],p03[i]};
	l03[{i}] = newl;Circle(l03[i]) = {p03[i],p00[i],p04[i]};
	l04[{i}] = newl;  Line(l04[i]) = {p04[i],p08[i]};
	l05[{i}] = newl;  Line(l05[i]) = {p08[i],p07[i]};
	l06[{i}] = newl;  Line(l06[i]) = {p07[i],p06[i]};
	l07[{i}] = newl;  Line(l07[i]) = {p06[i],p05[i]};
	l08[{i}] = newl;  Line(l08[i]) = {p05[i],p01[i]};
	ll01[{i}] = newll; Line Loop(ll01[i]) = {l01[i]:l08[i]};
	s01[{i}] = news; Plane Surface(s01[i]) = {ll01[i]};
	Extrude {0,0,-tply} {Surface{s01[i]}; Layers{nep}; Recombine;} 
EndFor

For i In {0:(nply-1)}
	x = R*s; y = R*s; z = T/2; lc = lc_R;
	angle_deg = 30; angle_rad = angle_deg*Pi/180;
	x1 = R*Sin(angle_rad); y1 = R*Cos(angle_rad);
	p10[{i}] = newp; Point(p10[i]) = { 0, 0, z-tply*i,lc};
	p11[{i}] = newp; Point(p11[i]) = { x1, y1, z-tply*i,lc};		
	p12[{i}] = newp; Point(p12[i]) = { x,-y, z-tply*i,lc};		
	p13[{i}] = newp; Point(p13[i]) = {-x,-y, z-tply*i,lc};		
	p14[{i}] = newp; Point(p14[i]) = {-x1, y1, z-tply*i,lc};		
	x = W/2; y = L/2; z = T/2; lc = lc_W;
	p15[{i}] = newp; Point(p15[i]) = { x, 3*R, z-tply*i,lc};		
	p16[{i}] = newp; Point(p16[i]) = { x, -y,   z-tply*i,lc};		
	p17[{i}] = newp; Point(p17[i]) = {-x, -y,   z-tply*i,lc};		
	p18[{i}] = newp; Point(p18[i]) = {-x, 3*R, z-tply*i,lc};
	l11[{i}] = newl;Circle(l11[i]) = {p11[i],p10[i],p12[i]};
	l12[{i}] = newl;Circle(l12[i]) = {p12[i],p10[i],p13[i]};
	l13[{i}] = newl;Circle(l13[i]) = {p13[i],p10[i],p14[i]};
	l14[{i}] = newl;  Line(l14[i]) = {p14[i],p18[i]};
	l15[{i}] = newl;  Line(l15[i]) = {p18[i],p17[i]};
	l16[{i}] = newl;  Line(l16[i]) = {p17[i],p16[i]};
	l17[{i}] = newl;  Line(l17[i]) = {p16[i],p15[i]};
	l18[{i}] = newl;  Line(l18[i]) = {p15[i],p11[i]};
	ll11[{i}] = newll; Line Loop(ll11[i]) = {l11[i]:l18[i]};
	s11[{i}] = news; Plane Surface(s11[i]) = {ll11[i]};
	Extrude {0,0,-tply} {Surface{s11[i]}; Layers{nep}; Recombine;} 
EndFor

// Structured Mesh!!!! 
// Transfinite Line {l01,l03} = t_L;
// Transfinite Line {l02,l04} = t_W; 
// Transfinite Surface {s01};

// - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - -
Field[1] = Cylinder; 
Field[1].Radius = 25.4; 
Field[1].VIn 	= lc_R/2; 
Field[1].VOut 	= lc_W; 
Field[1].XAxis	= 0.0; 
Field[1].XCenter= 0.0; 
Field[1].YAxis	= 0.0; 
Field[1].YCenter= 0.0; 
Field[1].ZAxis	= 20.0; 
Field[1].ZCenter= 0.0; 

Background Field = 1; // Works well when you have multiple meshes. 

Recombine Surface "*";






