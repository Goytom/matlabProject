% Solution of the parachutes problem
%Given mass values
m1 = 70;
m2 = 60;
m3 = 40;
%Given speed and gravity values
v = 5;
g = 9.8;
%Drag constants
d1 = 10;
d2 = 14;
d3 = 17;

%Solving the system of linear equations
A = [m1 1 0
    m2 -1 1
    m3 0 -1];     % A is the matrix of coefficients
b = [m1*g - d1*v
    m2*g - d2*v
    m3*g - d3*v]; % b is column vector of constants
X = A\b;          % X is column vector of solution values 
fprintf('Acceleration h is:          %f\n', X(1))
fprintf('The value of force T is:   %f\n', X(2))
fprintf('The value of force R is:    %f\n', X(3))