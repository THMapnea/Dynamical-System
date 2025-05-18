clc, clear, close all;

% we want to create some structure 

%we declare the struct but it's not necessary
%basketball_players = struct;

%we can then give some property to them and fill them
basketball_players(1).name = "Lebroooon";
basketball_players(1).is_the_goat = false;
basketball_players(1).glazing = true;

basketball_players(2).name = "Niggordan";
basketball_players(2).is_the_goat = false;
basketball_players(2).glazing = true;

basketball_players(3).name = "Wilt";
basketball_players(3).is_the_goat = true;
basketball_players(3).glazing = true;

%to get data from this struct we use c-like syntax
basketball_players(3).is_the_goat