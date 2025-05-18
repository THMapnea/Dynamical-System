clc, clear, close all;

%let's declare some help variables 
a = 1;
b = 2;
c = 3;


%let's see how we can implement conditional in our matlab we call the if
%then we write the condition then we end if we want to put other if, loops
%etc in here the end is the last thing so unlike usually were we ut the
%else after the closing of the curly brackets we now put it before the end
%with all the relative code part

if a == b
    fprintf("the values are equal \n");

elseif a == c
    fprintf("golly \n");

else 
    fprintf("the values are different \n");
end

