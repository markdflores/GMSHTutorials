/* 
Author: Mark Flores
Purpose: Create a gmsh .geo file that scripts a composite
laminate given an angle, width, length, thickness, and number of plies.
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
T = 4; 		// mm
R = 5; 			// mm Radius of angle… 
nply =5; 		// integer
tply = T/nply; 		// mm 
lc_S = 2; 		// element size = 1 (xy)
nep =1; 		// number of elements in z for each ply
lc_W = 51; 		// Number of elements = lc_W-1
lc_L = 101; 
lc_ply = 2; 
bias = 15.0; 
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
s=Sqrt(2);
A=Sqrt(2)/2;
B=Sqrt(3)/3;
lc=lc_S;
z = W/2; 
n=20;
angle_deg = 90/n; 
angle_rad = angle_deg*Pi/180; 
For i In {0:nply}
  If(i == 0)
     p01[i]=newp; Point(p01[i]) = {-R, L,  z, lc};
     p02[i]=newp; Point(p02[i]) = {-R, L, -z, lc}; 
     l=i;
  EndIf
  If(i != 0)
     p01[1+l]=newp; Point(p01[1+l]) = {-R-tply*i, L,  z, lc};
     p02[1+l]=newp; Point(p02[1+l]) = {-R-tply*i, L, -z, lc};     
     l=1+l;
  EndIf
  For j In {1:n}
     p01[{j+l}]=newp; Point(p01[j+l]) = {-R-tply*i, L-L*j/n,  z, lc};
     p02[{j+l}]=newp; Point(p02[j+l]) = {-R-tply*i, L-L*j/n, -z, lc};
  EndFor
  l=j+l-1; 
  For j In {1:n}
     p01[{j+l}]=newp; Point(p01[j+l]) = {-(R+tply*i)*Cos(angle_rad*j), -(R+tply*i)*Sin(angle_rad*j), z,lc};
     p02[{j+l}]=newp; Point(p02[j+l]) = {-(R+tply*i)*Cos(angle_rad*j), -(R+tply*i)*Sin(angle_rad*j),-z,lc};
  EndFor
  l=j+l-1;  
  For j In {1:n}
     p01[{j+l}]=newp; Point(p01[j+l]) = {L*j/n, -R-tply*i,  z, lc};
     p02[{j+l}]=newp; Point(p02[j+l]) = {L*j/n, -R-tply*i, -z, lc};
  EndFor
  l=j+l-1;
  If (i==0)
     m=j+l;
  EndIf
EndFor  

For i In {0:nply}
  p1[]={};
  p3[]={};
  If(i == 0)
     l=i;
  EndIf
  If(i != 0)   
     l=1+l;
  EndIf
  first=l;
  For j In {0:3*n}
     p1[] += {p01[j+l]};
     p3[] += {p02[j+l]};
  EndFor
  l=j+l-1;
  last=l;
  vp01[{i}] = {p01[first]};
  vp02[{i}] = {p02[first]};
  vp03[{i}] = {p02[last]};
  vp04[{i}] = {p01[last]};
  l01[{i}]=newl; BSpline(l01[i]) = {p1[]};
  l02[{i}]=newl; Line(l02[i]) = {p01[first],p02[first]};
  l03[{i}]=newl; BSpline(l03[i]) = {p3[]};
  l04[{i}]=newl; Line(l04[i]) = {p01[last],p02[last]};
EndFor
For i In {0:(nply-1)}
  lv1[{i}]=newl; Line(lv1[i]) = {vp01[i],vp01[i+1]};
  lv2[{i}]=newl; Line(lv2[i]) = {vp02[i],vp02[i+1]};
  lv3[{i}]=newl; Line(lv3[i]) = {vp03[i],vp03[i+1]};
  lv4[{i}]=newl; Line(lv4[i]) = {vp04[i],vp04[i+1]};
EndFor
For i In {0:nply}
  // - - - - Line Loops - - - -
  ll1[{i}]=newll; Line Loops(ll1[i]) = {-l01[i],l02[i],l03[i],-l04[i]};
  s1[{i}]=news; Ruled Surface(s1[i])=ll1[i];
  If (i != nply)
  ll2[{i}]=newll; Line Loops(ll2[i]) = {-lv1[i],l01[i],lv4[i],-l01[i+1]};
  ll3[{i}]=newll; Line Loops(ll3[i]) = {-lv2[i],l03[i],lv3[i],-l03[i+1]};
  ll4[{i}]=newll; Line Loops(ll4[i]) = {-lv1[i],l02[i],lv2[i],-l02[i+1]};
  ll5[{i}]=newll; Line Loops(ll5[i]) = {-lv3[i],-l04[i],lv4[i],l04[i+1]};
  s2[{i}]=news; Ruled Surface(s2[i])=ll2[i];
  s3[{i}]=news; Ruled Surface(s3[i])=ll3[i];
  s4[{i}]=news; Ruled Surface(s4[i])=ll4[i];
  s5[{i}]=news; Ruled Surface(s5[i])=ll5[i];
  EndIf
EndFor
For i In {0:(nply-1)}
  sl1[{i}]=newreg; Surface Loop(sl1[i]) = { s1[i],s2[i],s3[i],s4[i],s5[i],s1[i+1]};
  v1[{i}]=newv; Volume(v1[i]) = {sl1[i]};
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Structured Mesh
// - - - - - - - - - - - - - - - - - - - - - - -
Transfinite Line {l01[],l03[]} = lc_L Using Bump bias; 	
Transfinite Line {l02[], l04[]} = lc_W; 	
Transfinite Line {lv1[],lv2[],lv3[],lv4[]} = lc_ply; 
Transfinite Surface "*";
Transfinite Volume "*";

Recombine Surface "*";














