classdef ParticleSwarm
    %PARTICLESWARM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        gbestsStar
        trialsFitStar
        gbestsFitStarAvg
        gbestsFitStarStd
        gbestsFitStarMin
        
        gbestsRing
        trialsFitRing
        gbestsFitRingAvg
        gbestsFitRingStd
        gbestsFitRingMin
         
    end
    
    methods
        
        function this = ParticleSwarm(fitnessFn, popSize, w, c1, c2, iterMax, trialQty)
 
            % run trials
            [this.gbestsStar, this.trialsFitStar] = this.runTrials(fitnessFn, popSize, w, c1, c2, @this.getStarBest, iterMax, trialQty);
            
            % run trials
            [this.gbestsRing, this.trialsFitRing] = this.runTrials(fitnessFn, popSize, w, c1, c2, @this.getRingBest, iterMax, trialQty);
                                                     
            % plot results
            this.plotEvolution();
            
            % get avg & std
            [this.gbestsFitStarMin, this.gbestsFitStarAvg, this.gbestsFitStarStd] = this.getStats(this.trialsFitStar);
            [this.gbestsFitRingMin, this.gbestsFitRingAvg, this.gbestsFitRingStd] = this.getStats(this.trialsFitRing);
            
        end
        
        function particles = getParticles(~, popSize, fitnessFn, w, c1, c2)
            
            % for each particle
            particles = cell(popSize,1);
            for i=1:length(particles)

                % set particle
                position = rand(fitnessFn.hSize,1);
                particles{i} = Particle(fitnessFn, position, w, c1, c2);

            end

        end
        function [gbest, historyFit] = run(this, fitnessFn, popSize, w, c1, c2, iterMax, getLocalBestFn)
            
            % set history
            historyFit = zeros(iterMax,1);
            
            % set particles
            particles = this.getParticles(popSize, fitnessFn, w, c1, c2);
            
            % set global best
            [gbest, gbestFit] = getGbest(particles);
            
            % for each iteration
            for i=1:iterMax
                
                % for each particle
                for j=1:length(particles)
                    
                    % pick particle
                    particle = particles{j};
                    
                    % pick lbest
                    lbest = getLocalBestFn(particle, particles, gbest);
                    
                    % update particle
                    particle.update(lbest);
                    
                    % update gbest
                    if particle.pbestFit<=gbestFit
                        gbest = particle.pbest;
                        gbestFit = particle.pbestFit;
                    end
                    
                end
                
                % store results
                historyFit(i) = gbestFit;
                             
            end
            
            % local function
            function [gbest, gbestFit] = getGbest(particles)
                
                % for each particle
                gbest = [];
                gbestFit = flintmax;
                for k=1:length(particles)
                    
                    % pick particle
                    p = particles{k};
                    
                    % if better than current
                    if p.pbestFit<gbestFit
                        gbest = p.pbest;
                        gbestFit = p.pbestFit;
                    end
                end
                
            end
            
        end
        function lbest = getRingBest(~, root, particles, ~)

            % for each particle
            dist = zeros(length(particles), 1);
            for k=1:length(dist)

                % pick neighbour
                neighbour = particles{k};

                % compute distace
                o = root.position;
                x = neighbour.position;
                dist(k) = sqrt(sum((o-x).^2));

            end

            % pick the closest two neighbours
            [~, idx] = sort(dist);
            neighbours = {};
            count = 0;
            for k=1:length(dist)

                % if not the same
                if dist(idx(k))>0

                    % pick neighbour
                    count = count + 1;
                    neighbours{count} = particles{idx(k)};

                end

                % check count size
                if count>2
                    break
                end

            end

            % pick local best
            fitA = neighbours{1}.pbestFit;
            fitB = neighbours{2}.pbestFit;
            [~, lbestIdx] = min([fitA, fitB]);
            lbest = neighbours{lbestIdx}.pbest;

        end
        function lbest = getStarBest(~, ~, ~, gbest)
            lbest = gbest;
        end
        
        function [gbests, trialsFit] = runTrials(this, fitnessFn, popSize, w, c1, c2, getLocalBest, iterMax, trialQty)
                   
            % run particle swarm
            gbests = cell(trialQty,1);
            trialsFit = cell(trialQty,1);
            for i=1:trialQty
                [gbests{i}, trialsFit{i}] = this.run(fitnessFn, popSize, w, c1, c2, iterMax, getLocalBest);
            end
            
        end
        
        function [gbestsFitStarMin, gbestsFitStarAvg, gbestsFitStarStd] = getStats(~, trialsFit)
            
            gbests = zeros(length(trialsFit));
            for i=1:length(gbests)
               trialFit = trialsFit{i};
               gbests(i) = trialFit(end); 
            end
            gbestsFitStarMin = min(gbests);
            gbestsFitStarAvg = mean(gbests);
            gbestsFitStarStd = std(gbests);
            
        end
        
        function plotEvolution(this)
            
            figure(2);
            
            % pick best & wort fitness
            minStar = min(this.trialsFitStar{end});
            minRing = min(this.trialsFitRing{end});
            minBoth =  floor(min(minStar, minRing));
            
            maxStar = max(this.trialsFitStar{1});
            maxRing = max(this.trialsFitRing{1});
            maxBoth =  ceil(max(maxStar, maxRing));
   
            % for each trial
            for i=1:length(this.trialsFitStar)
                hold all
                subplot(2,1,1);
                title('Star Social PSO','FontSize',14);
                xlabel('# of iterations','FontSize',12);
                ylabel('gbest fitness','FontSize',12);

                ylim([minBoth maxBoth]);
                plot(this.trialsFitStar{i});
                hold off
                             
            end
            for i=1:length(this.trialsFitRing)
                hold all
                subplot(2,1,2);
                title('Ring Topology PSO','FontSize',14);
                xlabel('# of iterations','FontSize',12);
                ylabel('gbest fitness','FontSize',12);
                ylim([minBoth maxBoth]);
                plot(this.trialsFitRing{i});
                hold off                
            end

        end
        
    end
    
end

