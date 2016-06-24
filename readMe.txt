
Author: Mark Flores
E-mail: markdflores@gmail.com

Objective: 
The primary objective of using GMSH is to create a discretized model of any surface or volume. However, there is a lot of difficulty in creating meshes that required a lot of coding. Many of the “.geo” files have simple geometries and some have more intensive coding. 

Updates: 6/24/2016
1) Additions: mode_I_crack.geo and wierzbicki.geo
1.1) mode_I_crack.geo and wierzbicki.geo have not been tested for composites. The code is there to test it. Only solid isotropic elastic materials have been studied. 
2) dimpleInPlate.geo
2.2) Problems
-Prism elements - It doesn’t always produce hexahedral elements 
-Each compound surface has a unique mesh. This poses a problem where node connectivity is required
-There are no periodic boundary conditions for the surface. Although the front surface and the back surface have the same curvature. The mesh doesn’t line up. Period boundary conditions is still being worked through. 

Updates: 6/23/2016
1) Deletion: fep-composites.geo, fep-solid-composites.geo, composite-hip.geo. 
1.1) Reason: holeinaplate is a combination of all of them. 

Updates: 6/22/2016
1) Read Me file creation.
2) Following .geo files include:
	angleBracket3.geo
	arcan.geo
	bimaterial2.geo
	boltedDoubleLapJoint.geo
	boltedLapJoint.geo
	bracketJoint.geo
	composite-hip.geo
	composite3.geo
	dobbone.geo
	doubleLapJoint.geo
	fep-composites.geo
	fep-solid-composites.geo
	holeinplate.geo
	sandwich2.geo
	singleLapjoint.geo
	twoAngledBrackets.geo
	unique-lapjoint.geo