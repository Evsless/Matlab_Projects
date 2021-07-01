clc; clear; close;
%addpath FunctionsForOptimization
load TR_DATA; TR_DATA = TR_DATA(1:3, 1:50);
 
%% Optimization task:
FunctionForOptimization = str2func('Train');

%% Adjustable parameters:
MaxRangeX = [-10 10];         % Range of parameters for optimization
MaxRangeY = [-10 10];
 
MaxSteps = 200;               % How many iterations do we perform?
FunctionPlot = 0;             % change to 1 If you want to actually see the underlying function
PointPlot = 0;

ViewVect = [0,90];            % Initial viewpoint
Delay = 0.01;                  % Inter-loop delay  - to slow down the visualization
FunctionPlotQuality = 0.05;   % Quality of function interpolation

DegreeOfFreedom = 30;

      % Genetical algorithm parameters
P_size = 20;                  % Population size
n = 10;                       % Parameter n for n best succession
Step = 0.1;                   % Mutation range

      % Changing step parameters
InitialStep = 14;
P1 = 1.78;
P2 = 13.7;
 
%% Map initialization

InitialRangeX = MaxRangeX;    % This is the range from which we can draw points.
InitialRangeY = MaxRangeY;
 
 
%% Map visualization (this code is not used for problem solving)
TimePercent = TR_DATA;
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
%% Main optimization loop
i = 0;
for k = 1:1:P_size
    Population(k).OF = inf;
    for i = 1:3
        for j = 1:DegreeOfFreedom
            if mod(j, 2) == 0
                Population(k).Parameters(i, j) = InitialRangeX(1) +  rand()*(InitialRangeX(2) - InitialRangeX(1));
            else
                Population(k).Parameters(i, j) = InitialRangeX(1) +  rand()*(InitialRangeY(2))/3;
            end
        end
    end
end
 
EndingCondition = 0;
iter = 0;
tic;

while(EndingCondition == 0)
    iter = iter + 1;
    Step(iter) = InitialStep * (1 / (1 + exp((iter - (MaxSteps / P1)) / P2)));
    
    for k = 1:P_size
        Population(k).OF = FunctionForOptimization(Population(k).Parameters, TR_DATA);
    end
    
    [~, Indices] = sortrows([Population(:).OF]');
    
    NewPopulation(1) = Population(Indices(1));
    
    if(FunctionPlot == 1)
        figure(1)
            clf; surf(X, Y, Val, 'Linestyle', 'none');
            view(ViewVect); colormap(bone); hold on;
    else
    end
    
    if(PointPlot == 1)
        for k = 1:P_size
            plot3([Population(k).Parameters(1)], [Population(k).Parameters(2)], [Population(k).OF], '.r'); hold on;
        end
    end
    
    BestHistory(iter) = Population(Indices(1)).OF;
    CurrentHistory(iter) = Population(Indices(floor(P_size/2))).OF;
    BestIndividualGenome(iter) = Population(Indices(1));
    
    ValidationCheck(iter)=Validation(BestIndividualGenome(iter).Parameters);
    
if iter >= 10
    if ValidationCheck(iter) >= ValidationCheck(iter-9)
        EndingCondition = 1;
    else
    end
end
    
    for k = 2:P_size
        ind1 = randi(n);
        ind2 = randi(n);
        NewPopulation(k) = Population(Indices(ind1));
        NewPopulation(k).Parameters(1) = Population(Indices(ind2)).Parameters(1);
        NewPopulation(k).Parameters = NewPopulation(k).Parameters + Step(iter)*randn(size(NewPopulation(k).Parameters));
        NewPopulation(k).OF = Inf;
        NewPopulation(k).Parameters = min(MaxRangeX(2), max(NewPopulation(k).Parameters, MaxRangeX(1)));
    end
    
    Population = NewPopulation;
    
    SimTime = toc;
    clc;
    fprintf('\nCurrent best: %f',BestHistory(end)); 
    fprintf('\nIteration: %d',iter); 
    fprintf('\nTime: %d',SimTime);
    
    if(iter > MaxSteps)
        EndingCondition = 1;
    else 
    end
    pause(Delay);
    
end

figure(2);
    plot(BestHistory,'r'); hold on
    plot(CurrentHistory,':r'); hold on
    xlabel('Iteration');
    ylabel('Objective function value');
