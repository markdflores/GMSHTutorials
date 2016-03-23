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
	0
	|
	|
	|   . (x,y) center of curvature
	|	
	| - - - - - 0

*/
// - - - - - - - - - - - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - - - - - - - - - - - -
W = 20; 		
L = 50; 		
T = 4; 			
R = 1; 			
nply =5; 		
tply = T/nply; 		
x_R = T+R;		// Center of Curvature 
y_R = T+R;		// Center of Curvature
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
// Right

For i In {0:nply}
  If(i == 0)
     p01[i]=newp; Point(p01[i]) = {T, L,  z, lc};
     p02[i]=newp; Point(p02[i]) = {T, L, -z, lc}; 
     l=i;
  EndIf
  If(i != 0)
     p01[1+l]=newp; Point(p01[1+l]) = {T-tply*i, L,  z, lc};
     p02[1+l]=newp; Point(p02[1+l]) = {T-tply*i, L, -z, lc};     
     l=1+l;
  EndIf
  For j In {1:n}
     p01[{j+l}]=newp; Point(p01[j+l]) = {T-tply*i, L-(L-2*R-(T-R))*j/n,  z, lc};
     p02[{j+l}]=newp; Point(p02[j+l]) = {T-tply*i, L-(L-2*R-(T-R))*j/n, -z, lc};
  EndFor
  l=j+l-1;
  For j In {1:n}
     p01[{j+l}]=newp; Point(p01[j+l]) = {-(R+tply*i)*Cos(angle_rad*j)+x_R,-(R+tply*i)*Sin(angle_rad*j)+y_R, z,lc};
     p02[{j+l}]=newp; Point(p02[j+l]) = {-(R+tply*i)*Cos(angle_rad*j)+x_R,-(R+tply*i)*Sin(angle_rad*j)+y_R,-z,lc};
  EndFor
  l=j+l-1;  
  For j In {1:n}
     p01[{j+l}]=newp; Point(p01[j+l]) = {R+T+(L-2*R-(T-R))*j/n, T-tply*i,  z, lc};
     p02[{j+l}]=newp; Point(p02[j+l]) = {R+T+(L-2*R-(T-R))*j/n, T-tply*i, -z, lc};
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
  lv01[{i}]=newl; Line(lv01[i]) = {vp01[i],vp01[i+1]};
  lv02[{i}]=newl; Line(lv02[i]) = {vp02[i],vp02[i+1]};
  lv03[{i}]=newl; Line(lv03[i]) = {vp03[i],vp03[i+1]};
  lv04[{i}]=newl; Line(lv04[i]) = {vp04[i],vp04[i+1]};
EndFor
For i In {0:nply}
  // - - - - Line Loops - - - -
  ll01[{i}]=newll; Line Loops(ll01[i]) = {-l01[i],l02[i],l03[i],-l04[i]};
  s01[{i}]=news; Ruled Surface(s01[i])=ll01[i];
  If (i != nply)
    ll02[{i}]=newll; Line Loops(ll02[i]) = {-lv01[i], l01[i], lv04[i],-l01[i+1]};
    ll03[{i}]=newll; Line Loops(ll03[i]) = {-lv02[i], l03[i], lv03[i],-l03[i+1]};
    ll04[{i}]=newll; Line Loops(ll04[i]) = {-lv01[i], l02[i], lv02[i],-l02[i+1]};
    ll05[{i}]=newll; Line Loops(ll05[i]) = {-lv03[i],-l04[i], lv04[i],l04[i+1]};
    s02[{i}]=news; Ruled Surface(s02[i])=ll02[i];
    s03[{i}]=news; Ruled Surface(s03[i])=ll03[i];
    s04[{i}]=news; Ruled Surface(s04[i])=ll04[i];
    s05[{i}]=news; Ruled Surface(s05[i])=ll05[i];
  EndIf
EndFor
For i In {0:(nply-1)}
  sl01[{i}]=newreg; Surface Loop(sl01[i]) = { s01[i],s02[i],s03[i],s04[i],s05[i],s01[i+1]};
  v01[{i}]=newv; Volume(v01[i]) = {sl01[i]};
EndFor

