/*
Author: Mark Flores
Purpose: 
The purpose of this .geo file is to script a bolted double lapjoint. 

Inputs:
W	- Width
L	- Length
T	- Thickness
a	- gauge width 
b	- gauge length
D	- Diameter of Hole
nply	- Number of Plies
tply 	- Thickness of Plies
lc_# - Characteristic Length of inputs

*/

// - - - - - - - - - - - - - - - - - - - - - 
// Inputs
// - - - - - - - - - - - - - - - - - - - - - 
W = 25.4; 		
L = 101.6; 		
T = 4;			
nply = 4; 		
tply = T/nply; 		
D = 6.35; 		
x_D = 0;		
y_D = 0;		
a = W; 			
b = a; 			
lc_S = 2; 		
nep = 1; 
// - - - - - - - - - - - - - - - - - - - - - 
// Start of Code 
// - - - - - - - - - - - - - - - - - - - - - 
// - - - - Upper Plate - - - -
For i In {0:(nply-1)}
	sf = Sqrt(2)/2;
	// Outer Rectangle
	x = W/2; y = L; z = T/2; lc = lc_S;
	x1 = a/2; y1 = b/2; 
	p01[{i}]=newp; Point(p01[i]) = { x, y-y1, z-tply*i, lc}; 
	p02[{i}]=newp; Point(p02[i]) = {-x, y-y1, z-tply*i, lc}; 
	p03[{i}]=newp; Point(p03[i]) = {-x,-y1, z-tply*i, lc}; 
	p04[{i}]=newp; Point(p04[i]) = { x,-y1, z-tply*i, lc};
	l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]}; 
	l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]}; 
	l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]}; 
	l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]}; 
	ll01[{i}]=newll; Line Loop(ll01[i]) = {l01[i],l02[i],l03[i],l04[i]}; 
	// Hole In Plate!!
	x = D*sf/2; y = D*sf/2; z = T/2; lc = lc_S;
	p00[{i}]=newp; Point(p00[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
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

// - - - - Upper Plate - - - -
tol = 0.001; 	// Tolerance between plates
For i In {0:(nply-1)}
	sf = Sqrt(2)/2;
	// Outer Rectangle
	x = W/2; y = L; z = T/2+T+tol; lc = lc_S;
	x1 = a/2; y1 = b/2; 
	p21[{i}]=newp; Point(p21[i]) = { x, y1, z-tply*i, lc}; 
	p22[{i}]=newp; Point(p22[i]) = {-x, y1, z-tply*i, lc}; 
	p23[{i}]=newp; Point(p23[i]) = {-x,-y+y1, z-tply*i, lc}; 
	p24[{i}]=newp; Point(p24[i]) = { x,-y+y1, z-tply*i, lc};
	l21[{i}]=newl;  Line(l21[i]) = {p21[i],p22[i]}; 
	l22[{i}]=newl;  Line(l22[i]) = {p22[i],p23[i]}; 
	l23[{i}]=newl;  Line(l23[i]) = {p23[i],p24[i]}; 
	l24[{i}]=newl;  Line(l24[i]) = {p24[i],p21[i]}; 
	ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]}; 
	// Hole In Plate!!
	x = D*sf/2; y = D*sf/2; 
	p30[{i}]=newp; Point(p30[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p31[{i}]=newp; Point(p31[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p32[{i}]=newp; Point(p32[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p33[{i}]=newp; Point(p33[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p34[{i}]=newp; Point(p34[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l31[{i}]=newl;Circle(l31[i]) = {p31[i],p30[i],p32[i]}; 
	l32[{i}]=newl;Circle(l32[i]) = {p32[i],p30[i],p33[i]}; 
	l33[{i}]=newl;Circle(l33[i]) = {p33[i],p30[i],p34[i]}; 
	l34[{i}]=newl;Circle(l34[i]) = {p34[i],p30[i],p31[i]}; 
	ll31[{i}]=newll; Line Loop(ll31[i]) = {l31[i],l32[i],l33[i],l34[i]}; 
	s21[{i}]=news; Plane Surface(s21[i]) = {ll31[i],ll21[i]};
	Extrude {0,0,-tply} { Surface{s21[i]}; Layers{nep}; Recombine;}
EndFor

// - - - - Lower Plate - - - -
tol = 0.001; 	// Tolerance between plates
For i In {0:(nply-1)}
	sf = Sqrt(2)/2;
	// Outer Rectangle
	x = W/2; y = L; z = -T/2; lc = lc_S;
	x1 = a/2; y1 = b/2; 
	p21[{i}]=newp; Point(p21[i]) = { x, y1, z-tply*i, lc}; 
	p22[{i}]=newp; Point(p22[i]) = {-x, y1, z-tply*i, lc}; 
	p23[{i}]=newp; Point(p23[i]) = {-x,-y+y1, z-tply*i, lc}; 
	p24[{i}]=newp; Point(p24[i]) = { x,-y+y1, z-tply*i, lc};
	l21[{i}]=newl;  Line(l21[i]) = {p21[i],p22[i]}; 
	l22[{i}]=newl;  Line(l22[i]) = {p22[i],p23[i]}; 
	l23[{i}]=newl;  Line(l23[i]) = {p23[i],p24[i]}; 
	l24[{i}]=newl;  Line(l24[i]) = {p24[i],p21[i]}; 
	ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]}; 
	// Hole In Plate!!
	x = D*sf/2; y = D*sf/2; z =-T/2-tol; lc = lc_S;
	p30[{i}]=newp; Point(p30[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p31[{i}]=newp; Point(p31[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p32[{i}]=newp; Point(p32[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p33[{i}]=newp; Point(p33[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p34[{i}]=newp; Point(p34[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l31[{i}]=newl;Circle(l31[i]) = {p31[i],p30[i],p32[i]}; 
	l32[{i}]=newl;Circle(l32[i]) = {p32[i],p30[i],p33[i]}; 
	l33[{i}]=newl;Circle(l33[i]) = {p33[i],p30[i],p34[i]}; 
	l34[{i}]=newl;Circle(l34[i]) = {p34[i],p30[i],p31[i]}; 
	ll31[{i}]=newll; Line Loop(ll31[i]) = {l31[i],l32[i],l33[i],l34[i]}; 
	s21[{i}]=news; Plane Surface(s21[i]) = {ll31[i],ll21[i]};
	Extrude {0,0,-tply} { Surface{s21[i]}; Layers{nep}; Recombine;}
EndFor

// - - - - Bolt - - - -
// Solid Bolt
nep_bolt = 30; 
tol = 0.001; 	// Tolerance between bolt
nply_bolt = 1; 
For i In {0:(nply_bolt-1)}
	sf = Sqrt(2)/2;
	x1 = a/2; y1 = b/2; 
	// Hole In Plate!!
	x = D*sf/2-tol; y = D*sf/2-tol; z = 5*T/2; lc = lc_S;
	p40[{i}]=newp; Point(p40[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p41[{i}]=newp; Point(p41[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p42[{i}]=newp; Point(p42[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p43[{i}]=newp; Point(p43[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p44[{i}]=newp; Point(p44[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l41[{i}]=newl;Circle(l41[i]) = {p41[i],p40[i],p42[i]}; 
	l42[{i}]=newl;Circle(l42[i]) = {p42[i],p40[i],p43[i]}; 
	l43[{i}]=newl;Circle(l43[i]) = {p43[i],p40[i],p44[i]}; 
	l44[{i}]=newl;Circle(l44[i]) = {p44[i],p40[i],p41[i]}; 
	ll41[{i}]=newll; Line Loop(ll41[i]) = {l41[i],l42[i],l43[i],l44[i]}; 
	s41[{i}]=news; Plane Surface(s41[i]) = {ll41[i]};
	Extrude {0,0,-5*T} { Surface{s41[i]}; Layers{nep_bolt}; Recombine;}
EndFor

// - - - - Upper Nut - - - -
// Solid Nut
nep_bolt = 30; 
tol = 0.001; 	// Tolerance between bolt
nply_bolt = 1; 
For i In {0:(nply_bolt-1)}
	sf = Sqrt(2)/2;
	x1 = a/2; y1 = b/2; 
	// Hole In Plate!!
	x = D*sf/2+tol; y = D*sf/2+tol; z = 2*T+tol; lc = lc_S;
	p50[{i}]=newp; Point(p50[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p51[{i}]=newp; Point(p51[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p52[{i}]=newp; Point(p52[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p53[{i}]=newp; Point(p53[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p54[{i}]=newp; Point(p54[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l51[{i}]=newl;Circle(l51[i]) = {p51[i],p50[i],p52[i]}; 
	l52[{i}]=newl;Circle(l52[i]) = {p52[i],p50[i],p53[i]}; 
	l53[{i}]=newl;Circle(l53[i]) = {p53[i],p50[i],p54[i]}; 
	l54[{i}]=newl;Circle(l54[i]) = {p54[i],p50[i],p51[i]}; 
	ll51[{i}]=newll; Line Loop(ll51[i]) = {l51[i],l52[i],l53[i],l54[i]}; 
	x = D*sf-tol; y = D*sf-tol; 
	p60[{i}]=newp; Point(p60[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p61[{i}]=newp; Point(p61[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p62[{i}]=newp; Point(p62[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p63[{i}]=newp; Point(p63[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p64[{i}]=newp; Point(p64[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l61[{i}]=newl;Circle(l61[i]) = {p61[i],p60[i],p62[i]}; 
	l62[{i}]=newl;Circle(l62[i]) = {p62[i],p60[i],p63[i]}; 
	l63[{i}]=newl;Circle(l63[i]) = {p63[i],p60[i],p64[i]}; 
	l64[{i}]=newl;Circle(l64[i]) = {p64[i],p60[i],p61[i]}; 
	ll61[{i}]=newll; Line Loop(ll61[i]) = {l61[i],l62[i],l63[i],l64[i]};
	s51[{i}]=news; Plane Surface(s51[i]) = {ll61[i],ll51[i]};
	Extrude {0,0,-T/2} { Surface{s51[i]}; Layers{nep_bolt}; Recombine;}
EndFor

// - - - - Lower Nut - - - -
// Solid Nut
nep_bolt = 30; 
tol = 0.001; 	// Tolerance between bolt
nply_bolt = 1; 
For i In {0:(nply_bolt-1)}
	sf = Sqrt(2)/2;
	x1 = a/2; y1 = b/2; 
	// Hole In Plate!!
	x = D*sf/2+tol; y = D*sf/2+tol; z = -3*T/2-tol; lc = lc_S;
	p70[{i}]=newp; Point(p70[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p71[{i}]=newp; Point(p71[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p72[{i}]=newp; Point(p72[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p73[{i}]=newp; Point(p73[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p74[{i}]=newp; Point(p74[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l71[{i}]=newl;Circle(l71[i]) = {p71[i],p70[i],p72[i]}; 
	l72[{i}]=newl;Circle(l72[i]) = {p72[i],p70[i],p73[i]}; 
	l73[{i}]=newl;Circle(l73[i]) = {p73[i],p70[i],p74[i]}; 
	l74[{i}]=newl;Circle(l74[i]) = {p74[i],p70[i],p71[i]}; 
	ll71[{i}]=newll; Line Loop(ll71[i]) = {l71[i],l72[i],l73[i],l74[i]}; 
	x = D*sf-tol; y = D*sf-tol; 
	p80[{i}]=newp; Point(p80[i]) = { 0-x_D, 0-y_D, 	z-tply*i, lc};	
	p81[{i}]=newp; Point(p81[i]) = { x-x_D, y-y_D, 	z-tply*i, lc}; 
	p82[{i}]=newp; Point(p82[i]) = {-x-x_D, y-y_D, 	z-tply*i, lc}; 
	p83[{i}]=newp; Point(p83[i]) = {-x-x_D,-y-y_D, 	z-tply*i, lc}; 
	p84[{i}]=newp; Point(p84[i]) = { x-x_D,-y-y_D, 	z-tply*i, lc};
	l81[{i}]=newl;Circle(l81[i]) = {p81[i],p80[i],p82[i]}; 
	l82[{i}]=newl;Circle(l82[i]) = {p82[i],p80[i],p83[i]}; 
	l83[{i}]=newl;Circle(l83[i]) = {p83[i],p80[i],p84[i]}; 
	l84[{i}]=newl;Circle(l84[i]) = {p84[i],p80[i],p81[i]}; 
	ll81[{i}]=newll; Line Loop(ll81[i]) = {l81[i],l82[i],l83[i],l84[i]};
	s71[{i}]=news; Plane Surface(s71[i]) = {ll81[i],ll71[i]};
	Extrude {0,0,-T/2} { Surface{s71[i]}; Layers{nep_bolt}; Recombine;}
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


 




