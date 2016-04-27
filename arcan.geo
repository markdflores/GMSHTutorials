/* 
Author: Mark Flores
Purpose: 
Create a gmsh .geo file that scripts a composite
laminate arcan specimen given a width, length, and thickness.
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
// - - - - Dimensions - - - -
W 	= 98.5; 		
L 	= 101.6; 		
T 	= 10; 			
D 	= 6.35; 		
D_gauge = 25.4;
D_W 	= 63.5; 
R1 	= 15.34;
W_gauge = 38.1; 
// - - - - Composite - - - -
nply =2; 		// integer
tply = T/nply; 	// mm 
// - - - - Mesh - - - - 
lc_S = 2; 		// element size = 1 (xy)
nep =1; 		// number of elements in z for each ply
mesh_refine_lc = 2; 	// mesh refinement lc_S/mesh_refine_lc
mesh_refine_lcR = 4; 	// mesh refinement around Pin Holes
// - - - - - - - - - - - - - - - - - - - - - - -
// Do You Want Pins?
// - - - - - - - - - - - - - - - - - - - - - - -
Pins = 1; //1) Pins 0) No Pins
If (Pins==1)
  nep_pin = nply; 
EndIf
If (Pins!=1)
  nep_pin = nply; 
EndIf

// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
s=Sqrt(2)/2; 
tol=0.00001; 
T_X = tply-tol; 

For i In {0:(nply-1)}		// Start of Composite
// - - - - Outer Points - - - - 
x=W/2; y=L/2; z=T/2-tply*i; lc=lc_S;
p01[{i}]=newp; Point(p01[i]) = { x, y, z, lc};
p02[{i}]=newp; Point(p02[i]) = {-x, y, z, lc};	
p03[{i}]=newp; Point(p03[i]) = {-x,-y, z, lc};	
p04[{i}]=newp; Point(p04[i]) = { x,-y, z, lc};	
l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]};
l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]};
// - - - - Gauge Points - - - - 
x1 = L/2-R1-W_gauge/2; 
x=R1/s+x1; y=L/2; z=T/2-tply*i; lc=lc_S;
p41[{i}]=newp; Point(p41[i]) = { x, y, z, lc};
p42[{i}]=newp; Point(p42[i]) = {-x, y, z, lc};
p43[{i}]=newp; Point(p43[i]) = {-x,-y, z, lc};
p44[{i}]=newp; Point(p44[i]) = { x,-y, z, lc};
l41[{i}]=newl;  Line(l41[i]) = {p01[i],p41[i]};
l42[{i}]=newl;  Line(l42[i]) = {p42[i],p02[i]};
l43[{i}]=newl;  Line(l43[i]) = {p03[i],p43[i]};
l44[{i}]=newl;  Line(l44[i]) = {p44[i],p04[i]};
// - - - - Center Top - - - - 
x=0; y=R1+W_gauge/2; z=T/2-tply*i; lc=lc_S;
p30[{i}]=newp; Point(p30[i]) = { x, y, z, lc};
x=0; y=R1+W_gauge/2; z=T/2-tply*i; lc=lc_S;
p31[{i}]=newp; Point(p31[i]) = { x+R1*s, y-R1*s, z, lc};
p32[{i}]=newp; Point(p32[i]) = {-x-R1*s, y-R1*s, z, lc};	
l31[{i}]=newl;  Line(l31[i]) = {p41[i],p31[i]};
l32[{i}]=newl;Circle(l32[i]) = {p31[i],p30[i],p32[i]};
l33[{i}]=newl;  Line(l33[i]) = {p32[i],p42[i]};
// - - - - Center Bot - - - - 
x=0; y=R1+W_gauge/2; z=T/2-tply*i; lc=lc_S;
p35[{i}]=newp; Point(p35[i]) = { x,-y, z, lc};
x=0; y=R1+W_gauge/2; z=T/2-tply*i; lc=lc_S;
p33[{i}]=newp; Point(p33[i]) = {-x-R1*s,-y+R1*s, z, lc};
p34[{i}]=newp; Point(p34[i]) = { x+R1*s,-y+R1*s, z, lc};	
l34[{i}]=newl;  Line(l34[i]) = {p43[i],p33[i]};
l35[{i}]=newl;Circle(l35[i]) = {p33[i],p35[i],p34[i]};
l36[{i}]=newl;  Line(l36[i]) = {p34[i],p44[i]};
// - - - - Combine Lines Top and Bot - - - - 
l37[] = {l41[i],l31[i],l32[i],l33[i],l42[i]};
l38[] = {l43[i],l34[i],l35[i],l36[i],l44[i]};

ll01[{i}]=newll; Line Loop(ll01[i]) = {l37[],l02[i],l38[],l04[i]};

llx1[]={};
llx2[]={};
For j In {0:2}	// Pin Holes

x=D_W/2; y=D_gauge*(1-j); lc=lc_S; 
p10[{i}]=newp; Point(p10[i]) = { x, y, z, lc};
p20[{i}]=newp; Point(p20[i]) = {-x, y, z, lc};
x=D_W/2; y=D_gauge*(1-j); lc=lc_S; 
p11[{i}]=newp; Point(p11[i]) = { x+D*s/2, y+D*s/2, z, lc};
p12[{i}]=newp; Point(p12[i]) = { x-D*s/2, y+D*s/2, z, lc};	
p13[{i}]=newp; Point(p13[i]) = { x-D*s/2, y-D*s/2, z, lc};	
p14[{i}]=newp; Point(p14[i]) = { x+D*s/2, y-D*s/2, z, lc};
p21[{i}]=newp; Point(p21[i]) = {-x+D*s/2, y+D*s/2, z, lc};
p22[{i}]=newp; Point(p22[i]) = {-x-D*s/2, y+D*s/2, z, lc};	
p23[{i}]=newp; Point(p23[i]) = {-x-D*s/2, y-D*s/2, z, lc};	
p24[{i}]=newp; Point(p24[i]) = {-x+D*s/2, y-D*s/2, z, lc};
l11[{i}]=newl;Circle(l11[i]) = {p11[i],p10[i],p12[i]};
l12[{i}]=newl;Circle(l12[i]) = {p12[i],p10[i],p13[i]};
l13[{i}]=newl;Circle(l13[i]) = {p13[i],p10[i],p14[i]};
l14[{i}]=newl;Circle(l14[i]) = {p14[i],p10[i],p11[i]};
l21[{i}]=newl;Circle(l21[i]) = {p21[i],p20[i],p22[i]};
l22[{i}]=newl;Circle(l22[i]) = {p22[i],p20[i],p23[i]};
l23[{i}]=newl;Circle(l23[i]) = {p23[i],p20[i],p24[i]};
l24[{i}]=newl;Circle(l24[i]) = {p24[i],p20[i],p21[i]};
ll11[{i}]=newll; Line Loop(ll11[i]) = {l11[i],l12[i],l13[i],l14[i]};
ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]};
llx1[] += {ll11[i]};
llx2[] += {ll21[i]};

EndFor		// Pin Holes

s01[{i}]=news; Plane Surface(s01[i]) = {ll01[i],llx1[],llx2[]};  
Extrude {0,0,-T_X} {Surface{s01[i]}; Layers{nep}; Recombine;}

EndFor			// End of Composite

If (Pins == 1)		// Pin?

tol=0.001; 

For i In {0:2}

x=D_W/2; y=D_gauge*(1-i); z=T/2; lc=lc_S; 
p50[{i}]=newp; Point(p50[i]) = { x, y, z, lc};
p60[{i}]=newp; Point(p60[i]) = {-x, y, z, lc};
x=D_W/2; y=D_gauge*(1-i); lc=lc_S;
val=D*s/2-tol; 
p51[{i}]=newp; Point(p51[i]) = { x+val, y+val, z, lc};
p52[{i}]=newp; Point(p52[i]) = { x-val, y+val, z, lc};	
p53[{i}]=newp; Point(p53[i]) = { x-val, y-val, z, lc};	
p54[{i}]=newp; Point(p54[i]) = { x+val, y-val, z, lc};
p61[{i}]=newp; Point(p61[i]) = {-x+val, y+val, z, lc};
p62[{i}]=newp; Point(p62[i]) = {-x-val, y+val, z, lc};	
p63[{i}]=newp; Point(p63[i]) = {-x-val, y-val, z, lc};	
p64[{i}]=newp; Point(p64[i]) = {-x+val, y-val, z, lc};
l51[{i}]=newl;Circle(l51[i]) = {p51[i],p50[i],p52[i]};
l52[{i}]=newl;Circle(l52[i]) = {p52[i],p50[i],p53[i]};
l53[{i}]=newl;Circle(l53[i]) = {p53[i],p50[i],p54[i]};
l54[{i}]=newl;Circle(l54[i]) = {p54[i],p50[i],p51[i]};
l61[{i}]=newl;Circle(l61[i]) = {p61[i],p60[i],p62[i]};
l62[{i}]=newl;Circle(l62[i]) = {p62[i],p60[i],p63[i]};
l63[{i}]=newl;Circle(l63[i]) = {p63[i],p60[i],p64[i]};
l64[{i}]=newl;Circle(l64[i]) = {p64[i],p60[i],p61[i]};
x=D_W/2; y=D_gauge*(1-i); lc=lc_S;
val=D*s/4; 
p71[{i}]=newp; Point(p71[i]) = { x+val, y+val, z, lc};
p72[{i}]=newp; Point(p72[i]) = { x-val, y+val, z, lc};	
p73[{i}]=newp; Point(p73[i]) = { x-val, y-val, z, lc};	
p74[{i}]=newp; Point(p74[i]) = { x+val, y-val, z, lc};
p81[{i}]=newp; Point(p81[i]) = {-x+val, y+val, z, lc};
p82[{i}]=newp; Point(p82[i]) = {-x-val, y+val, z, lc};	
p83[{i}]=newp; Point(p83[i]) = {-x-val, y-val, z, lc};	
p84[{i}]=newp; Point(p84[i]) = {-x+val, y-val, z, lc};
l71[{i}]=newl;Circle(l71[i]) = {p71[i],p50[i],p72[i]};
l72[{i}]=newl;Circle(l72[i]) = {p72[i],p50[i],p73[i]};
l73[{i}]=newl;Circle(l73[i]) = {p73[i],p50[i],p74[i]};
l74[{i}]=newl;Circle(l74[i]) = {p74[i],p50[i],p71[i]};
l81[{i}]=newl;Circle(l81[i]) = {p81[i],p60[i],p82[i]};
l82[{i}]=newl;Circle(l82[i]) = {p82[i],p60[i],p83[i]};
l83[{i}]=newl;Circle(l83[i]) = {p83[i],p60[i],p84[i]};
l84[{i}]=newl;Circle(l84[i]) = {p84[i],p60[i],p81[i]};
ll51[{i}]=newll; Line Loop(ll51[i]) = {l51[i],l52[i],l53[i],l54[i]};
ll61[{i}]=newll; Line Loop(ll61[i]) = {l61[i],l62[i],l63[i],l64[i]};
ll71[{i}]=newll; Line Loop(ll71[i]) = {l71[i],l72[i],l73[i],l74[i]};
ll81[{i}]=newll; Line Loop(ll81[i]) = {l81[i],l82[i],l83[i],l84[i]};
s51[{i}]=news; Plane Surface(s51[i]) = {ll51[i],ll71[i]};  
s61[{i}]=news; Plane Surface(s61[i]) = {ll61[i],ll81[i]}; 
Extrude {0,0,-T} {Surface{s51[i]}; Layers{nep_pin}; Recombine;}
Extrude {0,0,-T} {Surface{s61[i]}; Layers{nep_pin}; Recombine;}

EndFor

EndIf			// Pin?

// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - - - - - - - - - - - -
Field[1] = Box; 
Field[1].VIn = lc_S/mesh_refine_lc; 
Field[1].VOut= lc; 
Field[1].XMax= R1*s+1; 
Field[1].XMin=-R1*s-1;  
Field[1].YMax= L/2; 
Field[1].YMin=-L/2; 
Field[1].ZMax= 20; 
Field[1].ZMin=-20; 

m=2; 
For j In {0:2}
  Field[m+j] = Cylinder;
  Field[m+j].Radius = D;  
  Field[m+j].VIn = lc_S/mesh_refine_lcR; 
  Field[m+j].VOut= lc; 
  Field[m+j].XAxis	= 0.0; 
  Field[m+j].XCenter	= D_W/2;  
  Field[m+j].YAxis	= 0.0; 
  Field[m+j].YCenter	= D_gauge*(1-j); 
  Field[m+j].ZAxis	= 20.0;
  Field[m+j].ZCenter	= 0.0;
EndFor
n=m+j; 
For j In {0:2}
  Field[n+j] = Cylinder;
  Field[n+j].Radius = D;  
  Field[n+j].VIn = lc_S/mesh_refine_lcR; 
  Field[n+j].VOut= lc; 
  Field[n+j].XAxis	= 0.0; 
  Field[n+j].XCenter	=-D_W/2;  
  Field[n+j].YAxis	= 0.0; 
  Field[n+j].YCenter	= D_gauge*(1-j); 
  Field[n+j].ZAxis	= 20.0; 
  Field[n+j].ZCenter	= 0.0; 
EndFor
l=n+j-1;

Field[100] = Min; 
Field[100].FieldsList = {1,m:l};

Field[101] = Min; 
Field[101].FieldsList = {1};

Background Field = 100; // Field 1 or Field 0 - no mesh refinement

Recombine Surface "*";














