/* 
Author: Mark Flores
Purpose: Creates a Bi-Material substrate with any angle. 

Inputs: 
W	- Width
L	- Length
T	- Thickness
Theta 	- Angle in degres
nply	- Number of Plies/Lamina
tply	- Thickness of a Single Ply/Lamina
Mesh: 
lc_# 	- Characteristic Length of Edge/Point

*/

// - - - - - - - - - - - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - - - - - - - - - - - -
W 	= 10; 		
L 	= 30; 		
T 	= 10; 		
Theta 	= 0; 		
nply =1; 	
tply = T/nply; 	
lc_S = 1; 	

If (nply==1)
  nep = 5;
  nep_A = nep; 	
EndIf
If (nply!=1)
  nep = 1; 
  nep_A = nply;	
EndIf
// - - - - - - - - - - - - - - - - - - - - - - -
// Is There an Adhesive Layer?
// - - - - - - - - - - - - - - - - - - - - - - -
Adhesion = 1; // 0) No Adhesive Layer 1) Adhesive Layer
If (Adhesion == 0)
  tol = 0.01; 
EndIf
If (Adhesion == 1)
  tol = 0.1;  
EndIf
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
angle = Theta*Pi/180; 
For i In {0:(nply-1)}
  // - - - - - LEFT SIDE - - - - - 
  If (Adhesion == 0)
    x1=L/2; y1=W/2;
    x2=y1*Tan(angle)+tol; y2=y1; 
    z=T/2-tply*i; 
    lc=lc_S;
    p01[{i}]=newp; Point(p01[i]) = {-x1, y1, z, lc};
    p02[{i}]=newp; Point(p02[i]) = { x2, y2, z, lc};
    p03[{i}]=newp; Point(p03[i]) = {-x2,-y2, z, lc};
    p04[{i}]=newp; Point(p04[i]) = {-x1,-y1, z, lc};
  EndIf
  If (Adhesion == 1)
    x1=L/2; y1=W/2;    
    x2=y1*Tan(angle); y2=y1; 
    z=T/2-tply*i; 
    lc=lc_S;
    p01[{i}]=newp; Point(p01[i]) = {-x1,		 y1, z, lc};
    p02[{i}]=newp; Point(p02[i]) = { x2-tol/2,	 y2, z, lc};
    p03[{i}]=newp; Point(p03[i]) = {-x2-tol/2,	-y2, z, lc};
    p04[{i}]=newp; Point(p04[i]) = {-x1,		-y1, z, lc};
  EndIf
  l01[{i}]=newl;  Line(l01[i]) = {p01[i],p02[i]};
  l02[{i}]=newl;  Line(l02[i]) = {p02[i],p03[i]};
  l03[{i}]=newl;  Line(l03[i]) = {p03[i],p04[i]};
  l04[{i}]=newl;  Line(l04[i]) = {p04[i],p01[i]};
  ll01[{i}]=newll; Line Loop(ll01[i]) = {l01[i],l02[i],l03[i],l04[i]}; 
  s01[{i}]=news; Plane Surface(s01[i]) = {ll01[i]};
  Extrude {0,0,-tply} {Surface{s01[i]}; Layers{nep}; Recombine;}
  // - - - - - RIGHT SIDE - - - - - 
  If (Adhesion == 0)
    x1=L/2; y1=W/2;
    x2=y1*Tan(angle)+tol; y2=y1; 
    z=T/2-tply*i; 
    lc=lc_S;
    p11[{i}]=newp; Point(p11[i]) = { x2, y2, z, lc};
    p12[{i}]=newp; Point(p12[i]) = { x1, y1, z, lc};	
    p13[{i}]=newp; Point(p13[i]) = { x1,-y1, z, lc};	
    p14[{i}]=newp; Point(p14[i]) = {-x2,-y2, z, lc};
  EndIf 
  If (Adhesion == 1)
    x1=L/2; y1=W/2;
    x2=y1*Tan(angle); y2=y1; 
    z=T/2-tply*i; 
    lc=lc_S;
    p11[{i}]=newp; Point(p11[i]) = { x2+tol/2,	 y2, z, lc};
    p12[{i}]=newp; Point(p12[i]) = { x1,		 y1, z, lc};	
    p13[{i}]=newp; Point(p13[i]) = { x1,		-y1, z, lc};	
    p14[{i}]=newp; Point(p14[i]) = {-x2+tol/2,	-y1, z, lc};
  EndIf
  l11[{i}]=newl;  Line(l11[i]) = {p11[i],p12[i]};
  l12[{i}]=newl;  Line(l12[i]) = {p12[i],p13[i]};
  l13[{i}]=newl;  Line(l13[i]) = {p13[i],p14[i]};
  l14[{i}]=newl;  Line(l14[i]) = {p14[i],p11[i]};
  ll11[{i}]=newll; Line Loop(ll11[i]) = {l11[i],l12[i],l13[i],l14[i]}; 
  s11[{i}]=news; Plane Surface(s11[i]) = {ll11[i]};
  Extrude {0,0,-tply} {Surface{s11[i]}; Layers{nep}; Recombine;}
  If (Adhesion == 1)
    If (i == 0) 
      // - - - - - ADHESIVE SIDE - - - - - 
      x1=L/2; y1=W/2;
      x2=y1*Tan(angle); y2=y1; 
      z=T/2; 
      lc_A=lc_S/10;
      n=1000;
      p21[{i}]=newp; Point(p21[i]) = { x2-tol/2, 	 y2, z, lc_A};
      p22[{i}]=newp; Point(p22[i]) = { x2+tol/2,	 y2, z, lc_A};	
      p23[{i}]=newp; Point(p23[i]) = {-x2+tol/2,	-y2, z, lc_A};	
      p24[{i}]=newp; Point(p24[i]) = {-x2-tol/2,	-y2, z, lc_A};	
      l21[{i}]=newl;  Line(l21[i]) = {p21[i],p22[i]};
      l22[{i}]=newl;  Line(l22[i]) = {p22[i],p23[i]};
      l23[{i}]=newl;  Line(l23[i]) = {p23[i],p24[i]};
      l24[{i}]=newl;  Line(l24[i]) = {p24[i],p21[i]};
      ll21[{i}]=newll; Line Loop(ll21[i]) = {l21[i],l22[i],l23[i],l24[i]}; 
      s21[{i}]=news; Plane Surface(s21[i]) = {ll21[i]};
      Extrude {0,0,-T} {Surface{s21[i]}; Layers{nep_A}; Recombine;}
    EndIf
  EndIf
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Structured Mesh
// - - - - - - - - - - - - - - - - - - - - - - -
If (Adhesion == 1) 
  Transfinite Line {l21, l23} = 3; 	// 20 elements
  Transfinite Surface {s21}; 
EndIf
// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - - - - - - - - - - - -
Field[1] = Box; 
Field[1].VIn = lc_S/4; 
Field[1].VOut= lc; 
Field[1].XMax= x2+5; 
Field[1].XMin=-x2-5;  
Field[1].YMax= x2+5; 
Field[1].YMin=-x2-5; 
Field[1].ZMax= 20; 
Field[1].ZMin=-20; 

Background Field = 1; // Field 1 or Field 0 - no mesh refinement

Recombine Surface "*";














