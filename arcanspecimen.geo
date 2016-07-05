/* 
Author: Mark Flores
Purpose: 
Create a gmsh .geo file that scripts a composite laminate arcan specimen given a width, length, and thickness.
Inputs: 
W	- Width
L	- Length
T	- Thickness
R 	- Radius
nply	- Number of Plies/Lamina
tply	- Thickness of a Single Ply/Lamina
Mesh: 
lc_# 	- Characteristic Length of Edge/Point
*/
// - - - - - - - - - - - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - - - - - - - - - - - -
// - - - - Dimensions - - - -
W 	= 98.5; 	// mm	
L 	= 101.6;  	// mm			
T 	= 10;  		// mm				
W_gauge = 38.1; 	// mm
R1 	= 15.34; 	// mm
R_pin 	= 3.175;  	// mm			
W_pin   = 25.4; 	// mm	
L_pin 	= 63.5;  	// mm	
tol_pin = 0.001;	// mm	 
// - - - - Composite - - - -
nply =24; 		// integer
tply = T/nply; 		// mm 
// - - - - - - - - - - - - - - - - - - - - - - -
// This is code is for Unstructured Mesh in xy
// - - - - - - - - - - - - - - - - - - - - - - - 
lc_S = 4; 		// element size = 1 (xy)
// - - - - - - - - - - - - - - - - - - - - - - -
// How many elements do you want for each ply
// - - - - - - - - - - - - - - - - - - - - - - - 
nep =1; 		// number of elements in z for each ply
// - - - - - - - - - - - - - - - - - - - - - - -
// To Perform Mesh Refinement, Scroll down
// - - - - - - - - - - - - - - - - - - - - - - - 
// - - - - - - - - - - - - - - - - - - - - - - -
// Do You Want Pins?
// - - - - - - - - - - - - - - - - - - - - - - -
pins = 0; //1) Pins 0) No Pins
// VTMS Architecture 
If (pins==1)
  If (nply>1)
  Printf( " Pins won’t work for multiple plies  " );
  Printf( " BSAM/VTMS can not do more than 6 connections  " );
  nply = 1; 
  tply = T/nply;
  Printf( " Limitations require nply=1 " );
  EndIf
EndIf
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
s=Sqrt(2)/2; 
T_X = tply; 
// - - - - - - - - - - - - - - - - - - - - - - -
// Create Points
// - - - - - - - - - - - - - - - - - - - - - - -
// - - - - Outer Points - - - - 
x=W/2; y=L/2; z=T/2; lc=lc_S;
p001=newp; Point(p001)={ x, y,z,lc};	// Cartesian Quadrant I
p002=newp; Point(p002)={-x, y,z,lc};	// Cartesian Quadrant II	
p003=newp; Point(p003)={-x,-y,z,lc};	// Cartesian Quadrant III	
p004=newp; Point(p004)={ x,-y,z,lc};	// Cartesian Quadrant IV	
// - - - - Length Gauge Points - - - - 
x1 = L/2-R1-W_gauge/2; 
x=R1/s+x1; y=L/2; 
p005=newp; Point(p005)={ x, y,z,lc};	// Cartesian Quadrant I
p006=newp; Point(p006)={-x, y,z,lc};	// Cartesian Quadrant II
p007=newp; Point(p007)={-x,-y,z,lc};	// Cartesian Quadrant III
p008=newp; Point(p008)={ x,-y,z,lc};	// Cartesian Quadrant IV
// - - - - Curvature End Points - - - - 
x=0; y=R1+W_gauge/2; y0=y; x0=x; 
p009=newp; Point(p009)={ x+R1*s, y-R1*s,z,lc};	// Cartesian Quadrant I
p010=newp; Point(p010)={-x-R1*s, y-R1*s,z,lc};	// Cartesian Quadrant II
p011=newp; Point(p011)={-x-R1*s,-y+R1*s,z,lc};	// Cartesian Quadrant III
p012=newp; Point(p012)={ x+R1*s,-y+R1*s,z,lc};	// Cartesian Quadrant IV
// - - - - Curvature End Points - - - - 
nnC=10; 		// Number of Nodes on Curve
For i In {0:(nnC-2)}	// For Loop - Curvature
  x=R1*s*(nnC-i-1)/nnC; y=y0-Sqrt(R1^2-(x-x0)^2);
  p013[{i}]=newp; Point(p013[i])={ x, y,z,lc};	// Cartesian Quadrant I
  p014[{i}]=newp; Point(p014[i])={-x, y,z,lc};	// Cartesian Quadrant II
  p015[{i}]=newp; Point(p015[i])={-x,-y,z,lc};	// Cartesian Quadrant III
  p016[{i}]=newp; Point(p016[i])={ x,-y,z,lc};	// Cartesian Quadrant IV
