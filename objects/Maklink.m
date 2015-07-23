classdef Maklink < handle
    %ROADMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        vertices
        freelinks

        start
        goal
        midpoints
        maklinks
        
    end
    
    methods
        
        function this = Maklink(start, goal)
            
            % set freelinks list
            this.vertices = {};
            this.freelinks = [];
            
            % set midPoints list
            this.midpoints = {};
            this.maklinks = [];
            
            % set start & goal
            this.start = start;
            this.goal = goal;
            
        end
        
        % freelinks functions
        function idx = getVertIdx(this, point)
                        
            % map point to idx
            for i=1:length(this.vertices)
                if this.vertices{i} == point
                    idx = i;
                    break
                end 
            end
            
        end
        function point = getVertice(this, idx)
            
            % map idx to vertice
            point = this.vertices{idx};
            
        end  
        function pushFreelink(this, a, b)
            
            % push freelink
            pushFreelink(this, a, b);
            
            % push midpoint
            pushMidPoint(this, a, b);
            
            % local functions
            function pushMidPoint(this, a, b)
                
                % check if it was already pushed
                isPushed = false;
                
                % for each midpoint
                for i=1:length(this.midpoints)
                    
                    % pick midpoint
                    midpoint = this.midpoints{i};
                    
                    % check limits
                    boolA = sum(a==midpoint{2})==3 && sum(b==midpoint{3})==3;
                    boolB = sum(b==midpoint{2})==3 && sum(a==midpoint{3})==3;
                    if boolA || boolB
                        isPushed = true;
                        break
                    end
                    
                end
                
                if ~isPushed
                    % push midPoint & limits to midpoints
                    midpoint = [(a(1)+b(1))/2, (a(2)+b(2))/2 1];
                    this.midpoints{end+1} = {midpoint, a, b};
                end
                
            end
            function pushFreelink(this, a, b)
                
                % push vertices to list
                this.vertices{end+1} = a;
                this.vertices{end+1} = b;

                % get idx vertices
                aIdx = this.getVertIdx(a);
                bIdx = this.getVertIdx(b);

                % compute distance cost
                dist = sqrt(sum((b(1:2)-a(1:2)).^2));

                % set edge
                this.freelinks(aIdx, bIdx) = dist;
                this.freelinks(bIdx, aIdx) = dist;
                
            end
            
        end
        
        % maklinks functions
        function [idx, limitA, limitB] = getMidIdx(this, point)
                        
            % map midpoint to idx
            for i=1:length(this.midpoints)
                
                midpoint = this.midpoints{i};
                if midpoint{1}==point
                    idx = i;
                    limitA = midpoint{2};
                    limitB = midpoint{3};
                    break
                end
                
            end
            
        end
        function [midpoint, limitA, limitB] = getMidpoint(this, idx)
            
            % map idx to midpoint
            midpoint = this.midpoints{idx}{1};
            limitA = this.midpoints{idx}{2};
            limitB = this.midpoints{idx}{3};
            
        end
        function pushMaklink(this, a, b)
            
            % get midPoints idx
            [aIdx, ~, ~] = this.getMidIdx(a);
            [bIdx, ~, ~] = this.getMidIdx(b);

            % compute distance cost
            dist = sqrt(sum((b(1:2)-a(1:2)).^2));

            % set edge
            this.maklinks(aIdx, bIdx) = dist;
            this.maklinks(bIdx, aIdx) = dist;
            
        end
   
        % bool functions
        function bool = isCutted(this, obs, rootMid, target)
            
            bool = false;
            countCross = 0;
            
            % for each midpoint
            for i=1:length(this.midpoints)
                
                % pick target midpoint
                [~, obsA, obsB] = this.getMidpoint(i);
                
                % check if rootdMid is same as obsMid
                if obs.isCrossing(rootMid, target, obsA, obsB);
                    countCross = countCross + 1;
                end
                
                if countCross>2
                    bool = true;
                    break;
                end
                
            end
            
        end
        function clearAreas(this, obs)
            
            % for each midpoint
            [m,n] = size(this.maklinks);
            for i=1:m
                
                % pick midpoint
                [rootMid, ~, ~] = this.getMidpoint(i);
                
                % for each other midpoint
                for j=(i+1):n
                    
                    % if are connected
                    if this.maklinks(i,j)>0
                        
                        % pick target midpoint
                        [targetMid, ~, ~] = this.getMidpoint(j);
                        
                        % count collisions
                        crossCount = 0;
                        for k=1:m

                            % pick obsA
                            [obsA, ~, ~] = this.getMidpoint(k);
                            
                            for l=(k+1):n
                                
                                % if are connected
                                if this.maklinks(k,l)>0
                                    % pick obsB
                                    [obsB, ~, ~] = this.getMidpoint(l);
                                    
                                    boolCross = obs.isCrossing(rootMid, targetMid, obsA, obsB);
                                    obsIsRoot = sum(rootMid==obsA)==3 || sum(rootMid==obsB)==3;
                                    obsIsTarget = sum(targetMid==obsA)==3 || sum(targetMid==obsB)==3;
                                    if ~obsIsRoot && ~obsIsTarget && boolCross
                                        
                                        % remove maklinks
                                        this.maklinks(i,j) = 0;
                                        this.maklinks(j,i) = 0;
                                        this.maklinks(k,l) = 0;
                                        this.maklinks(l,k) = 0;
                                        
                                    end
                                end
                            end

                        end
                        
                    end
                    
                end
                
            end
            
        end
        
        % shortest path function
        function [pathIdx, limitsA, limitsB, cost] = getPath(this)
            
            % get start & goal points
            [s, ~, ~] = this.getMidIdx(this.start);
            [g, ~, ~] = this.getMidIdx(this.goal);
            
            % set non-connected values
            graph = this.maklinks(:,:);
            for k=1:length(graph(:,1))
                for l=1:length(graph(1,:))
                    if graph(k,l)==0
                        graph(k,l) = intmax;
                    end
                end
            end
            
            % compute shortest path
            [pathIdx, cost] = dijkstra(graph, s, g);
            
            % pick list of limits
            limitsA = cell(length(pathIdx)-2,1);
            limitsB = cell(length(pathIdx)-2,1);
            for k=1:(length(pathIdx))
                [~, limitA, limitB] = this.getMidpoint(pathIdx(k));
                limitsA{k} = limitA;
                limitsB{k} = limitB;
            end
            
            % local function
            function [sp, spcost] = dijkstra(matriz_costo, s, d)

                % This is an implementation of the dijkstra´s algorithm, wich finds the 
                % minimal cost path between two nodes. It´s supoussed to solve the problem on 
                % possitive weighted instances.

                % the inputs of the algorithm are:
                %farthestNode: the farthest node to reach for each node after performing
                % the routing;
                % n: the number of nodes in the network;
                % s: source node index;
                % d: destination node index;

                %For information about this algorithm visit:
                %http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

                %This implementatios is inspired by the Xiaodong Wang's implememtation of
                %the dijkstra's algorithm, available at
                %http://www.mathworks.com/matlabcentral/fileexchange
                %file ID 5550

                %Author: Jorge Ignacio Barrera Alviar. April/2007


                n=size(matriz_costo,1);
                S(1:n) = 0;     %s, vector, set of visited vectors
                dist(1:n) = inf;   % it stores the shortest distance between the source node and any other node;
                prev(1:n) = n+1;    % Previous node, informs about the best previous node known to reach each  network node 

                dist(s) = 0;


                while sum(S)~=n
                    candidate=[];
                    for i=1:n
                        if S(i)==0
                            candidate=[candidate dist(i)];
                        else
                            candidate=[candidate inf];
                        end
                    end
                    [u_index u]=min(candidate);
                    S(u)=1;
                    for i=1:n
                        if(dist(u)+matriz_costo(u,i))<dist(i)
                            dist(i)=dist(u)+matriz_costo(u,i);
                            prev(i)=u;
                        end
                    end
                end


                sp = [d];

                while sp(1) ~= s
                    if prev(sp(1))<=n
                        sp=[prev(sp(1)) sp];
                    else
                        error;
                    end
                end;
                spcost = dist(d);

            end
            
        end

    end
    
end

