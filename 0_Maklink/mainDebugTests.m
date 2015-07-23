clc, clear, close;
set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath(pwd));


% set parameters
limit = [200 200 1];
start = [80 15 1];
goal = [180 180 1];

% set obstacles --- make sure the obstacles vertices are given in order ---
a1 = [40 50 1];
b1 = [40 75 1];
c1 = [60 75 1];
d1 = [75 65 1];
e1 = [70 50 1];
obs1 = Obstacle({a1, b1, c1, d1, e1});
a2 = [80 100 1];
b2 = [80 150 1];
c2 = [120 150 1];
d2 = [120 145 1];
e2 = [95 140 1];
f2 = [95 120 1];
g2 = [120 110 1];
h2 = [120 100 1];
obs2 = Obstacle({a2, b2, c2, d2, e2, f2, g2, h2});
a3 = [140 160 1];
b3 = [160 160 1];
c3 = [160 140 1];
d3 = [140 140 1];
obs3 = Obstacle({a3, b3, c3, d3});
a4 = [20 180 1];
b4 = [60 180 1];
c4 = [60 175 1];
d4 = [25 145 1];
e4 = [20 145 1];
obs4 = Obstacle({a4, b4, c4, d4, e4});
a5 = [10 10 1];
b5 = [10 30 1];
c5 = [30 30 1];
d5 = [30 10 1];
obs5 = Obstacle({a5, b5, c5, d5});
a6 = [160 40 1];
b6 = [160 80 1];
c6 = [170 80 1];
d6 = [170 60 1];
e6 = [190 50 1];
f6 = [190 40 1];
obs6 = Obstacle({a6,b6,c6,d6,e6,f6});
field = Field(limit, start, goal, {obs1, obs2, obs3, obs4, obs5, obs6});

field.maklink

% % ---------- test: obs.isCrossing(obsA, obsB, testA, testB) ----------- %

% test: obs.isCrossing(a, b, start, target)
%obs = obs4;



% horizontal
%[obsA, obsB] = obs.getLine(1);

% should be all true
% testA = [obsA(1) obsA(2) 1];
% testB = [obsB(1) obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)+20 obsA(2) 1];
% testB = [obsB(1)+20 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)-20 obsA(2) 1];
% testB = [obsB(1)-20 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)-20 obsA(2) 1];
% testB = [obsB(1)+20 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)+10 obsA(2) 1];
% testB = [obsB(1)-10 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)-20 obsA(2) 1];
% testB = [obsA(1) obsA(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsB(1) obsB(2) 1];
% testB = [obsB(1)+20 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)

% should be all false
% testA = [obsA(1)+50 obsA(2) 1];
% testB = [obsB(1)+1 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)-1 obsA(2) 1];
% testB = [obsB(1)-50 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)+10 1];
% testB = [obsB(1) obsB(2)+10 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)



% vertical
%[obsA, obsB] = obs.getLine(5);

% should be all true
% testA = [obsA(1) obsA(2) 1];
% testB = [obsB(1) obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)+20 1];
% testB = [obsB(1) obsB(2)+20 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)-20 1];
% testB = [obsB(1) obsB(2)-20 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)-20 1];
% testB = [obsB(1) obsB(2)+20 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)+10 1];
% testB = [obsB(1) obsB(2)-10 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)-20 1];
% testB = [obsA(1) obsA(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsB(1) obsB(2) 1];
% testB = [obsB(1) obsB(2)+20 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)

% should be all false
% testA = [obsA(1) obsA(2)+50 1];
% testB = [obsB(1) obsB(2)+1 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2)-1 1];
% testB = [obsB(1) obsB(2)-50 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)+10 obsA(2) 1];
% testB = [obsB(1)+10 obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)



% diagonal
%obsA = [60 60 1]; obsB = [90 90 1];

