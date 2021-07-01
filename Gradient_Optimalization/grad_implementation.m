clear all
addpath FunctionsForOptimization
 
 
%% Optimization task:
FunctionForOptimization = str2func('of_2D_oneminimum_2');
 
%% Adjustable parameters:
MaxRangeX = [-10 10];         % Range of parameters for optimization
MaxRangeY = [-10 10];
 
MaxSteps = 50;               % How many iterations do we perform?
FunctionPlot = 1;             % change to 1 If you want to actually see the underlying function
 
ViewVect = [0,90];            % Initial viewpoint
Delay =0.01;                  % Inter-loop delay  - to slow down the visualization
FunctionPlotQuality = 0.05;   % Quality of function interpolation

Starts = 5;                   % Metaparameter, which defines number of loop starts             
g_step = 0.01;                % Metaparameter, step to define gradient (direction)
Step = 0.5;                   % Metaparameter, step of the function (distance)
 
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
    total_iterations = 0;
    tic;
    
    for i = 1 : Starts               % After each for-loop we should refresh these two values
        iter = 0;
        EndingCondition = 0;
        
        NewX = InitialRangeX(1) + rand()*(InitialRangeX(2) - InitialRangeX(1));
        NewY = InitialRangeY(1) + rand()*(InitialRangeY(2) - InitialRangeY(1));
        while(EndingCondition == 0)
            iter = iter + 1;
            total_iterations = total_iterations + 1;
            CurrentValue =  FunctionForOptimization(NewX,NewY,0);

            CV_dx = FunctionForOptimization(NewX + g_step, NewY, 0);
            CV_dy = FunctionForOptimization(NewX, NewY + g_step, 0);

            CV = CurrentValue;
            NewX = NewX + Step*(CV - CV_dx) / sqrt((CV - CV_dx)^2 + (CV - CV_dy)^2);
            NewY = NewY + Step*(CV - CV_dy) / sqrt((CV - CV_dx)^2 + (CV - CV_dy)^2);

            if(CurrentValue < CurrentMin)
                CurrentMin = CurrentValue;
                ResultX = NewX;
                ResultY = NewY;
                % FunctionPlot (if we have a new minimum):
                    figure(1)
                    plot3(NewY, NewX, CurrentValue,'.g'); hold on

            else
                % FunctionPlot (if we don't have a new minimum):
                    figure(1)
                    plot3(NewY, NewX, CurrentValue,'.r'); hold on

            end    

            SimTime = toc;
            clc
            fprintf('\nCurrent best:  %f',CurrentMin);
            fprintf('\nCurrent:       %f',CurrentValue);
            fprintf('\n\n\n');
            fprintf('\nIteration:     %d',total_iterations);
            fprintf('\nTime:          %d',SimTime);

            BestHistory(total_iterations) = CurrentMin;
            CurrentHistory(total_iterations) = CurrentValue;

        if(iter >= MaxSteps)
            EndingCondition = 1;
        else 

        end
            % If we'd like to slow down the simulation - this line is where it
            % is done
            pause(Delay);
        end
    end
 
    figure(2);
    plot(BestHistory,'r'); 
    hold on;
    plot(CurrentHistory,':r');
    hold on;
    legend('Best result', 'Current result')
    xlabel('Iteration');
    ylabel('OF value');