/* 
Author: Mark Flores
Purpose: Create a gmsh .geo file that scripts a composite
laminate (flat plate) given a width, length, and thickness.

Mode I Crack Propagation

Inputs: 
W	- Width
L	- Length
T	- Thickness
nply	- Number of Plies/Lamina
tply	- Thickness of a Single Ply/Lamina
angle 	- Angle of Notch Crack
C	- Crack Length

Mesh: 
lc_# 	- Characteristic Length of Edge/Point

*/

// - - - - - - - - - - - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - - - - - - - - - - - -
W = 5*25.4; 		// mm
L = 8*25.4; 		// mm
T = 6.35; 		// mm
W_crack = 0.25*25.4; 
L_crack = 2.217*25.4;
W_pins = 25.4; 
L_pins = 2.5*25.4; 
D_pins = 25.4;
angle_deg=60; 		// degrees 
nply = 1; 		// integer
tply = T/nply; 	// mm 

lc_S = 6; 		// element size = 1 (xy)
nep = 1; 		// number of elements in z for each ply

// - - - - - - - - - - - - - - - - - - - - - - -
// Would you like pin holes? 1) Yes 0) No
// - - - - - - - - - - - - - - - - - - - - - - -
pinh = 1; 
// - - - - - - - - - - - - - - - - - - - - - - -
// Would you like Pins? 1) Yes 0) No
// - - - - - - - - - - - - - - - - - - - - - - -
pins = 1; 
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
s=Sqrt(2)/2; 
angle_rad = angle_deg*Pi/180; 
// - - - - - - - - - - - -
// Composite Specimen
// - - - - - - - - - - - - 
For i In {0:(nply-1)}
x=W/2; y=L/2; z=T/2-tply*i; lc=lc_S;
p01[{i}]=newp; Point(p01[i]) = { x, y, z, lc};
p02[{i}]=newp; Point(p02[i]) = {-x, y, z, lc};	
p03[{i}]=newp; Point(p03[i]) = {-x,-y, z, lc};	
p04[{i}]=newp; Point(p04[i]) = { x,-y, z, lc};
x=W/2; y=W_crack/2; 
xd = L_crack-W_crack/Tan(angle_rad/2)/2; 
p11[{i}]=newp; Point(p11[i]) = { x, y, 	 z, lc};
p12[{i}]=newp; Point(p12[i]) = { x-xd, y, z, lc};	
p13[{i}]=newp; Point(p13[i]) = { x-xd,-y, z, lc};	
p14[{i}]=newp; Point(p14[i]) = { x,-y,	 z, lc};
x=W/2-L_crack; y=0; 
p21[{i}]=newp; Point(p21[i]) = { x, y, z, lc};
l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]};
l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]};
l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]};
l11[{i}]=newl;  Line(l11[i]) = {p04[i],p14[i]};
l12[{i}]=newl;  Line(l12[i]) = {p14[i],p13[i]};
l13[{i}]=newl;  Line(l13[i]) = {p13[i],p21[i]};
l14[{i}]=newl;  Line(l14[i]) = {p21[i],p12[i]};
l15[{i}]=newl;  Line(l15[i]) = {p12[i],p11[i]};
l16[{i}]=newl;  Line(l16[i]) = {p11[i],p01[i]};
// - - - - Combine Lines For Simplification
l1[]={l01[i]};
l2[]={l02[i]};
l3[]={l03[i]};
l4[]={l11[i]:l16[i]};
ll01[{i}]=newll; Line Loop(ll01[i])={l1[],l2[],l3[],l4[]};