%should be all true
% testA = [obsA(1) obsA(2) 1];
% testB = [obsB(1) obsB(2) 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1) obsA(2) 1];
% testB = [obsA(1)+10 obsA(1)+10 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)-10 obsA(2)-10 1];
% testB = [obsA(1)+10 obsA(1)+10 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsB(1) obsB(2) 1];
% testB = [obsB(1)+10 obsB(1)+10 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsB(1)-10 obsB(2)-10 1];
% testB = [obsB(1)+10 obsB(1)+10 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsB(1)-10 obsB(2)-10 1];
% testB = [obsB(1)-20 obsB(2)-20 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsB(1)+20 obsB(2)+20 1];
% testB = [obsB(1)-40 obsB(2)-40 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [60 90 1];
% testB = [90 60 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)

% should be all false
% testA = [obsA(1) obsA(2)+20 1]+[10 10 0];
% testB = [obsB(1) obsB(2)+20 1]-[10 10 0];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)+50 obsA(2)+50 1];
% testB = [obsB(1)+50 obsB(2)+50 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% testA = [obsA(1)-50 obsA(2)-50 1];
% testB = [obsB(1)-50 obsB(2)-50 1];
% bool = obs.isCrossing(obsA, obsB, testA, testB)



% % regular cases
% obs = obs3;
% 
% % should be all zero
% testA = start;
% testB = obs3.points{4};
% [obsA, obsB] = obs.getLine(1);
% bool = obs.isCrossing(testA, testB, obsA, obsB)
% bool = obs.isCrossing(obsA, obsB, testA, testB)

% % should be all one
% obs = obs2;
% testA = obs.points{5};
% testB = obs.points{2};
% [obsA, obsB] = obs.getLine(1);
% bool = obs.isCrossing(obsA, obsB, testA, testB)
% start = [0 200 1];
% goal = a2;
% [obsA, obsB] = obs4.getLine(1)
% obsBool2 = obs4.isCrossing(obsA, obsB, start, goal)
% testA = obs4.points{4};
% testB = obs4.points{3};
% obsA = obs4.points{3};
% obsB = obs4.points{4};
% obs4.isCrossing(testA, testB, obsA, obsB)

% ------------------------------------------------------------------------%


%test: obs.isVisible
% obs = obs4;
% start = obs.points{4};
% target = obs.points{3};
% obs.isVisible(start, target)
% plotPoint(start, 'b');
% plotPoint(target, 'r');
% plotLine(start, target, 'r');



% % test: obs.getVisibleVertices
% start = obs4.points{4};
% vertices = obs4.getVisibleVertices(start)
% for i=1:length(vertices)
%     hold on
%     plot([start(1) vertices{i}(1)],[start(2) vertices{i}(2)], '--');
%     hold off
% end



%test: obs.isCrossingObs
% start = c2;

% % should be all one
% goal = obs3.points{2}+[10 0 0];
% obsBool1 = obs3.isCrossingObs(start, goal)
% 
% start = [0 200 1];
% goal = a2;
% obsBool2 = obs4.isCrossingObs(start, goal)


% start = [0 200 1];
% goal = a2;
% obsBool2 = obs4.isCrossingObs(start, goal)
% hold on
% plot([start(1) goal(1)],[start(2) goal(2)]);
% hold off

% start = c2;
% goal = e2;
% obsBool3 = obs2.isCrossingObs(start, goal)
% hold on
% plot([start(1) goal(1)],[start(2) goal(2)]);
% hold off

% start = d3;
% goal = a5;
% obsBool3 = obs1.isCrossingObs(start, goal)
% hold on
% plot([start(1) goal(1)],[start(2) goal(2)]);
% hold off

% start = obs2.points{1};
% goal = obs2.points{3};
% obsBool3 = obs2.isCrossingObs(start, goal)
% plotPoint(start,'b');
% plotPoint(goal,'r');
% plotLine(start, goal,'r');

% start = obs4.points{3};
% goal = obs4.points{4};
% obsBool3 = obs2.isCrossingObs(start, goal)
% plotPoint(start,'b');
% plotPoint(goal,'r');
% plotLine(start, goal,'r');



% % test: field.isBlocked
% start = obs3.points{1};
% goal = [start(1) limit(1) 1];
% bool = field.isBlocked(start, goal)
% hold on
% plot([start(1) goal(1)],[start(2) goal(2)]);
% hold off



% test: field.getVisibleVertices(start)

% vertices = obs4.getVisibleVertices(start);
% for i=1:length(vertices)
%     hold on
%     plot([start(1) vertices{i}(1)],[start(2) vertices{i}(2)], '--');
%     hold off
% end


% % test: field.getVisibleVertices(start)
% start = obs4.points{1};
% vertices = field.getVisibleVertices(start)
% for i=1:length(vertices)
%     hold on
%     plot([start(1) vertices{i}(1)],[start(2) vertices{i}(2)], '--');
%     hold off
% end





% % general tests
% 
% % test: getFreeLinks(start)
% obs = obs4;
% start = obs.points{3};
% 
% vertices = field.getVisibleVertices(start);
% freeLinks = obs.getFreeLinks(start, vertices);
% 
% for i=1:length(freeLinks)
%     hold on
%     plot([start(1) freeLinks{i}(1)],[start(2) freeLinks{i}(2)], '--');
%     hold off
% end




%clean memory & path
rmpath(genpath(pwd));
% clearvars -except