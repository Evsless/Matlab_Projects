% A simple random optimization algorithm. It tries new locations until it
% runs out of time. Delay serves as a way of slowing FunctionPlot.
% It requires a function for optimization (any function from folder
% "FunctionsForOptimization"
 
clear all
addpath FunctionsForOptimization
 
 
%% Optimization task:
FunctionForOptimization = str2func('of_2D_manyminima_7');
 
%% Adjustable parameters:
MaxRangeX = [-10 10];          % Range of parameters for optimization
MaxRangeY = [-10 10];
 
MaxSteps = 100;                % How many iterations do we perform?
FunctionPlot = 1;              % change to 1 If you want to actually see the underlying function
 
ViewVect = [0,90];             % Initial viewpoint
Delay =0.001;                  % Inter-loop delay  - to slow down the visualization
FunctionPlotQuality = 0.05;    % Quality of function interpolation

      % Genetical algorithm parameters
P_size = 22;                   % Population size
n = 11;                        % Parameter n for n best succession
Step = 0.6;                    % Mutation range
 
 
%% Map initialization
 
close all
 
InitialRangeX = MaxRangeX;      % This is the range from which we can draw points.
InitialRangeY = MaxRangeY;
 
 
%% Map visualization (this code is not used for problem solving)
TimePercent = 0;
if(FunctionPlot == 1)
    figure(1);
        vectX = [MaxRangeX(1):FunctionPlotQuality:MaxRangeX(2)];
        vectY = [MaxRangeY(1):FunctionPlotQuality:MaxRangeY(2)];
        [X,Y] = meshgrid(vectX,vectY);
        indx = 1;  indy = 1;
        for x = vectX
            indy = 1;
            for y = vectY
                Val(indx,indy) = FunctionForOptimization(x,y,TimePercent);
                indy = indy + 1;
            end
            indx = indx + 1;
        end
        mesh(X,Y,Val);
        surf(X,Y,Val,'LineStyle','none');
        view(ViewVect)
 
        colormap(bone)
        hold on
else end
 

 
%% Storing of a best solution
 
    CurrentMin = 50000;
    ResultX = 1;
    ResultY = 1;


%% The main optimization loop
    EndingCondition = 0;
    iter = 0;
    tic;
    
    for k = 1:P_size
        P(k,1) = 0;
        P(k,2) = InitialRangeX(1) + rand()*(InitialRangeX(2) - InitialRangeX(1));
        P(k,3) = InitialRangeY(1) + rand()*(InitialRangeY(2) - InitialRangeY(1));
        % Checking the limits
        P(k,2) = min(MaxRangeX(2),max(P(k,2),MaxRangeX(1)));
        P(k,3) = min(MaxRangeY(2),max(P(k,3),MaxRangeY(1)));
    end
    
    while(EndingCondition == 0)
        iter = iter + 1;
        
        for k = 1:P_size
            P(k, 1) = FunctionForOptimization(P(k, 2), P(k, 3), 0);
        end
        
        P_sorted = sortrows(P, 1);
        P_pot(1,:) = P_sorted(1,:);
        P_pot(2,:) = P_sorted(2,:);
        P_pot(3,:) = P_sorted(3,:);
        P_pot(4,:) = P_sorted(4,:);
        P_pot(5,:) = P_sorted(5,:);
        P_pot(6,:) = P_sorted(6,:);
        P_pot(7,:) = P_sorted(7,:);
        P_pot(8,:) = P_sorted(8,:);
        P_pot(9,:) = P_sorted(9,:);
        
        figure(1);
        clf
        if(FunctionPlot == 1)
            surf(X,Y,Val,'LineStyle','none'); 
            view(ViewVect) 
            colormap(bone) 
            hold on 
        else
        end
        
        for k = 1 : 1 : P_size
            plot3(P_sorted(k,3), P_sorted(k,2), P_sorted(k,1), '.m'); hold on
        end       
        
        BestHistory(iter) = P_sorted(1,1);
        CurrentHistory(iter) = P_sorted(floor(P_size/2), 1);
        
        figure(1);
        for k = 10:1:P_size
            ind = randi(n);
            P_pot(k,2) = P_sorted(ind,2) + Step * randn();
            P_pot(k,3) = P_sorted(ind,3) + Step * randn();
            
            P_pot(k,2) = min(MaxRangeX(2), max(P_pot(k,2), MaxRangeX(1)));
            P_pot(k,3) = min(MaxRangeY(2), max(P_pot(k,3), MaxRangeY(1)));
        end
        
        P = P_pot;
        
        SimTime = toc;
        clc
        fprintf('\nCurrent best:  %f',P_sorted(1,1));
        fprintf('\nIteration:     %d',iter);
        fprintf('\nTime:          %d',SimTime);
        
    if(iter >= MaxSteps)
        EndingCondition = 1;
    else 
        
    end
        % If we'd like to slow down the simulation - this line is where it
        % is done
        pause(Delay);
    end
 
    figure(2);
    plot(BestHistory,'r'); hold on
    plot(CurrentHistory,':r'); hold on