// - - - - - - - - - - - -
// Do you want pin holes
// - - - - - - - - - - - - 
If (pinh == 1)
  x=W/2-W_pins; y=L_pins; 
  Rs=s*D_pins/2; 
  p30[{i}]=newp; Point(p30[i]) = { x, y, z, lc};
  p31[{i}]=newp; Point(p31[i]) = { x+Rs, y+Rs, z, lc};
  p32[{i}]=newp; Point(p32[i]) = { x-Rs, y+Rs, z, lc};	
  p33[{i}]=newp; Point(p33[i]) = { x-Rs, y-Rs, z, lc};	
  p34[{i}]=newp; Point(p34[i]) = { x+Rs, y-Rs, z, lc};
  p40[{i}]=newp; Point(p40[i]) = { x,-y, z, lc};
  p41[{i}]=newp; Point(p41[i]) = { x+Rs,-y+Rs, z, lc};
  p42[{i}]=newp; Point(p42[i]) = { x-Rs,-y+Rs, z, lc};	
  p43[{i}]=newp; Point(p43[i]) = { x-Rs,-y-Rs, z, lc};	
  p44[{i}]=newp; Point(p44[i]) = { x+Rs,-y-Rs, z, lc};
  l31[{i}]=newl;Circle(l31[i]) = {p31[i],p30[i],p32[i]};
  l32[{i}]=newl;Circle(l32[i]) = {p32[i],p30[i],p33[i]};
  l33[{i}]=newl;Circle(l33[i]) = {p33[i],p30[i],p34[i]};
  l34[{i}]=newl;Circle(l34[i]) = {p34[i],p30[i],p31[i]};
  l41[{i}]=newl;Circle(l41[i]) = {p41[i],p40[i],p42[i]};
  l42[{i}]=newl;Circle(l42[i]) = {p42[i],p40[i],p43[i]};
  l43[{i}]=newl;Circle(l43[i]) = {p43[i],p40[i],p44[i]};
  l44[{i}]=newl;Circle(l44[i]) = {p44[i],p40[i],p41[i]};
  ll02[{i}]=newll; Line Loop(ll02[i])={l31[],l32[],l33[],l34[]};
  ll03[{i}]=newll; Line Loop(ll03[i])={l41[],l42[],l43[],l44[]};
  s01[{i}]=news; Plane Surface(s01[i])={ll01[i],ll02[i],ll03[i]};
Else
  s01[{i}]=news; Plane Surface(s01[i])={ll01[i]};
EndIf
Extrude {0,0,-tply} {Surface{s01[i]}; Layers{nep}; Recombine;}
EndFor

// - - - - - - - - - - - -
// Do you want pins
// - - - - - - - - - - - - 
tol=0.001; 
If (pins == 1)
  x=W/2-W_pins; y=L_pins; z=T/2; lc=lc_S;
  Rs=s*D_pins/2-tol; 
  p50[{i}]=newp; Point(p50[i]) = { x, y, z, lc};
  p51[{i}]=newp; Point(p51[i]) = { x+Rs, y+Rs, z, lc};
  p52[{i}]=newp; Point(p52[i]) = { x-Rs, y+Rs, z, lc};	
  p53[{i}]=newp; Point(p53[i]) = { x-Rs, y-Rs, z, lc};	
  p54[{i}]=newp; Point(p54[i]) = { x+Rs, y-Rs, z, lc};
  p60[{i}]=newp; Point(p60[i]) = { x,-y, z, lc};
  p61[{i}]=newp; Point(p61[i]) = { x+Rs,-y+Rs, z, lc};
  p62[{i}]=newp; Point(p62[i]) = { x-Rs,-y+Rs, z, lc};	
  p63[{i}]=newp; Point(p63[i]) = { x-Rs,-y-Rs, z, lc};	
  p64[{i}]=newp; Point(p64[i]) = { x+Rs,-y-Rs, z, lc};
  Rs=s*D_pins/4; 
  p70[{i}]=newp; Point(p70[i]) = { x, y, z, lc};
  p71[{i}]=newp; Point(p71[i]) = { x+Rs, y+Rs, z, lc};
  p72[{i}]=newp; Point(p72[i]) = { x-Rs, y+Rs, z, lc};	
  p73[{i}]=newp; Point(p73[i]) = { x-Rs, y-Rs, z, lc};	
  p74[{i}]=newp; Point(p74[i]) = { x+Rs, y-Rs, z, lc};
  p80[{i}]=newp; Point(p80[i]) = { x,-y, z, lc};
  p81[{i}]=newp; Point(p81[i]) = { x+Rs,-y+Rs, z, lc};
  p82[{i}]=newp; Point(p82[i]) = { x-Rs,-y+Rs, z, lc};	
  p83[{i}]=newp; Point(p83[i]) = { x-Rs,-y-Rs, z, lc};	
  p84[{i}]=newp; Point(p84[i]) = { x+Rs,-y-Rs, z, lc};
  l51[{i}]=newl;Circle(l51[i]) = {p51[i],p50[i],p52[i]};
  l52[{i}]=newl;Circle(l52[i]) = {p52[i],p50[i],p53[i]};
  l53[{i}]=newl;Circle(l53[i]) = {p53[i],p50[i],p54[i]};
  l54[{i}]=newl;Circle(l54[i]) = {p54[i],p50[i],p51[i]};
  l61[{i}]=newl;Circle(l61[i]) = {p61[i],p60[i],p62[i]};
  l62[{i}]=newl;Circle(l62[i]) = {p62[i],p60[i],p63[i]};
  l63[{i}]=newl;Circle(l63[i]) = {p63[i],p60[i],p64[i]};
  l64[{i}]=newl;Circle(l64[i]) = {p64[i],p60[i],p61[i]};
  l71[{i}]=newl;Circle(l71[i]) = {p71[i],p70[i],p72[i]};
  l72[{i}]=newl;Circle(l72[i]) = {p72[i],p70[i],p73[i]};
  l73[{i}]=newl;Circle(l73[i]) = {p73[i],p70[i],p74[i]};
  l74[{i}]=newl;Circle(l74[i]) = {p74[i],p70[i],p71[i]};
  l81[{i}]=newl;Circle(l81[i]) = {p81[i],p80[i],p82[i]};
  l82[{i}]=newl;Circle(l82[i]) = {p82[i],p80[i],p83[i]};
  l83[{i}]=newl;Circle(l83[i]) = {p83[i],p80[i],p84[i]};
  l84[{i}]=newl;Circle(l84[i]) = {p84[i],p80[i],p81[i]};
  ll51[{i}]=newll; Line Loop(ll51[i]) = {l51[i],l52[i],l53[i],l54[i]};
  ll61[{i}]=newll; Line Loop(ll61[i]) = {l61[i],l62[i],l63[i],l64[i]};
  ll71[{i}]=newll; Line Loop(ll71[i]) = {l71[i],l72[i],l73[i],l74[i]};
  ll81[{i}]=newll; Line Loop(ll81[i]) = {l81[i],l82[i],l83[i],l84[i]};
  s51[{i}]=news; Plane Surface(s51[i]) = {ll51[i],ll71[i]};
  s61[{i}]=news; Plane Surface(s61[i]) = {ll61[i],ll81[i]};
  Extrude {0,0,-tply} {Surface{s51[i],s61[i]}; Layers{nep}; Recombine;}
