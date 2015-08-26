function in_out = inside_Tri( pt, a, b )
 
%   This function determines whether the point with
%   coordinates pt is inside or outside of the triangle
%   given by the three vertex points with coordinates
%   (a(1),b(1)), (a(2),b(2)), and (a(3),b(3)).
%   The method used is to compute the barycentric coordinates
%   of the point relative to the three vertex points.  The array
%   coord contains the barycentric coordinates.  If all of the 
%   barycentric coordinates are nonnegative, then the point is
%   said to be inside the triangle.
%   If in_out is 1, the point is inside,
%   if in_out is 0, the point is outside,and
%   if in_out is 0.5, the point is on the edge.
 
x = pt(1) ;
y = pt(2) ;
 
A = [ 1, 1, 1 ; a ; b ] ;  % Set up the matrix for the system.
 
coord = A\[1 ; x ; y ] ;   % Solve the linear system.
 
if all( coord > 0 )     % If all barycentric coordinates are
    in_out = 1 ;        % non-negative, the point is inside.
elseif any( coord < 0 ) % If any coordinate is negative,
    in_out = 0 ;        % the point is outside.
else                    % Otherwise,
    in_out = 0.5 ;      % it is on the boundary.
end