// Left
tol=0.01;
For i In {0:nply}
  If(i == 0)
     p21[i]=newp; Point(p21[i]) = {-T-tol, L,  z, lc};
     p22[i]=newp; Point(p22[i]) = {-T-tol, L, -z, lc}; 
     l=i;
  EndIf
  If(i != 0)
     p21[1+l]=newp; Point(p21[1+l]) = {-T+tply*i-tol, L,  z, lc};
     p22[1+l]=newp; Point(p22[1+l]) = {-T+tply*i-tol, L, -z, lc};     
     l=1+l;
  EndIf
  For j In {1:n}
     p21[{j+l}]=newp; Point(p21[j+l]) = {-T+tply*i-tol, L-(L-2*R-(T-R))*j/n,  z, lc};
     p22[{j+l}]=newp; Point(p22[j+l]) = {-T+tply*i-tol, L-(L-2*R-(T-R))*j/n, -z, lc};
  EndFor
  l=j+l-1;
  For j In {1:n}
     p21[{j+l}]=newp; Point(p21[j+l]) = {(R+tply*i)*Cos(angle_rad*j)-x_R-tol,-(R+tply*i)*Sin(angle_rad*j)+y_R-tol, z,lc};
     p22[{j+l}]=newp; Point(p22[j+l]) = {(R+tply*i)*Cos(angle_rad*j)-x_R-tol,-(R+tply*i)*Sin(angle_rad*j)+y_R-tol,-z,lc};
  EndFor
  l=j+l-1;  
  For j In {1:n}
     p21[{j+l}]=newp; Point(p21[j+l]) = {-R-T-(L-2*R-(T-R))*j/n, T-tply*i+tol,  z, lc};
     p22[{j+l}]=newp; Point(p22[j+l]) = {-R-T-(L-2*R-(T-R))*j/n, T-tply*i+tol, -z, lc};
  EndFor
  l=j+l-1;
  If (i==0)
     m=j+l;
  EndIf
EndFor  

For i In {0:nply}
  p31[]={};
  p33[]={};
  If(i == 0)
     l=i;
  EndIf
  If(i != 0)   
     l=1+l;
  EndIf
  first=l;
  For j In {0:3*n}
     p31[] += {p21[j+l]};
     p33[] += {p22[j+l]};
  EndFor
  l=j+l-1;
  last=l;
  vp21[{i}] = {p21[first]};
  vp22[{i}] = {p22[first]};
  vp23[{i}] = {p22[last]};
  vp24[{i}] = {p21[last]};
  l21[{i}]=newl; BSpline(l21[i]) = {p31[]};
  l22[{i}]=newl; Line(l22[i]) = {p21[first],p22[first]};
  l23[{i}]=newl; BSpline(l23[i]) = {p33[]};
  l24[{i}]=newl; Line(l24[i]) = {p21[last],p22[last]};
EndFor

For i In {0:(nply-1)}
  lv21[{i}]=newl; Line(lv21[i]) = {vp21[i],vp21[i+1]};
  lv22[{i}]=newl; Line(lv22[i]) = {vp22[i],vp22[i+1]};
  lv23[{i}]=newl; Line(lv23[i]) = {vp23[i],vp23[i+1]};
  lv24[{i}]=newl; Line(lv24[i]) = {vp24[i],vp24[i+1]};
EndFor
For i In {0:nply}
  // - - - - Line Loops - - - -
  ll21[{i}]=newll; Line Loops(ll21[i]) = {-l21[i],l22[i],l23[i],-l24[i]};
  s21[{i}]=news; Ruled Surface(s21[i])=ll21[i];
  If (i != nply)
    ll22[{i}]=newll; Line Loops(ll22[i]) = {-lv21[i], l21[i],lv24[i],-l21[i+1]};
    ll23[{i}]=newll; Line Loops(ll23[i]) = {-lv22[i], l23[i],lv23[i],-l23[i+1]};
    ll24[{i}]=newll; Line Loops(ll24[i]) = {-lv21[i], l22[i],lv22[i],-l22[i+1]};
    ll25[{i}]=newll; Line Loops(ll25[i]) = {-lv23[i],-l24[i],lv24[i], l24[i+1]};
    s22[{i}]=news; Ruled Surface(s22[i])=ll22[i];
    s23[{i}]=news; Ruled Surface(s23[i])=ll23[i];
    s24[{i}]=news; Ruled Surface(s24[i])=ll24[i];
    s25[{i}]=news; Ruled Surface(s25[i])=ll25[i];
  EndIf
EndFor
For i In {0:(nply-1)}
  sl21[{i}]=newreg; Surface Loop(sl21[i]) = { s21[i],s22[i],s23[i],s24[i],s25[i],s21[i+1]};
  v21[{i}]=newv; Volume(v21[i]) = {sl21[i]};
EndFor









// - - - - - - - - - - - - - - - - - - - - - - -
// Structured Mesh
// - - - - - - - - - - - - - - - - - - - - - - -
Transfinite Line {l01[],l03[]} = lc_L Using Bump bias; 	
Transfinite Line {l02[], l04[]} = lc_W; 	
Transfinite Line {lv01[],lv02[],lv03[],lv04[]} = lc_ply; 
Transfinite Line {l21[],l23[]} = lc_L Using Bump bias; 	
Transfinite Line {l22[], l24[]} = lc_W; 	
Transfinite Line {lv21[],lv22[],lv23[],lv24[]} = lc_ply; 
Transfinite Surface "*";
Transfinite Volume "*";

Recombine Surface "*";














