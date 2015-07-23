classdef FitnessFn
    %FITNESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        limitsA
        limitsB
        
        start
        goal
        
        hSize
        pathSize
        
    end
    
    methods
        
        function this = FitnessFn(path, limitsA, limitsB)
            
            % set limits list
            this.limitsA = limitsA;
            this.limitsB = limitsB;
            
            this.start = this.limitsA{1};
            this.goal = this.limitsA{end};
            
            this.pathSize = length(path);
            this.hSize = length(path)-2;
            
        end
        
        function [fitness, midpoints] = compute(this, heights)
            
            % check input
            checkInput(heights, this.hSize);
            
            % format heights vector
            heights = formatHeights(heights);
            
            % get empty midpoints vector
            midpoints = getEmptyMidpoints(this.start, this.goal, this.pathSize);
            
            % for each path point (excluding start & goal)
            for i=2:(length(midpoints)-1)
            
               % compute new point
                x1 = this.limitsA{i}(1);
                x2 = this.limitsB{i}(1);
                xMidpoint = x1 + (x2-x1)*heights(i);

                y1 = this.limitsA{i}(2);
                y2 = this.limitsB{i}(2);
                yMidpoint = y1 + (y2-y1)*heights(i);
                
                % set new midpoint
                midpoints{i} = [xMidpoint yMidpoint 1];
                                
            end
            
            % for each midpoint
            fitness = 0;
            for i=1:(length(midpoints)-1)
                
                % compute distance
                a = midpoints{i};
                b = midpoints{i+1};
                fitness = fitness + sqrt(sum((b(1:2)-a(1:2)).^2));
                
            end
            
            % local functions
            function checkInput(heights, hSize)
                
                if (length(heights)~=hSize)
                    error('Wrong vector size for heights')
                end
                lowerBool = sum(heights<0)>0;
                upperBool = sum(heights>1)>0;
                if lowerBool || upperBool
                    error('Some value is outside [0 1] interval')
                end
                
            end
            function heights = formatHeights(heights)
                
                [m,n] = size(heights);
                if m>n
                    heights = [0; heights; 0];
                else            
                    heights = [0 heights 0];
                end
                
            end
            function midpoints = getEmptyMidpoints(start, goal, pathSize)
                
                midpoints = cell(pathSize,1);
                midpoints{1} = start;
                midpoints{end} = goal;
                
            end
            
        end
        
    end
    
end

