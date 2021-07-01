clear all
addpath FunctionsForOptimization
%% Optimization task:
FunctionForOptimization = str2func('of_2D_manyminima_7');
 
%% Adjustable parameters:
MaxRangeX = [-10 10];          % Range of parameters for optimization
MaxRangeY = [-10 10];
 
MaxSteps = 100;                % How many iterations do we perform?
FunctionPlot = 1;              % Сhange to 1 If you want to actually see the underlying function
 
ViewVect = [0,90];             % Initial viewpoint
Delay =0.001;                  % Inter-loop delay  - to slow down the visualization
FunctionPlotQuality = 0.05;    % Quality of function interpolation


InitialStep = 10;             % Metaparameter, step in a 1+1 algorithm
P1 = 3;
P2 = 15;
%% Map initialization
 
close all
 
InitialRangeX = MaxRangeX;     % This is the range from which we can draw points.
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
else
end
 
%% Storing of a best solution
 
    CurrentMin = 50000;
    ResultX = 1;
    ResultY = 1;

%% The main optimization loop
    EndingCondition = 0;
    iter = 0;
    tic;
    
    NewX = InitialRangeX(1) + rand() * (InitialRangeX(2) - InitialRangeX(1));
    NewY = InitialRangeY(1) + rand() * (InitialRangeY(2) - InitialRangeY(1));
    
    NewX = min(MaxRangeX(2),max(NewX,MaxRangeX(1))); 
    NewY = min(MaxRangeY(2),max(NewY,MaxRangeY(1)));
    
    while(EndingCondition == 0)
        iter = iter + 1;
        CurrentValue =  FunctionForOptimization(NewX,NewY,0);       
        
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
        
        Step(iter) = InitialStep * (1/(1+exp((iter-(MaxSteps/P1))/P2)));
            
        NewX = ResultX + Step(iter) * randn();    % Generation a new point basing on the 
        NewY = ResultY + Step(iter) * randn();    % best previous result
        
        NewX = min(MaxRangeX(2),max(NewX,MaxRangeX(1))); 
        NewY = min(MaxRangeY(2),max(NewY,MaxRangeY(1)));
        
        SimTime = toc;
        clc
        fprintf('\nCurrent best:  %f',CurrentMin);
        fprintf('\nCurrent:       %f',CurrentValue);
        fprintf('\n\n\n');
        fprintf('\nIteration:     %d',iter);
        fprintf('\nTime:          %d',SimTime);
        
        BestHistory(iter) = CurrentMin;
        CurrentHistory(iter) = CurrentValue;
        
    if(iter >= MaxSteps)
        EndingCondition = 1;
    else 
        
    end
        % If we'd like to slow down the simulation 
        % - this line is where it is done
        pause(Delay);
    end
    
 
    figure(2);
    plot(BestHistory,'r'); hold on
    plot(CurrentHistory,':r'); hold on
    legend('Best result', 'Current result');
    xlabel('Iteration'); ylabel('OF value');