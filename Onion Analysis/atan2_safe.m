function alpha=atan2_safe(y,x, small_criterion)
%% A Safe Version of ATAN2 
%  To perform the same function as Matlab built-in function ATAN2 but 
%  safely guarded against  erroneous results when the inputs are very 
%  small  (near to a machine zero). More explanations can be seen in the
%  accompanied file atan2_safe.html.
%
%  Inputs and Output:
%
%  The first two inputs and the output are  the same as those for the 
%  MATLAB  build-in function. The third optional input is a 
%  criterion for zeroing out small elements in y and x; its default value 
%  is the  MATLAB internal EPS. Calling ATAN2_safe with 0 for the 
%  small_criterion is the same to calling ATAN2.
%

%% Explanations:
%
%  Due to the round off errors in the numerical calculations, the two 
%  inputs to  ATAN2,  Y and X,  had better  be thought as
%
%    x=x_exact + (or -) rand*eps;
%    y=y_exact + (or -) rand*eps;
% 
%  When the theoretically expected values x_exact and y_exact are 
%  far  above the machine accuracy, ATAN2 will give you a good 
%  answer,  insensitive to the small unpredictable round off errors. 
%  On the other hand,  when one or both of  the theoretical values is 
%  zero, ATAN2 becomes very sensitive to the  round off errors and 
%  will give an erroneous  result. Consider the case where 
%  both  x_exact and y_exact are zero,  then the call to ATAN2 is 
%  equivalent to  the following random experiment
%
%   x=(rand-0.5)/0.5*eps; 
%   y=(rand-0.5)/0.5*eps; 
%   theta=atan2(y, x);
%
%   Now theta becomes a random number ranging  all over between
%  -pi and pi.  (This should apply to ATAN as well). 
%
%  Since ATAN2(0,0) will give an exact zero, and since the round-off 
%  errors due  to the machine accuracy cannot be meaningfully 
%  distinguished  from the true zero, we had better clear off (zero out)  
%  the small round off errors before we call ATAN2. To relieve you 
%  from  the cleaning burden every  time when you need to call ATAN2, 
%  ATAN2_safe automates the cleaning and the calling two steps 
%  for you.
%
%% Example:
%
%  
%  The following example will illustrate how an unacceptable result 
%  arrives in a practical calculation.
%
%     First, prepare a simple rotation matrix, 
%     
%       clear
%       beta = -1/18*pi;
%       R=[cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];   
%      
%  which has a property that  R'*R==eye(3) is true (within the machine 
%  accuracy of course).
%       
%   Then, consider a trip which starts from the North Pole (0, pi/2), 
%   and ends at (t2, p2), as performed by the following steps:
%     
%      t1=0; p1=pi/2;                            %step 0
%      [x1 y1 z1]=sph2cart(t1, p1, 1);           %step 1a
%      v1=[x1 y1 z1].';                          %step 2a  
%      v2=R*v1;                                  %step 3a
%      x2=v2(1); y2=v2(2); z2=v2(3);             %step 4a
%      [t2 p2 r2]=cart2sph(x2, y2, z2);          %step 5a
%  
%   Now consider to go back home.  We can reverse the above
%   operations step-by-step, since each of the operations is 
%   reversible mathematically.
%
%        [x2 y2 z2]=sph2cart(t2, p2, r2);        % step 5b
%        v2=[x2 y2 z2].';                        % step 4b
%        v1=R'*v2;                               % step 3b
%        x1=v1(1); y1=v1(2); z1=v1(3);           % step 2b
%        [t1 p1 r1]=cart2sph(x1, y1, z1);        % step 1b
%         
%  Now you will find that t1=0.1893 radians (=10.84 deg), whereas its 
%  original  value is 0. The error is too  big to accept. If this 
%  round-trip was for the Santa-Clause, he would have a hard time to 
%  find the front  entrance of his house  when he comes back from his 
%  Christmas  gifts giving trip.
%
%  The source of the problem is the ATAN2 used inside of cart2sph, 
%  the code of which is copied as follows, 
%
%  function [az,elev,r] = cart2sph(x,y,z)
% 
%  hypotxy = hypot(x,y);
%  r = hypot(hypotxy,z);
%  elev = atan2(z,hypotxy);
%  az = atan2(y,x);
% 
%  In the step 1b, the input of x1 and y1 have become "fuzzy zeros",  
%  x1=1.1102e-016, y1= 2.1266e-017,  they cannot recover 
%  the clear zero (the integer zero) after all those numerical 
%  operations. When  cart2sph passes the fuzzy zeros to 
%  atan2 inside,  the erroneous angle for t1 arrives. 
%
%  If you use ATAN2_safe instead, 
%  t1=atan2_safe(y1, x1); disp(t1)
%  you will see t1=0.
%
% _Zhigang Xu, June 7 2008, xuz@dfo-mpo.gc.ca_
%% A 4-line code 
if nargin < 3, small_criterion=eps; end
x=zero_out_smalls(x, small_criterion);
y=zero_out_smalls(y, small_criterion);
alpha=atan2(y,x);
%  The function zero_out_smalls is included in the same zip file 
%  for this submission.  It can be also downloaded separately 
%  from the Mathworks file exchange center.

