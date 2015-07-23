classdef Field
    %FIELD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        limit
        start
        goal
        obstacles
        
        maklink
        path
        
        fitness
        
    end
    
    methods
        
        % constructor
        function this = Field(limit, start, goal, obstacles, drawBool)
            
            % set properties
            this.limit = limit;
            this.start = start;
            this.goal = goal;
            this.obstacles = obstacles;
         
            % set maklink
            this.maklink = this.computeMaklink(Maklink(start, goal));
            
            % insert start & goal
            this.pushStartGoal(this.maklink);
            
            % compute shortest path
            [this.path, limitsA, limitsB, ~] = this.maklink.getPath();
            
            % set fitness
            this.fitness = Fitness(this.path, limitsA, limitsB);
                       
            % draw field
            this.drawField(drawBool);
                    
        end
        
        % drawing functions
        function drawField(this, drawBool)
            
            % set figure
            figure(1);
            clf, hold on;
            
            % set field limits
            axis([1 this.limit(1) 1  this.limit(2)]);
            
            % draw obstacles
            for i=1:length(this.obstacles)
                
                % format coords
                obstacle = this.obstacles{i};
                points = obstacle.points;
                x = [];
                y = [];
                for j=1:length(points)
                    x = [x points{j}(1)];
                    y = [y points{j}(2)];
                end
                
                % draw figures
                patch(x, y, [0.75 0.75 0.75],'EdgeColor',[0.75 0.75 0.75]);
                
            end
            
            if drawBool{1}
            
                % draw freelinks
                mak = this.maklink;
                for i=1:length(mak.freelinks(:,1))
                    for j=1:length(mak.freelinks(1,:))
                        if mak.freelinks(i,j)>0

                            % plot freelink
                            a = mak.getVertice(i);
                            b = mak.getVertice(j);
                            plot([a(1) b(1)],[a(2) b(2)],'--','Color', [0.5 0.5 0.5]);

                        end
                    end
                end
                                
            end
            
            if drawBool{2}

                % draw maklinks
                mak = this.maklink;
                [m,n] = size(mak.maklinks);
                for i=1:m
                    for j=1:n
                        if mak.maklinks(i,j)>0
                 
                            % plot freelink
                            a = mak.getMidpoint(i);
                            b = mak.getMidpoint(j);
                            plot([a(1) b(1)],[a(2) b(2)],'Color', [0.7 0 0.7]);
                            
                            % plot midpoints
                            plot(a(1), a(2), 'o', 'MarkerEdgeColor', [0.7 0 0.7], ...
                                                  'MarkerFaceColor', [0.7 0 0.7], ...
                                                  'MarkerSize', 5);
                            plot(b(1), b(2), 'o', 'MarkerEdgeColor', [0.7 0 0.7], ...
                                                  'MarkerFaceColor', [0.7 0 0.7], ...
                                                  'MarkerSize', 5);

                        end
                    end
                end
                
            end
            
            if drawBool{3}
                % draw shortest path
                for i=1:(length(this.path)-1)

                    % plot freelink
                    a = mak.getMidpoint(this.path(i));
                    b = mak.getMidpoint(this.path(i+1));
                    plot([a(1) b(1)],[a(2) b(2)],'r');
                    plot(b(1), b(2), 'o', 'MarkerEdgeColor', 'r', ...
                                          'MarkerFaceColor', 'r', ...
                                          'MarkerSize', 5);


                end
            end
            
            % draw starting point
            s = plot(this.start(1), this.start(2), 'o', 'MarkerEdgeColor', 'b', ...
                                                        'MarkerFaceColor', 'b', ...
                                                        'MarkerSize', 10);
            % draw goal area
            g = plot(this.goal(1), this.goal(2), 'o', 'MarkerEdgeColor', 'r', ...
                                                      'MarkerFaceColor', 'r', ...
                                                      'MarkerSize', 10);
            % set legend                                
            legend([s g], 'Start', 'Goal', 'Location', 'SouthEast');
            
            
            hold off;
            
        end
        function drawNewPath(this, heights)
            
            % compute new points
            [~, midpoints] = this.fitness.compute(heights);
            
            % clear field
            this.drawField({0 0 0})
            
            % plot new path
            hold on;
            for i=1:(length(midpoints)-1)
                
                % draw new path
                a = midpoints{i};
                b = midpoints{i+1};
                plot([a(1) b(1)],[a(2) b(2)],'Color', [0 .5 .5]);
                if i>1
                    plot(a(1), a(2), 'o', 'MarkerEdgeColor', [0 .5 .5], ...
                                          'MarkerFaceColor', [0 .5 .5], ...
                                          'MarkerSize', 5);
                end
                
            end
            hold off;
            
        end
        
        % field functions
        function blocked = isBlocked(this, start, target)
            
            % for each obstacle
            blocked = false;
            for i=1:length(this.obstacles)
                
                % check if the testLine crosses obstacle
                obs = this.obstacles{i};
                if obs.isCrossingObs(start, target)
                    blocked = true;
                    break
                end
                
            end
        end 
        function vertices = getVisibleVertices(this, start)
            
            vertices = {};
            
            % for each obstacle
            for i=1:length(this.obstacles)
                
                % get visible vertices
                obs = this.obstacles{i};
                visibVert = obs.getVisibleVertices(start);
                
                % check if they are blocked
                for j=1:length(visibVert)
                    
                    blocked = this.isBlocked(start, visibVert{j});
                    if ~blocked
                        vertices{end+1} = visibVert{j};
                    end
                    
                end
                
            end
            
            % for each field wall
            left = [0 start(2) 1];
            right = [this.limit(1) start(2) 1];
            up = [start(1) this.limit(2) 1];
            down = [start(1) 0 1];
            wall = {right, left, up, down};
            for i=1:length(wall)
                
                blocked = this.isBlocked(start, wall{i});
                if ~blocked
                    vertices{end+1} = wall{i};
                end
                
            end
            
        end
        
        % maklink functions
        function maklink = computeMaklink(this, maklink)
            
            % compute freelinks
            this.setFreelinks(maklink);
            
            % compute maklinks
            this.setMaklinks(maklink);

        end
        function setFreelinks(this, maklink)
                
            % for each obstacle
            for i=1:length(this.obstacles)

                % pick obstacle
                obs = this.obstacles{i};

                % for each vertice
                for j=1:length(obs.points)

                    % pick root vertice
                    origin = obs.points{j};

                    % get its free links
                    vertices = this.getVisibleVertices(origin);
                    freeLinks = obs.getFreeLinks(origin, vertices);

                    % for each freeLink
                    for k=1:length(freeLinks)
                        maklink.pushFreelink(origin, freeLinks{k});
                    end

                end
            end  
        end
        function setMaklinks(this, maklink)
                      
            % for each midpoint
            for i=1:length(maklink.midpoints)

                % pick midpoint
                [rootMid, ~, ~] = maklink.getMidpoint(i);

                % for each other midpoint
                for j=(i+1):length(maklink.midpoints)

                    % pick tartget midpoint
                    [target, ~, ~] = maklink.getMidpoint(j);

                    % chek if unblocked
                    isBlock = this.isBlocked(rootMid, target);
                    isCut = maklink.isCutted(this.obstacles{1}, rootMid, target);
                    if ~isBlock && ~isCut
                        maklink.pushMaklink(rootMid, target);
                    end
                end
                
            end
            maklink.clearAreas(this.obstacles{1});
            
        end
        function pushStartGoal(this, maklink)
            
            % push to midpoints list
            maklink.midpoints{end+1} = {this.start, this.start, this.start};
            maklink.midpoints{end+1} = {this.goal, this.goal, this.goal};
            
            % expand maklinks graph
            [m,n] = size(maklink.maklinks);
            maklink.maklinks = [maklink.maklinks zeros(m,2); zeros(2, n+2)];
            
            % push valid connections
            [m,~] = size(maklink.maklinks);
            for i=1:m
                
                % pick target point
                [target, ~, ~] = maklink.getMidpoint(i);
                
                % check if is free to start
                isBlock = this.isBlocked(this.start, target);
                isCut = maklink.isCutted(this.obstacles{1}, this.start, target);
                if ~isBlock && ~isCut
                    this.maklink.maklinks(end-1, i) = sqrt(sum((target(1:2)-this.start(1:2)).^2));
                    this.maklink.maklinks(i, end-1) = sqrt(sum((target(1:2)-this.start(1:2)).^2));
                end
                
                % check if is free to goal
                isBlock = this.isBlocked(this.goal, target);
                isCut = maklink.isCutted(this.obstacles{1}, this.goal, target);
                if ~isBlock && ~isCut
                    this.maklink.maklinks(end, i) = sqrt(sum((target(1:2)-this.goal(1:2)).^2));
                    this.maklink.maklinks(i, end) = sqrt(sum((target(1:2)-this.goal(1:2)).^2));
                end
                
            end
            
        end
        
    end
end

