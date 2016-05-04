/* 
Author: Mark Flores
Purpose: 
Create a gmsh .geo file that scripts a composite
laminate dogbone speciemn given a width, length, and thickness.
*/

// - - - - - - - - - - - - - - - - - - - - - - -
// Inputs
// - - - - - - - - - - - - - - - - - - - - - - -
// - - - - Dimensions - - - - 
W_outer = 25; 
L_outer = 150; 
T = 5; 
W_grips = W_outer; 
L_grips = 25; 
W_gauge = 10; 
L_gauge = 25; 
L_length = L_gauge+10; 
W_length = W_gauge;  
// - - - - Curvature - - - - 
R1 = W_outer/2; 
Y1 = L_outer/2-L_grips-L_length/2;
If (W_gauge != W_outer)
  R2 = (Y1^2-R1^2)/(W_outer-W_length);
EndIf
If (W_gauge == W_outer)
  R2 = (Y1^2-R1^2)/(1);
EndIf
// - - - - Composite Information - - - -
nply =2; 		
tply = T/nply;
// - - - - Mesh Information 	
lc_S = 1; 		
nep = 1; 		
n=5; 
mesh_refine_lc = 2; // lc_S/mesh_refine_lc
// - - - - - - - - - - - - - - - - - - - - - - -
// Start of Code - Edit at Own Risk
// - - - - - - - - - - - - - - - - - - - - - - -
tol=0.00001; 
T_X = tply-tol; 
For i In {0:(nply-1)}
If (i == 0)
   l=i;
   m=l;
EndIf
If (i != 0)
   l=m+1;
   m=m+1;
EndIf
// First Point of the Line
first=m;
// - - - - Upper Part - - - -
For j In {0:n}
  x = W_outer/2; 
  y = L_outer/2-(L_grips*j/n);   
  z = T/2-tply*i;
  lc = lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x, y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x, y, z, lc};	
EndFor
l=l+j-1;
// - - - - Curvature - - - - 
For j In {1:(n-1)}
  x_r1 = 0.0; 		y_r1 = L_outer/2-L_grips; 
  x_r2 = W_length/2+R2; 	y_r2 = L_length/2; 
  Theta = Atan((y_r1-y_r2)/x_r2);
  x_max = R1*Cos(Theta);
  y_max = R1*Cos(Theta);  
  x = R1*Cos(Theta*(j)/n); 
  y = (L_outer/2-L_grips) - R1*Sin(Theta*j/n);
  z = T/2-tply*i;
  lc=lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x, y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x, y, z, lc};	
EndFor
l=l+j-1;
For j In {1:(n-1)}
  x_r1 = 0.0; 		y_r1 = L_outer/2-L_grips; 
  x_r2 = W_length/2+R2; 	y_r2 = L_length/2; 
  Theta = Atan((y_r1-y_r2)/x_r2);
  x_max = R1*Cos(Theta);
  y_max = R1*Cos(Theta);  
  x = W_length/2+R2-R2*Cos(Theta*(n-j)/n); 
  y = L_length/2  + R2*Sin(Theta*(n-j)/n);
  z = T/2-tply*i;
  lc=lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x, y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x, y, z, lc};	
EndFor
l=l+j-1;
// - - - - Specimen Length Upper - - - - 
For j In {1:(n-1)}
  x = W_length/2; 
  y = L_length/2-(L_length/2-L_gauge/2)*(j-1)/n;
  z = T/2-tply*i;
  lc = lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x, y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x, y, z, lc};	
EndFor
l=l+j-1;
// - - - - Gauge Length - - - - 
For j In {0:(n)}
  x=W_gauge/2; 
  y=L_gauge/2-(L_gauge)*j/n; 
  z = T/2-tply*i;
  lc = lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x, y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x, y, z, lc};	
