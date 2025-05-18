clc, clear, close all;


%create an array of all ones ones(rows, colums)
a = ones(4,3); 


%create an array of all zeros zeros(rows, colums)
b = zeros(1,6);


%create an identity matrix in english an eye matrix eye(rows, colums)
c = eye(3,3);


%create a random value matrix with rand(rows, column) with seeding
d = rand(6,6);


%to perform operations let's create tow random matrices !!with same sizes!!
x1 = rand(3,2);
x2 = rand(3,2);


sum = x1 + x2;
difference = x1 - x2;


%this is an algebric operation so we need that the #row = #col therefore 
%we need to take the transpose (') of the inner one
alg_product = x1 * x2';


%if we instead perform a arithmeic operation we prewrite (.) before the
%operator in this case we don't need to transpose
ari_product = x1 .* x2;


%we need to reason the same for the division
%alg_division = x1 / x2'; this will not function because we need square
%the arithmetic however will work
%matrices one way to obtain this result would be by increasing the
%dimension artifically for the matrix,let' s ignore it for now and create
%two square matrices
x3 = rand(4,4);
x4 = rand(4,4);

alg_division = x3 / x4;
ari_division = x3 ./ x4;


%if we want to get thge inverse of a matrix we can do inv(mat)
%we do this in case we want to get a certain product
x5 = rand(6,6);
x6 = rand(6,1);

inv_x5  = inv(x5);

product_with_inverse = inv_x5 * x6; %quicker doing a division that this


%if we want to get the determinant we can call det(matrix)
x7 = rand(9,9);
det_x7 = det(x7);


%if we want to perform a arithmetic power elevation we can do it by (.^)
%from the power elevation we can also perform the square root for example
%by doing (.^0.5)  etc
power_x7 = x7 .^ 3;