EndFor			// EndFor Loop - Curvature
// - - - - Width Gauge Points - - - - 
x=0; y=W_gauge/2; 
p017=newp; Point(p017)={ x, y,z,lc};
p018=newp; Point(p018)={ x,-y,z,lc};
// - - - - - - - - - - - - - - - - - - - - - - -
// Create Lines
// - - - - - - - - - - - - - - - - - - - - - - -
l001=newl;   Line(l001) = {p001,p005};	// Cartesian Quadrant I
l002=newl;   Line(l002) = {p002,p006};	// Cartesian Quadrant II
l003=newl;   Line(l003) = {p003,p007};	// Cartesian Quadrant III
l004=newl;   Line(l004) = {p004,p008};	// Cartesian Quadrant IV
l005=newl;   Line(l005) = {p005,p009};	// Cartesian Quadrant I
l006=newl;   Line(l006) = {p006,p010};	// Cartesian Quadrant II
l007=newl;   Line(l007) = {p007,p011};	// Cartesian Quadrant III
l008=newl;   Line(l008) = {p008,p012};	// Cartesian Quadrant IV
l009=newl;BSpline(l009) = {p009,p013[],p017};	// Cartesian Quadrant I
l010=newl;BSpline(l010) = {p010,p014[],p017};	// Cartesian Quadrant II
l011=newl;BSpline(l011) = {p011,p015[],p018};	// Cartesian Quadrant III
l012=newl;BSpline(l012) = {p012,p016[],p018};	// Cartesian Quadrant IV
l013=newl;   Line(l013) = {p002,p003}; 		// Left Line
l014=newl;   Line(l014) = {p004,p001}; 		// Right Line
// - - - - - Simplify Lines - - - - 
l01[] = {l001,l005,l009,-l010,-l006,-l002};
l02[] = {l013};
l03[] = {l003,l007,l011,-l012,-l008,-l004};
l04[] = {l014};
// - - - - - Line Loop - - - - - 
ll001=newll; Line Loop(ll001) = {l01[],l02[],l03[],l04[]};
// - - - - - - - - - - - - - - - - - - - - - - -
// Create Pin Holes 
// - - - - - - - - - - - - - - - - - - - - - - -
nnHx = 2; 	// Number of Holes in X
nnHy = 3; 	// Number of Holes in Y
l=0;
For i In {0:(nnHx-1)}
  For j In {0:(nnHy-1)}
  l=j+nnHy*i;  
  // - - - - Center of Pin Holes - - - - 
  x=(nnHx*i-1)*L_pin/2; y=(j-1)*W_pin; z=T/2; lc=lc_S;
  p100[{l}]=newp; Point(p100[l])={ x, y,z,lc};
  x=(nnHx*i-1)*L_pin/2; y=(j-1)*W_pin; z=T/2; lc=lc_S; 
  p101[{l}]=newp; Point(p101[l])={ x+R_pin*s, y+R_pin*s,z,lc};
  p102[{l}]=newp; Point(p102[l])={ x-R_pin*s, y+R_pin*s,z,lc};
  p103[{l}]=newp; Point(p103[l])={ x-R_pin*s, y-R_pin*s,z,lc};
  p104[{l}]=newp; Point(p104[l])={ x+R_pin*s, y-R_pin*s,z,lc};
  l101[{l}]=newl;Circle(l101[l])={p101[l],p100[l],p102[l]};
  l102[{l}]=newl;Circle(l102[l])={p102[l],p100[l],p103[l]};
  l103[{l}]=newl;Circle(l103[l])={p103[l],p100[l],p104[l]};
  l104[{l}]=newl;Circle(l104[l])={p104[l],p100[l],p101[l]};

  ll101[{l}]=newll; Line Loop(ll101[l])={l101[l],l102[l],l103[l],l104[l]};
  EndFor