EndFor
l=l+j-1;
// - - - - Specimen Length Lower - - - - 
For j In {1:(n-1)}
  x = W_length/2; 
  y = L_gauge/2+(L_length/2-L_gauge/2)*(j-1)/n;
  z = T/2-tply*i;
  lc = lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x,-y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x,-y, z, lc};	
EndFor
l=l+j-1;
// - - - - Curvature - - - - 
For j In {1:(n-1)}
  x_r1 = 0.0; 		y_r1 = L_outer/2-L_grips; 
  x_r2 = W_length/2+R2; 	y_r2 = L_length/2; 
  Theta = Atan((y_r1-y_r2)/x_r2);
  x_max = R1*Cos(Theta);
  y_max = R1*Cos(Theta);  
  x = W_length/2+R2-R2*Cos(Theta*(j)/n); 
  y = L_length/2  + R2*Sin(Theta*(j)/n);
  z = T/2-tply*i;
  lc=lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x,-y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x,-y, z, lc};	
EndFor
l=l+j-1;
For j In {1:(n-1)}
  x_r1 = 0.0; 		y_r1 = L_outer/2-L_grips; 
  x_r2 = W_length/2+R2; 	y_r2 = L_length/2; 
  Theta = Atan((y_r1-y_r2)/x_r2);
  x_max = R1*Cos(Theta);
  y_max = R1*Cos(Theta);  
  x = R1*Cos(Theta*(n-j)/n); 
  y = (L_outer/2-L_grips) - R1*Sin(Theta*(n-j)/n);
  z = T/2-tply*i;
  lc=lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x,-y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x,-y, z, lc};	
EndFor
l=l+j-1;
// - - - - Lower Part - - - -
For j In {0:n}
  x = W_outer/2; 
  y = L_outer/2-L_grips+(L_grips*j/n);   
  z = T/2-tply*i;
  lc = lc_S;
  p01[{l+j}]=newp; Point(p01[l+j]) = { x,-y, z, lc};
  p02[{l+j}]=newp; Point(p02[l+j]) = {-x,-y, z, lc};	
EndFor
l=l+j-1;
m = l;
// - - - - Looping the Points for the Line - - - -
If (i==0)
   x1 = 0;
   x2 = m; 
   x3 = m; 
   p1[]={};
   p2[]={};
EndIf 
If (i!=0)
   p1[]={};
   p2[]={};
   x1 = m-x3;
   x2 = m; 
EndIf 
For j In {x1:x2}
  p1[] += {p01[j]};
  p2[] += {p02[j]};
EndFor
// - - - - Last Point of the Line - - - -
last=l;
// - - - - Creating Lines - - - 
l01[{i}]=newl;BSpline(l01[i]) = {p1[]};
l02[{i}]=newl; Line(l02[i]) = {p01[first],p02[first]};
l03[{i}]=newl;BSpline(l03[i]) = {p2[]};
l04[{i}]=newl; Line(l04[i]) = {p01[last],p02[last]};
// - - - - Line Loop - - - -
ll01[{i}]=newll; Line Loop(ll01[i]) = {-l01[i],l02[i],l03[i],-l04[i]}; 
// - - - - Surface - - - -
s01[{i}]=news; Ruled Surface(s01[i]) = {ll01[i]};
// - - - - Volume - - - -
Extrude {0,0,-T_X} {Surface{s01[i]}; Layers{nep}; Recombine;}
EndFor

// - - - - - - - - - - - - - - - - - - - - - - -
// Mesh Refinement
// - - - - - - - - - - - - - - - - - - - - - - -
Field[1] = Box; 
Field[1].VIn = lc_S/mesh_refine_lc; 
Field[1].VOut= lc; 
Field[1].XMax= W_outer/2; 
Field[1].XMin=-W_outer/2;  
Field[1].YMax= L_length/2; 
Field[1].YMin=-L_length/2; 
Field[1].ZMax= 20; 
Field[1].ZMin=-20; 

Background Field = 1; // Field 1 or Field 0 - no mesh refinement

Recombine Surface "*";














