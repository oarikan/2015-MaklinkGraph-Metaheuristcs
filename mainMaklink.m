clc, clear, close;
set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath(pwd));

% set field parameters
drawFreelink = true;
drawMaklink = true;
drawPath = true;
drawBool = {drawFreelink, drawMaklink, drawPath};
[start, goal, limit, obstacles] = getExamples(2);



% set field
field = Field(limit, start, goal, obstacles, drawBool);





%  ---------------- find best heights with metaheuricts  ----------------%



%  ----------------- find best heights with metaheuricts  ----------------%



% visualize the new path
heights = rand(field.fitnessFn.hSize,1);
field.drawNewPath(heights);





%clean memory & path
rmpath(genpath(pwd));
% clearvars -except