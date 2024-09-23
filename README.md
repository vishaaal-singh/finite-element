# finiteelement

A structural Finite Element Method MATLAB program taking in standard format input and boundary_conditions files. Output is the displacement vector.

Version 1.0

## 1. Prepare the input.txt file

The structure of the input file is as follows:

  a. There are 15 columns separated by spaces and (No. of Elements + 1) rows.
  
  b. The first two columns of the first row have the number of elements (NEL) and the no of nodes (No_Nodes) followed by thirteen zeros
  
  c. Every row that follows has the following format:

   1. Element Number (Elno)
   2. The smaller node number (i)
   3. The bigger node number (j)
   4. x component of the consistent nodal force vector on the first node (Fxi)
   5. y component of the consistent nodal force vector on the first node (Fyi)
   6. Moment on the first node (NOT USED BY THE PROGRAM in v1.0) (Mi)
   7. x component of the consistent nodal force vector on the second node (Fxj)
   8. y component of the consistent nodal force vector on the second node (Fyj)
   9. Moment on the second node (NOT USED BY THE PROGRAM in v1.0) (Mj)
   10. Elastic modulus of the element (E)
   11. Cross-sectional area of the element (A)
   12. Moment of Inertia of the bar element (NOT USED BY THE PROGRAM in v1.0) (I)
   13. Length of the element (L)
   14. Height of the element (NOT USED BY THE PROGRAM in v1.0)(h)
   15. Orientation of the element (α)

```
NEL No_Nodes 0 0 0 0 0 0 0 0 0 0 0 0 0
ELno i j Fxi Fyi Mi Fxj Fyj Mj E A I L h α
…
…
```

## 2. Prepare the input_geometry.txt file

**This file isn't used in in v1.0**
The structure of the input file is as follows:

  a. There are 7 columns separated by spaces and (No. of Elements + 1) rows.
  
  b. The first two columns of the first row have the number of elements (NEL) and the no of nodes (No_Nodes) followed by five zeros
  
  c. Every row that follows has the following format:

   1. Element Number (Elno)
   2. The smaller node number (i)
   3. The bigger node number (j)
   4. global x-coordinate of first node (xi)
   5. global y-coordinate of first node (yi)
   6. global x-coordinate of second node (xj)
   7. global y-coordinate of second node (yj)
   
```
NEL NNodes 0 0 0 0 0
Elno i j xi yi xj yj
…
…
```

## 3. Prepare the boundary_conditions.txt file

The structure of the input file is as follows:

  a. There are 7 columns separated by spaces and (No. of Boundary conditions + 1) rows.
  
  b. The first two columns of the first row have the number of boundary conditions (NBC) followed by two zeros
  
  c. Every row that follows has the following format:

   1. Global Node Number (Node)
   2. The degree of freedom that is being constrained: 1 for x-direction, 2 for y-direction and 3 for angle (angle isn't used in v1.0) (BC_DOF)
   3. The magnitude of the constraint (BC_magnitude)
   
```
NBC 0 0
Node BC_dof BC_magnitude
… … …
```

## 4. Run the program in MATLAB

Make sure all the txt files are in the same folder as the `fem.m` file and run the `fem.m` matlab program
