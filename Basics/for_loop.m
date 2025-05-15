clc, clear, close all;

%let's see how the loops work
%we call the for keyword then the count variable that defines the logic of
%our increments/ decrements / whatever --- 

for cnt = 1:100
    fprintf("I hate N****s \n") %fprintf is the same as the one in c
    
    %skip the twelfth element
    if cnt == 12
        continue;
    end
    
    %terminate at the 34th nice people
    if cnt == 99
        break;
    end
end