EndIf

// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - - - - - - - - - - - -
mesh_refine_crack = lc_S/8; 
mesh_refine_crackradius = 25.4; 
x_C = W/2-L_crack-W_crack*2; 
y_C = 0; 
z_C = 0; 
Field[1] = Cylinder; 
Field[1].Radius = mesh_refine_crackradius;
Field[1].VIn 	= mesh_refine_crack;  
Field[1].VOut	= lc_S; 
Field[1].XAxis 	= 0; 
Field[1].XCenter= x_C; 
Field[1].YAxis 	= 0;
Field[1].YCenter= y_C; 
Field[1].ZAxis 	= 100; 
Field[1].ZCenter= 0;
// - - - - Mesh for pin holes - - - - 
mesh_refine_hole  = lc_S/4; 
mesh_refine_holeradius = 19.05;
x_D = W/2-W_pins; 
y_D = L_pins;
For j In {2:3} 
If (j == 2)
unit = 1; 
Else
unit =-1; 
EndIf
Field[j] = Cylinder; 
Field[j].Radius = mesh_refine_holeradius;
Field[j].VIn 	= mesh_refine_hole;  
Field[j].VOut	= lc_S; 
Field[j].XAxis 	= 0; 
Field[j].XCenter= x_D; 
Field[j].YAxis 	= 0;
Field[j].YCenter= y_D*unit; 
Field[j].ZAxis 	= 100; 
Field[j].ZCenter= 0;
EndFor
// - - - - Mesh for Sensor? - - - -
mesh_refine_sensor = lc_S; 
ac_radius = 12.7; 
x_S = W/2-L_crack-ac_radius*s; 
y_S = ac_radius*s;
S_W = 10; 
S_L = 10; 
Field[4] = Box; 
Field[4].VIn = mesh_refine_sensor; 
Field[4].VOut= lc_S; 
Field[4].XMax= x_S+S_W/2; 
Field[4].XMin= x_S-S_W/2;  
Field[4].YMax= -y_S+S_L/2; 
Field[4].YMin= -y_S-S_L/2; 
Field[4].ZMax= 20; 
Field[4].ZMin=-20;
 
Field[100] = Min; 
Field[100].FieldsList = {1,2,3,4};

Background Field = 100; // Field 1 or Field 0 - no mesh refinement

Recombine Surface "*";














