clc, clear, close;
set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath(pwd));

% set field parameters
drawFreelink = true;
drawMaklink = true;
drawPath = true;
drawBool = {drawFreelink, drawMaklink, drawPath};
[start, goal, limit, obstacles] = getParameters(1);



% set field
field = Field(limit, start, goal, obstacles, drawBool);



% pick the fitness object
fitness = field.fitness;



%  ---------------- find best heights with metaheuricts  ----------------%
%heights = rand(fitness.hSize,1);





%  ----------------- find best heights with metaheuricts  ----------------%



% visualize the new path
%field.drawNewPath(heights);





%clean memory & path
rmpath(genpath(pwd));
% clearvars -except