EndFor
// - - - - - - - - - - - - - - - - - - - - - - -
// Create Surfaces
// - - - - - - - - - - - - - - - - - - - - - - -
s001=news; Plane Surface(s001) = {ll001,ll101[]};
// - - - - - - - - - - - - - - - - - - - - - - -
// Create Composite or Solid Specimen
// - - - - - - - - - - - - - - - - - - - - - - -
k=0;
For i In {0:(nply-1)}
  If (i==0)
  numv[]=Extrude {0,0,-tply} {Surface{s001}; Layers{nep}; Recombine;};
  numsf[]={s001};		// For Boundary Conditions Front
  numsb[]={numv[0]};		// For Boundary Conditions Back
  Else
  numv[]=Extrude {0,0,-tply} {Surface{numv[0]}; Layers{nep}; Recombine;};
  numsf[]={numsb[]};		// For Boundary Conditions Front
  numsb[]={numv[0]};		// For Boundary Conditions Back
  EndIf
  // - - - - - - - - - - - - - - - - - - - - - - -
  // Boundary Conditions for Each Ply
  // - - - - - - - - - - - - - - - - - - - - - - -
  //Printf( " %g " , numv[39]);
  v01[{i}] = newv; Physical Volume(v01[i])=numv[]; 
  bnd[]={numsf}; front[{i}]  =newreg; Physical Surface(front[i])=bnd[]; 
  bnd[]={numsb};  back[{i}]  =newreg; Physical Surface(back[i])=bnd[];
  For j In {0:l}
  bnd[]={numv[16]:numv[19]}; pinh1[{k}]=newreg; Physical Surface( pinh1[k])=bnd[];
  bnd[]={numv[20]:numv[23]}; pinh2[{k}]=newreg; Physical Surface( pinh2[k])=bnd[];
  bnd[]={numv[24]:numv[25]}; pinh3[{k}]=newreg; Physical Surface( pinh3[k])=bnd[];
  bnd[]={numv[28]:numv[31]}; pinh4[{k}]=newreg; Physical Surface( pinh4[k])=bnd[];
  bnd[]={numv[32]:numv[35]}; pinh5[{k}]=newreg; Physical Surface( pinh5[k])=bnd[];
  bnd[]={numv[36]:numv[39]}; pinh6[{k}]=newreg; Physical Surface( pinh6[k])=bnd[];
  k+=1; 
  EndFor 
  bnd[]={numv[2]:numv[7]};  top[{i}]=newreg; Physical Surface(top[i])=bnd[]; 
  bnd[]={numv[8]}; 	    bot[{i}]=newreg; Physical Surface(bot[i])=bnd[]; 
  bnd[]={numv[9]:numv[14]}; left[{i}] =newreg; Physical Surface(left[i])=bnd[]; 
  bnd[]={numv[15]}; 	    right[{i}]=newreg; Physical Surface(right[i])=bnd[];
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Create Pin Holes 
// - - - - - - - - - - - - - - - - - - - - - - -
If (pins == 1)	
nnHx = 2; 	// Number of Holes in X
nnHy = 3; 	// Number of Holes in Y
l=0;
For i In {0:(nnHx-1)}
  For j In {0:(nnHy-1)}
  l=j+nnHy*i;  
  // - - - - Center of Pin Holes - - - - 
  x=(nnHx*i-1)*L_pin/2; y=(j-1)*W_pin; z=T/2; lc=lc_S;
  p200[{l}]=newp; Point(p200[l])={ x, y,z,lc};
  x=(nnHx*i-1)*L_pin/2; y=(j-1)*W_pin; rd = R_pin*s-tol_pin; 
  p201[{l}]=newp; Point(p201[l])={ x+rd, y+rd,z,lc};
  p202[{l}]=newp; Point(p202[l])={ x-rd, y+rd,z,lc};
  p203[{l}]=newp; Point(p203[l])={ x-rd, y-rd,z,lc};
  p204[{l}]=newp; Point(p204[l])={ x+rd, y-rd,z,lc}; rd = R_pin*s/2; 
  p205[{l}]=newp; Point(p205[l])={ x+rd, y+rd,z,lc};
  p206[{l}]=newp; Point(p206[l])={ x-rd, y+rd,z,lc};
  p207[{l}]=newp; Point(p207[l])={ x-rd, y-rd,z,lc};
  p208[{l}]=newp; Point(p208[l])={ x+rd, y-rd,z,lc};

  l201[{l}]=newl;Circle(l201[l])={p201[l],p200[l],p202[l]};
  l202[{l}]=newl;Circle(l202[l])={p202[l],p200[l],p203[l]};
  l203[{l}]=newl;Circle(l203[l])={p203[l],p200[l],p204[l]};
  l204[{l}]=newl;Circle(l204[l])={p204[l],p200[l],p201[l]};
  l205[{l}]=newl;Circle(l205[l])={p205[l],p200[l],p206[l]};
  l206[{l}]=newl;Circle(l206[l])={p206[l],p200[l],p207[l]};
  l207[{l}]=newl;Circle(l207[l])={p207[l],p200[l],p208[l]};
  l208[{l}]=newl;Circle(l208[l])={p208[l],p200[l],p205[l]};

  ll201[{l}]=newll; Line Loop(ll201[l])={l201[l],l202[l],l203[l],l204[l]};
  ll202[{l}]=newll; Line Loop(ll202[l])={l205[l],l206[l],l207[l],l208[l]};
  
  s201[{l}]=news; Plane Surface(s201[l])={ll201[l],ll202[l]};

  numv[]=Extrude {0,0,-T} {Surface{s201[l]}; Layers{nply}; Recombine;};
  
  // - - - - - - - - - - - - - - - - - - - - - - -
  // Boundary Conditions for Each Pin
  // - - - - - - - - - - - - - - - - - - - - - - -  
  v21[{i}] = newv; Physical Volume(v21[i])=numv[]; 
  //Printf( " %g   "  , numv[2]);
  If (l==0)
  numsf[]={s201[l]};		// For Boundary Conditions Front
  numsb[]={numv[0]};		// For Boundary Conditions Back
  Else
  numsf[]={numsb[]};		// For Boundary Conditions Front
  numsb[]={numv[0]};		// For Boundary Conditions Back
  EndIf
  bnd[]={numsf}; front_pin[{l}]=newreg; Physical Surface(front_pin[l])=bnd[];
  bnd[]={numsb};  back_pin[{l}]=newreg; Physical Surface(back_pin[l])=bnd[];
  bnd[]={numv[2]:numv[5]}; pin_conn[{l}]=newreg; Physical Surface(pin_conn[l])=bnd[]; 
  bnd[]={numv[6]:numv[9]}; pin_load[{l}]=newreg; Physical Surface(pin_load[l])=bnd[]; 

  EndFor
