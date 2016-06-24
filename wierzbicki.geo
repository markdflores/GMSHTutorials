/* 
Author: Mark Flores
Purpose: Create a gmsh .geo file that scripts a composite
laminate or solide for a Wierzbicki specimen. 

Every dimensions starts from Quadrant I then to II, III, IV of a cartesian coordinate system

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
W = 3*25.4; 		// mm
L = 8*25.4; 		// mm
T = 6.35; 		// mm
// To understand these parameters it requires going through the code. 
L1 = 1.5*25.4; 		
W1 = 6.35; 
R1 = 25.4/2;
L2 = 0.4*25.4; 
W2 = 0.15*25.4; 
R2 = 0.75*25.4;
L3 = 4.319*25.4; 
W3 = 0; 
R3 = 0.375*25.4; 

L_pin = 1*25.4; 
W_pin = 0;
R_pin = 0.375*25.4; 

nply = 1; 		// integer 
tply = T/nply; 		// mm 

lc_S = 6; 		// element size = 1 (xy)
nep = 1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - - -
// Do you want pinhole? pin = 1) Yes 2) No
// - - - - - - - - - - - - - - - - - - - - - - -
pinh = 1;
// - - - - - - - - - - - - - - - - - - - - - - -
// Do you want pins? pin = 1) Yes 2) No
// - - - - - - - - - - - - - - - - - - - - - - -
pins = 0;
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
s=Sqrt(2)/2; 

// - - - - - - - - - - - - - - - - - - - - - - -
// Wierzbicki Specimen Dimensions
// - - - - - - - - - - - - - - - - - - - - - - -

For i In {0:(nply-1)}
p000 = newp; Point(p000) = {0,0,0};
// - - - - Upper Top Nodes - - - - 
x=L/2; y=W/2; z=T/2-tply*i; lc=lc_S; yd=0; 
p001[{i}]=newp;Point(p001[i])={    x,    y,z,lc}; xd=L1; 
p002[{i}]=newp;Point(p002[i])={ x-xd, y-yd,z,lc}; yd=W1; 
p003[{i}]=newp;Point(p003[i])={ x-xd, y-yd,z,lc}; xd=xd+R1; p101[{i}]=newp;Point(p101[i])={ x-xd, y-yd,z,lc}; yd=yd+R1; 	
p004[{i}]=newp;Point(p004[i])={ x-xd, y-yd,z,lc}; xd=xd+L2; 
p005[{i}]=newp;Point(p005[i])={ x-xd, y-yd,z,lc}; yd=yd+W2;
p006[{i}]=newp;Point(p006[i])={ x-xd, y-yd,z,lc}; xd=xd+R2; 
p102[{i}]=newp;Point(p102[i])={ x-xd, y-yd,z,lc}; yd=yd+R2; 
p007[{i}]=newp;Point(p007[i])={ x-xd, y-yd,z,lc}; xd=xd+R2*s; yd=yd-R2+R2*s; 
p008[{i}]=newp;Point(p008[i])={ x-xd, y-yd,z,lc}; 
xd1 = L/2-xd; 		yd1 = W/2-yd; 
xd2 =-L/2+L3+R3*s; 	yd2 = W/2-(R3+R3*s); 
xd8 = ((xd2+xd1)+(-yd2+yd1))/2; 
yd8 = ((-xd2+xd1)+(yd2+yd1))/2;
xd=L3+R3*s; yd=R3+R3*s;
p009[{i}]=newp;Point(p009[i])={  xd8,  yd8,z,lc};
p010[{i}]=newp;Point(p010[i])={-x+xd, y-yd,z,lc}; xd=L3+R3; yd=R3; 
p011[{i}]=newp;Point(p011[i])={-x+xd, y-yd,z,lc}; xd=L3;
p103[{i}]=newp;Point(p103[i])={-x+xd, y-yd,z,lc}; yd=0;
p012[{i}]=newp;Point(p012[i])={-x+xd, y-yd,z,lc}; xd=0; yd=0; 
// - - - - Upper Left Node - - - - 
p013[{i}]=newp;Point(p013[i])={-x+xd, y-yd,z,lc};
// - - - - Lower Left Node - - - - 
p014[{i}]=newp;Point(p014[i])={-x+xd,-y+yd,z,lc}; xd=L1;  
// - - - - Lower Bot Nodes - - - - 
p015[{i}]=newp;Point(p015[i])={-x+xd,-y+yd,z,lc}; yd=W1; 
p016[{i}]=newp;Point(p016[i])={-x+xd,-y+yd,z,lc}; xd=xd+R1; p104[{i}]=newp;Point(p104[i])={-x+xd,-y+yd,z,lc}; yd=yd+R1; 	
p017[{i}]=newp;Point(p017[i])={-x+xd,-y+yd,z,lc}; xd=xd+L2; 
p018[{i}]=newp;Point(p018[i])={-x+xd,-y+yd,z,lc}; yd=yd+W2;
p019[{i}]=newp;Point(p019[i])={-x+xd,-y+yd,z,lc}; xd=xd+R2; 
p105[{i}]=newp;Point(p105[i])={-x+xd,-y+yd,z,lc}; yd=yd+R2; 
p020[{i}]=newp;Point(p020[i])={-x+xd,-y+yd,z,lc}; xd=xd+R2*s; yd=yd-R2+R2*s; 
p021[{i}]=newp;Point(p021[i])={-x+xd,-y+yd,z,lc}; 
p022[{i}]=newp;Point(p022[i])={-xd8,  -yd8,z,lc}; xd=L3+R3*s; yd=R3+R3*s;
p023[{i}]=newp;Point(p023[i])={ x-xd,-y+yd,z,lc}; xd=L3+R3; yd=R3; 
p024[{i}]=newp;Point(p024[i])={ x-xd,-y+yd,z,lc}; xd=L3;
p106[{i}]=newp;Point(p106[i])={ x-xd,-y+yd,z,lc}; yd=0;
p025[{i}]=newp;Point(p025[i])={ x-xd,-y+yd,z,lc}; xd=0; yd=0; 
p026[{i}]=newp;Point(p026[i])={ x-xd,-y+yd,z,lc}; 
// - - - - Top Lines - - - -
l001[{i}]=newl;  Line(l001[i])={p001[i],p002[i]};	
l002[{i}]=newl;  Line(l002[i])={p002[i],p003[i]};		
l003[{i}]=newl;Circle(l003[i])={p003[i],p101[i],p004[i]};	
l004[{i}]=newl;  Line(l004[i])={p004[i],p005[i]};	
l005[{i}]=newl;  Line(l005[i])={p005[i],p006[i]};
l006[{i}]=newl;Circle(l006[i])={p006[i],p102[i],p007[i]};	
l007[{i}]=newl;Circle(l007[i])={p007[i],p102[i],p008[i]};	
l008[{i}]=newl;  Line(l008[i])={p008[i],p009[i]};
l009[{i}]=newl;  Line(l009[i])={p009[i],p010[i]};
l010[{i}]=newl;Circle(l010[i])={p010[i],p103[i],p011[i]};	
l011[{i}]=newl;Circle(l011[i])={p011[i],p103[i],p012[i]};	
l012[{i}]=newl;  Line(l012[i])={p012[i],p013[i]};
// - - - - Left Line - - - -
l013[{i}]=newl;  Line(l013[i])={p013[i],p014[i]};
// - - - - Bot Lines - - - - 
l014[{i}]=newl;  Line(l014[i])={p014[i],p015[i]};
l015[{i}]=newl;  Line(l015[i])={p015[i],p016[i]};
l016[{i}]=newl;Circle(l016[i])={p016[i],p104[i],p017[i]};	
l017[{i}]=newl;  Line(l017[i])={p017[i],p018[i]};	
l018[{i}]=newl;  Line(l018[i])={p018[i],p019[i]};
l019[{i}]=newl;Circle(l019[i])={p019[i],p105[i],p020[i]};	
l020[{i}]=newl;Circle(l020[i])={p020[i],p105[i],p021[i]};	
l021[{i}]=newl;  Line(l021[i])={p021[i],p022[i]};
l022[{i}]=newl;  Line(l022[i])={p022[i],p023[i]};
l023[{i}]=newl;Circle(l023[i])={p023[i],p106[i],p024[i]};
l024[{i}]=newl;Circle(l024[i])={p024[i],p106[i],p025[i]};
l025[{i}]=newl;  Line(l025[i])={p025[i],p026[i]};
// - - - - Right Line - - - -
l026[{i}]=newl;  Line(l026[i])={p026[i],p001[i]};
// - - - - Combine Lines For Simplicity - - - -
l01[]={l001[i]:l012[i]};
l02[]={l013[i]};
l03[]={l014[i]:l025[i]};
l04[]={l026[i]};
// - - - - Line Loop of Square - - - -
ll01[{i}]=newll; Line Loop(ll01[i])={l01[],l02[],l03[],l04[]};
// - - - - - - - - - - - - - - - - - - - - - - -
// Do you want pin holes 
// - - - - - - - - - - - - - - - - - - - - - - -
If (pinh==1)
  x = L/2-L_pin; y = W_pin; 
  xd = R_pin*s; yd = R_pin*s;
  p107[{i}]=newp;Point(p107[i])={ x   , y   ,z,lc};
  ph01[{i}]=newp;Point(ph01[i])={ x+xd, y+yd,z,lc};
  ph02[{i}]=newp;Point(ph02[i])={ x-xd, y+yd,z,lc};
  ph03[{i}]=newp;Point(ph03[i])={ x-xd, y-yd,z,lc};
  ph04[{i}]=newp;Point(ph04[i])={ x+xd, y-yd,z,lc};
  p108[{i}]=newp;Point(p108[i])={-x   ,-y   ,z,lc};
  ph11[{i}]=newp;Point(ph11[i])={-x+xd,-y+yd,z,lc};
  ph12[{i}]=newp;Point(ph12[i])={-x-xd,-y+yd,z,lc};
  ph13[{i}]=newp;Point(ph13[i])={-x-xd,-y-yd,z,lc};
  ph14[{i}]=newp;Point(ph14[i])={-x+xd,-y-yd,z,lc};
  lh01[{i}]=newl;Circle(lh01[i])={ph01[i],p107[i],ph02[i]};
  lh02[{i}]=newl;Circle(lh02[i])={ph02[i],p107[i],ph03[i]};
  lh03[{i}]=newl;Circle(lh03[i])={ph03[i],p107[i],ph04[i]};
  lh04[{i}]=newl;Circle(lh04[i])={ph04[i],p107[i],ph01[i]};
  lh11[{i}]=newl;Circle(lh11[i])={ph11[i],p108[i],ph12[i]};
  lh12[{i}]=newl;Circle(lh12[i])={ph12[i],p108[i],ph13[i]};
  lh13[{i}]=newl;Circle(lh13[i])={ph13[i],p108[i],ph14[i]};
  lh14[{i}]=newl;Circle(lh14[i])={ph14[i],p108[i],ph11[i]};	
  ll02[{i}]=newll; Line Loop(ll02[i])={lh01[i],lh02[i],lh03[i],lh04[i]};
  ll03[{i}]=newll; Line Loop(ll03[i])={lh11[i],lh12[i],lh13[i],lh14[i]};
  s01[{i}]=news; Plane Surface(s01[i])={ll01[i],ll02[i],ll03[i]};
Else
  s01[{i}]=news; Plane Surface(s01[i])={ll01[i]};
EndIf
// - - - - Create Volume - - - 
Extrude {0,0,-tply} {Surface{s01[i]}; Layers{nep}; Recombine;}
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Do you want pins? 
// - - - - - - - - - - - - - - - - - - - - - - -
tol=0.0000; 
If (pins == 1)
  x = L/2-L_pin; y = W_pin;  z=T/2; lc=lc_S;
  Rs=s*R_pin-tol; 
  p50[{i}]=newp;Point(p50[i])={ x   , y   ,z,lc};
  p51[{i}]=newp;Point(p51[i])={ x+Rs, y+Rs,z,lc};
  p52[{i}]=newp;Point(p52[i])={ x-Rs, y+Rs,z,lc};	
  p53[{i}]=newp;Point(p53[i])={ x-Rs, y-Rs,z,lc};	
  p54[{i}]=newp;Point(p54[i])={ x+Rs, y-Rs,z,lc};
  p60[{i}]=newp;Point(p60[i])={-x   ,-y   ,z,lc};
  p61[{i}]=newp;Point(p61[i])={-x+Rs,-y+Rs,z,lc};
  p62[{i}]=newp;Point(p62[i])={-x-Rs,-y+Rs,z,lc};	
  p63[{i}]=newp;Point(p63[i])={-x-Rs,-y-Rs,z,lc};	
  p64[{i}]=newp;Point(p64[i])={-x+Rs,-y-Rs,z,lc};
  Rs=s*R_pin/4; 
  p70[{i}]=newp;Point(p70[i])={ x   , y   ,z,lc};
  p71[{i}]=newp;Point(p71[i])={ x+Rs, y+Rs,z,lc};
  p72[{i}]=newp;Point(p72[i])={ x-Rs, y+Rs,z,lc};	
  p73[{i}]=newp;Point(p73[i])={ x-Rs, y-Rs,z,lc};	
  p74[{i}]=newp;Point(p74[i])={ x+Rs, y-Rs,z,lc};
  p80[{i}]=newp;Point(p80[i])={-x   ,-y   ,z,lc};
  p81[{i}]=newp;Point(p81[i])={-x+Rs,-y+Rs,z,lc};
  p82[{i}]=newp;Point(p82[i])={-x-Rs,-y+Rs,z,lc};	
  p83[{i}]=newp;Point(p83[i])={-x-Rs,-y-Rs,z,lc};	
  p84[{i}]=newp;Point(p84[i])={-x+Rs,-y-Rs,z,lc};
  l51[{i}]=newl;Circle(l51[i])={p51[i],p50[i],p52[i]};
  l52[{i}]=newl;Circle(l52[i])={p52[i],p50[i],p53[i]};
  l53[{i}]=newl;Circle(l53[i])={p53[i],p50[i],p54[i]};
  l54[{i}]=newl;Circle(l54[i])={p54[i],p50[i],p51[i]};
  l61[{i}]=newl;Circle(l61[i])={p61[i],p60[i],p62[i]};
  l62[{i}]=newl;Circle(l62[i])={p62[i],p60[i],p63[i]};
  l63[{i}]=newl;Circle(l63[i])={p63[i],p60[i],p64[i]};
  l64[{i}]=newl;Circle(l64[i])={p64[i],p60[i],p61[i]};
  l71[{i}]=newl;Circle(l71[i])={p71[i],p70[i],p72[i]};
  l72[{i}]=newl;Circle(l72[i])={p72[i],p70[i],p73[i]};
  l73[{i}]=newl;Circle(l73[i])={p73[i],p70[i],p74[i]};
  l74[{i}]=newl;Circle(l74[i])={p74[i],p70[i],p71[i]};
  l81[{i}]=newl;Circle(l81[i])={p81[i],p80[i],p82[i]};
  l82[{i}]=newl;Circle(l82[i])={p82[i],p80[i],p83[i]};
  l83[{i}]=newl;Circle(l83[i])={p83[i],p80[i],p84[i]};
  l84[{i}]=newl;Circle(l84[i])={p84[i],p80[i],p81[i]};
  ll51[{i}]=newll; Line Loop(ll51[i])={l51[i],l52[i],l53[i],l54[i]};
  ll61[{i}]=newll; Line Loop(ll61[i])={l61[i],l62[i],l63[i],l64[i]};
  ll71[{i}]=newll; Line Loop(ll71[i])={l71[i],l72[i],l73[i],l74[i]};
  ll81[{i}]=newll; Line Loop(ll81[i])={l81[i],l82[i],l83[i],l84[i]};
  s51[{i}]=news; Plane Surface(s51[i])={ll51[i],ll71[i]};
  s61[{i}]=news; Plane Surface(s61[i])={ll61[i],ll81[i]};
  Extrude {0,0,-tply} {Surface{s51[i],s61[i]}; Layers{nep}; Recombine;}
EndIf

// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - - - - - - - - - - - -
// - - - - Near Center of Wierzbicki Specimen - - - - 
mesh_refine_crack = lc_S/8; 
mesh_refine_crackradius = 25.4; 
x_C = 0.0; 
y_C = 0.0; 
z_C = 0.0; 
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
// - - - - Mesh Refinement Near Holes - - - - 
mesh_refine_hole  = lc_S; 
mesh_refine_holeradius = 19.05;
x_D = L/2-L_pin; 
y_D = W_pin;
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
Field[j].XCenter= x_D*unit; 
Field[j].YAxis 	= 0;
Field[j].YCenter= y_D; 
Field[j].ZAxis 	= 100; 
Field[j].ZCenter= 0;
EndFor
// - - - - Mesh Refinement Near Sensor If Wanted - - - - 
mesh_refine_sensor = lc_S; 
ac_radius = 12.7; 
x_S = 0.0; 
y_S = 0.0;
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

// 100) considers all or 1) Considers center only
Background Field = 100; 

// - - - - - - - - - - - - - - - - - - - - - - -
// Create Hexahedral Element
// - - - - - - - - - - - - - - - - - - - - - - -
Recombine Surface "*";














