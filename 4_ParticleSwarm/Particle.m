classdef Particle < handle
    %PARTICLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        fitnessFn
        
        position
        velocity
        inertiaWeight
        cognitiveWeight
        socialWeight
        
        pbest
        pbestFit
        
    end
    
    methods
        
        function this = Particle(fitnessFn, position, w, c1, c2)
            
            % set fintess function
            this.fitnessFn = fitnessFn;
            
            % set position & velocity
            this.position = position;
            this.velocity = zeros(length(position),1);
            this.inertiaWeight = w;
            this.cognitiveWeight = c1;
            this.socialWeight = c2;
            
            % set personal best
            this.pbest = position;
            [this.pbestFit, ~] = this.fitnessFn.compute(position);
            
        end
        
        function update(this, lbest)
            
            % pick parameters
            pbest = this.pbest;
            w = this.inertiaWeight;
            c1 = this.cognitiveWeight;
            c2 = this.socialWeight;
            
            % for each position dimension
            for i=1:length(this.position)
                
                % pick values
                r1 = rand;
                r2 = rand;
                v = this.velocity(i);
                
                % update velocity
                this.velocity(i) = w*v + r1*c1*pbest(i) +r2*c2*lbest(i);
                
                % update position
                newPosition = this.position(i) + this.velocity(i);
                if newPosition<0
                    newPosition = mod(newPosition, fix(newPosition))*-1;
                elseif newPosition>0
                    newPosition =  1 - mod(newPosition, fix(newPosition));
                end
                this.position(i) = newPosition;
                                
            end
            
            % update personal best
            [newFit, ~] = this.fitnessFn.compute(this.position);
            if newFit<=this.pbestFit
                
                this.pbest = this.position;
                this.pbestFit = newFit;
                
            end
            
        end
        
    end
    
end