EndFor
EndIf		// EndIf for Pins


// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement - Box 
// - - - - - - - - - - - - - - - - - - - - - - -
mesh_reduce = 10; 	// Reduce
xc = 0.0;		// Center of Box w/Respect to X 
yc = 0.0;  		// Center of Box w/Respect to Y
zc = 0.0; 		// Center of Box w/Respect to Z
xL = R1*s;		// Length w/Respect to X
yL = R1+W_gauge/2;	// Length w/Respect to Y
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
mesh_radius = R_pin*1.5; 	// Radius of Cylinder
xL = 0.0; 		// Length w/Respect to X (0.0 for Z Only)
yL = 0.0;		// Length w/Respect to Y (0.0 for Z Only)
zL = T*10; 		// Length w/Respect to Z
nnHx = 2; 		// Number of Holes in X
nnHy = 3; 		// Number of Holes in Y
m=0;
For i In {0:(nnHx-1)}
  For j In {0:(nnHy-1)}

  xc = (nnHx*i-1)*L_pin/2;	// Center of Cylinder w/Respect to X 
  yc = (j-1)*W_pin;  		// Center of Cylinder w/Respect to Y
  zc = 0.0; 			// Center of Cylinder w/Respect to Z
  Field[m+2] = Cylinder; 
  Field[m+2].Radius = mesh_radius;
  Field[m+2].VIn 	= lc_S/mesh_reduce;  
  Field[m+2].VOut	= lc_S; 
  Field[m+2].XAxis 	= xL; 
  Field[m+2].XCenter	= xc; 
  Field[m+2].YAxis 	= yL;
  Field[m+2].YCenter	= yc; 
  Field[m+2].ZAxis 	= zL; 
  Field[m+2].ZCenter	= zc;
  m+=1; 

  EndFor
EndFor

Field[100] = Min; 
Field[100].FieldsList = {1:(m+1)};
Field[101] = Min; 
Field[101].FieldsList = {2:(m+1)};

Background Field = 100; // Field 1 or Field 0 - no mesh refinement

Recombine Surface "*";














