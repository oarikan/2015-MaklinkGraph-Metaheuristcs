classdef Obstacle
    %OBSTACLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        points
     
    end
    
    methods
        
        % constructor
        function this = Obstacle(points)
           
            % set points
            this.points = points;
                    
        end
        
        % obstacle functions
        function [obsA, obsB] = getLine(this, idx)
            
            % get points
            obsA = this.points{idx};
            if idx == length(this.points)
                obsB = this.points{1};
            else
                obsB = this.points{idx+1};
            end

        end
        function [sideL, sideR] = getSides(this, start)
            
            % check if point is valid
            if (this.isIncluded(start))
                
                % for each obstacle point
                for i=1:length(this.points)
                    
                    % when found
                    if this.points{i} == start                    
                        if i==1
                            % if first point
                            sideL = this.points{end};
                            sideR = this.points{i+1};
                        elseif i==length(this.points)
                            % if last point
                            sideL = this.points{i-1};
                            sideR = this.points{1};
                        else
                            % normal case
                            sideL = this.points{i-1};
                            sideR = this.points{i+1};
                        end
                        break   
                    end
                    
                end
                
            else
                error('getSides error');
            end
            
        end
        
        % boolean functions
        function [bool, idx] = isIncluded(this, start)
            
            % check if obstacles contains "start" point
            idx = 0;
            bool = false;
            for i=1:length(this.points)             
                if start == this.points{i}
                    bool = true;
                    idx = i;
                    break
                end
            end
            
        end
        function bool = isVisible(this, start, target)
            
            % check if target is included
            if ~this.isIncluded(target)
                error('error obs.isVisible')
            end
            
            % count # of collisions
            crossCount = 0;
            for i=1:length(this.points)
                
                % get obstacle line
                [obsA, obsB] = this.getLine(i);

                % check if obsLine && testLine intersects
                isCross = this.isCrossing(obsA, obsB, start, target);
                if isCross
                    crossCount = crossCount + 1;
                end
                
            end
            
            % if start is also included
            if this.isIncluded(start) 
            
                % if greater than 4, then is not visible
                if start==target
                    % single point case
                    bool = false;
                elseif crossCount<3
                    error('Too little collisions <3, %d', crossCount);
                elseif crossCount==3
                    % same line case
                    bool = true;
                elseif crossCount==4
                   
                    % check if midpoint is inside the obstacle
                    xv = zeros(length(this.points),1);
                    yv = zeros(length(this.points),1);
                    for i=1:length(this.points)
                        xv(i) = this.points{i}(1);
                        yv(i) = this.points{i}(2);
                    end
                    midPoint = [(start(1)+target(1))/2, (start(2)+target(2))/2];
                    inside = inpolygon(midPoint(1),midPoint(2),xv,yv);
                    
                    if inside
                        bool = false;
                    else
                        bool = true;
                    end
                        
                                        
                else
                    bool = false;
                end
                
            else
                
                % if greater than 2, then is not visible
                if crossCount<2
                    error('Too little collisions <2');
                elseif crossCount==2
                    bool = true;
                else
                    bool = false;
                end
                
            end

        end
        function bool = isCrossingObs(this, start, target)
            
            % set obstacle bool
            bool = false;
  
            % if a point is included
            isInStart = this.isIncluded(start);
            isInTarget = this.isIncluded(target);
            if isInStart || isInTarget
                
                % count # of collisions
                crossCount = 0;
                for i=1:length(this.points)
                    % get obstacle line
                    [obsA, obsB] = this.getLine(i);

                    % check if obsLine && testLine intersects
                    isCross = this.isCrossing(obsA, obsB, start, target);
                    if isCross
                        crossCount = crossCount + 1;
                    end
                end
                
                if isInStart+isInTarget==1
                    % check based on # of collisions
                    if crossCount<2
                        error('isCrossingObs')
                    elseif crossCount==2
                        % collision with neighbout lines
                        bool = false;
                    else
                        bool = true;
                    end
                else
                    % check based on # of collisions
                    if crossCount<3
                        error('isCrossingObs')
                    elseif crossCount==3
                        %same line case
                        bool = false;
                    elseif crossCount==4
                        
                        % check if midpoint is inside the obstacle
                        xv = zeros(length(this.points),1);
                        yv = zeros(length(this.points),1);
                        for i=1:length(this.points)
                            xv(i) = this.points{i}(1);
                            yv(i) = this.points{i}(2);
                        end
                        midPoint = [(start(1)+target(1))/2, (start(2)+target(2))/2];
                        inside = inpolygon(midPoint(1),midPoint(2),xv,yv);

                        if inside
                            bool = true;
                        else
                            bool = false;
                        end
                        
                    else
                        bool = true;
                    end
                end
                
            else
                
                % for each obstacle line
                for i=1:length(this.points)
                    % check for collision
                    [obsA, obsB] = this.getLine(i);
                    isCross = this.isCrossing(obsA, obsB, start, target);
                    if isCross
                        bool = true;
                        break
                    end
                end
                
            end
            
        end
        
        % query functions
        function vertices = getVisibleVertices(this, start)
            
            % for each obstacle point
            aux = cell(length(this.points));
            for i=1:length(this.points)
                
                % check if is visible
                target = this.points{i};
                if this.isVisible(start, target)
                    aux{i} = target;
                end
                
            end
            vertices = aux(~cellfun(@isempty,aux));
            
        end
   
        % maklink functions
        function boolAngles = isAcute(this, origin, target)
            
            % get side points
            [sideL, sideR] = this.getSides(origin);
            
            % get angles
            angleL = this.getAngle(origin, target, sideL);
            angleR = 360 - this.getAngle(origin, target, sideR);

            % check if acute
            boolL = angleL <= 180;
            boolR = angleR <= 180;

            boolAngles = [boolL boolR];
                     
        end
        function freeLinks = getFreeLinks(this, start, points)
            
            % sort points by length
            sortedPoints = this.getSorted(start, points);
            
            [bool, ~] = this.isIncluded(start);
            if ~bool
                error('getFreeLinks error');
            end
            
            % for each vertice
            freeLinks = {};
            idx = 0;
            for i=1:length(sortedPoints)

                % check if is obstacle side
                boolSide = this.isIncluded(sortedPoints{i});
                if ~boolSide
                    
                    % check angles
                    boolAngles = this.isAcute(start, sortedPoints{i});
                    if sum(boolAngles)==2
                        freeLinks = {sortedPoints{i}};
                        break
                    elseif sum(boolAngles)==1
                        idx = idx + 1;
                        freeLinks{idx} = sortedPoints{i};
                    end
                    
                end

            end
            
        end
        
        % math functions
        function bool = isCrossing(~, obsA, obsB, testA, testB)
            
            isEqObs = obsA==obsB;
            isEqTest = testA==testB;
            if sum(isEqObs)==3 || sum(isEqTest)==3 
                x1 = [obsA(1) obsB(1)];
                y1 = [obsA(2) obsB(2)];
                x2 = [testA(1) testB(1)];
                y2 = [testA(2) testB(2)];
                [xi,yi] = polyxpoly(x1,y1,x2,y2);
                if isempty(xi) || isempty(yi)
                    bool = false;
                else
                    bool = true;
                end
                return
            end
            
            % tolerance precision
            tol = .1;
                       
            % compute x intercept
            [obsSlop, obsCept] = lineEq(obsA, obsB);
            [testSlop, testCept] = lineEq(testA, testB);
            
            % compute intersection
            obsLine = normCross(obsA, obsB);
            testLine = normCross(testA, testB);
            inter = normCross(obsLine, testLine);
            
            if (~isnan(obsSlop) && ~isnan(testSlop) && obsSlop==testSlop) || (isnan(obsSlop) && isnan(testSlop)) 
              
                if sum(obsA==testA)==3 && sum(obsB==testB)==3 ||...
                   sum(obsA==testB)==3 && sum(obsB==testA)==3    
                    bool = true;
                % check if same X intercept
                elseif obsCept==testCept
                    
                    % check if X and Y limits intersects
                    if ( ( min(obsA(1),obsB(1)) <= min(testA(1),testB(1)) && min(testA(1),testB(1)) <= max(obsA(1),obsB(1)) ) ||...
                       ( min(testA(1),testB(1)) <= min(obsA(1),obsB(1)) && min(obsA(1),obsB(1)) <= max(testA(1),testB(1)) ) ) &&...
                       ( ( min(obsA(2),obsB(2)) <= min(testA(2),testB(2)) && min(testA(2),testB(2)) <= max(obsA(2),obsB(2)) ) ||...
                       ( min(testA(2),testB(2)) <= min(obsA(2),obsB(2)) && min(obsA(2),obsB(2)) <= max(testA(2),testB(2)) ) )
                        bool = true;
                    else
                        bool = false;
                    end
   
                else
                    % different X intercepts
                    bool = false;
                end
                              
            else
                
                % check if intersection is between the points
                if ( ( min(obsA(1),obsB(1))-tol <= inter(1) && inter(1) <= max(obsA(1),obsB(1))+tol ) &&...
                   ( min(obsA(2),obsB(2))-tol <= inter(2) && inter(2) <= max(obsA(2),obsB(2))+tol ) ) &&...
                   ( ( min(testA(1),testB(1))-tol <= inter(1) && inter(1) <= max(testA(1),testB(1))+tol ) &&...
                   ( min(testA(2),testB(2))-tol <= inter(2) && inter(2) <= max(testA(2),testB(2))+tol ) )
                    bool = true;
                else
                    bool = false;
                end
                
            end
            
            %plotLocal(obsA, obsB, testA, testB, inter, obsSlop, obsCept, testSlop, testCept);
            
            % local functions
            function [m, xCept] = lineEq(obsA, obsB)
                
                if obsB(1)==obsA(1);
                    m = NaN;
                    xCept = obsA(1);
                else
                    m = (obsB(2)-obsA(2)) / (obsB(1)-obsA(1));
                    xCept = obsA(2) - m*obsA(1);
                end
                
            end
            function line = normCross(a, b)
            
                line = cross(a, b);
                if line(end) == 0
                    line(end) = 1;
                end
                line = line/line(end);

            end
            function plotLocal(obsA, obsB, testA, testB, inter, obsSlop, obsCept, testSlop, testCept)
                
                plotLine(testA, testB, 'r');
                plotPoint(testA, 'r');
                plotPoint(testB, 'r');
                plotLine(obsA, obsB, 'k');
                plotPoint(obsA, 'k');
                plotPoint(obsB, 'k');
                
                plotPoint(inter, 'g');
                
                obsA, obsB, testA, testB, inter
                
                obsSlop, obsCept, testSlop, testCept
                
            end
                         
        end      
        function angle = getAngle(~, origin, a, b)
            
            % compute counterwise angle
            u = [(a(1)-origin(1)), (a(2)-origin(2))];
            v = [(b(1)-origin(1)), (b(2)-origin(2))];

            angle = atan2d(v(2),v(1)) - atan2d(u(2),u(1));
            if angle < 0
                angle = 360 + angle;
            end
            
        end
        function sortedPoints = getSorted(~, origin, points)
            
            % sort by distance
            dists = zeros(size(points));
            for i=1:length(points)
                dists(i) = sqrt(sum((points{i}-origin).^2));
            end
            [~, idx] = sort(dists);
            sortedPoints = points(idx);
            
        end
        
    end
    
end