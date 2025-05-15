clc, clear, close all;

%cell data types can store different types of data in the same object to
%declare it we need to use the curly brackets instead of the square the
%logic is the same of the matrices and array

x = {1, 2, 3, 4; 
     'a', 'b', 'c', 'd';
     "my pee", "my poo", "my weenie", "Lebroooon";
      false, false, false, true;
      eye(4,4), zeros(1,4), ones(3,3), eye(11,11)};

%to access one of the values we use the curly brackets instead of the
%circular

v1 = x{1};
v2 = x{3,4};

%we can combine previous defintion to get the element in the matrices in
%the cell like it follows where we have in sequence the access parentheses

v3 = x{5,1}(2:2:end,1:3:end);

x