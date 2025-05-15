clc, clear, close all;


%rank 1 tensor equivalent to say vector we can useparate element with
%spaces or commas it really doesn't matter.
%this is a row vector
x = [1 2 3 4 5];


y = [1, 2, 3, 4];


%to create a column vector we can separate each row with a ;
cx = [1; 2; 3; 4; 5;];


%or we can use the transpose operator (')
cy = y';


%we can combine this notion to get our matrices be careful we always need
%to have the number of rows and column to be equal 
m = [1, 2, 3;
     4, 5, 6; 
     7, 8, 9];


%to acces the value inside our matrices/array we can do name(position)
l = m(1,3);


%if i want to get all the data from a certain point to another i need to
%write as it follows name(index, start:until) where the first is the row
%and the second the column spans
s = m(1,2:end);
a = x(1,3:4);


%for example we can also jump every two steps in this case 
% name(row:jumps:until, column:jumps:until) 
r = m(1,1:2:end);
c = m(1:2:end,1);
w = m(1:2:end,2:2:end);


%it's also possible to pass an array to the position and get the relative
%objects
newm = [1, 2, 3, 4, 5, 6, 7;
        3, 2, 23, 4, 5, 6, 7;
        1, 2, 3, 4, 45, 6, 7;
        12, 23 3, 4, 55, 6, 7;
        16, 28, 3, 4, 5, 6, 7;
        1, 21, 43, 43, 5, 676, 7;
        1, 23, 3, 4, 5,56, 7];


%index that follows the usual property of array
ind = [1:2,6:7];


%classical exit
exit = newm(ind,ind);

%to get everything of something we can put in the position (:)
all = newm(1:3, :);


%if we want to flip something left to riwe can use fliplr and it
%functions with row vector
flippedx = fliplr(x);


%if we want to flip up and down we call flipud
flippedcy = flipud(cy);


%matrices doesnt have problem and we can use both fliplr and flipud
flippedm = fliplr(flipud(m)); % i could use the rotation here by 90 degree later we will see it


%show our variables structure
whos

