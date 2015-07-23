classdef ParticleSwarm
    %PARTICLESWARM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % fitness function
        fitnessFn
        
        % particles
        particles
        
    end
    
    methods
        
        function this = ParticleSwarm(fitnessFn, iterMax, popSize, w, c1, c2)
            
            % set fintness & max # of iterations
            this.fitnessFn = fitnessFn;
            this.iterMax = iterMax;
            
            % set particles
            this.particles = this.getParticles(popSize, w, c1, c2);
            
        end
        
        function particles = getParticles(this, popSize, w, c1, c2)
            
            % set particles
            particles = cell(popSize,1);
            
        end
        
    end
    
end

