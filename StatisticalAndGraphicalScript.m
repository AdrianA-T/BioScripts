% Simulation parameters

% To import the data upload the excel file to the command window of matlab
% Using import window of matlab, select the data as numeric (without names)

data=Libro; % The loaded numerical matrix must be named Libro.
bw=2; % band width = precicion of the violin plots.
% Var=' Grey value (a.u)'; % Name of the variable of study


%% Script
format shortE 
cases=size(Libro,2); % Number of genotypes to study.
% Definition of lifetimes group per genotype
Variable=cell(1,cases);
for i=1:cases
   Variable{i}=data(:,i);
end

%% Statistical analysis

% Study of normality of the data. 

% Shapiro-Wilk test is not implemented in Matlab code, for the statistical study of normality we used the scrip developed by:

% Copyright (c) 17 March 2009 by Ahmed Ben Saïda, 
% Department of Finance, IHEC Sousse - Tunisia  
% https://es.mathworks.com/matlabcentral/fileexchange/13964-shapiro-wilk-and-shapiro-francia-normality-tests

SW=NaN(1,cases);

for n=1:cases
    SW(n)=swtest(Variable{n},0.05); 
end

% Depend on the results of SW test a Ttest or Wilcoxon test is used for
% the satitistical analysis:
PValues=NaN(cases);

if sum(SW)==0
    for i=1:cases
        for j=i+1:cases
           [temp,temp2]=ttest2(Variable{i},Variable{j});
           PValues(i,j)=temp2;
        end
    end
    
else

    for i=1:cases
       for j=i+1:cases
          PValues(i,j)=ranksum(Variable{i},Variable{j});    
       end   
    end 

end

if sum(SW)==0
    disp('P values of statistical study (T-test) for variable: ');
else
    disp('P values of statistical study (Wilcoxon test) for variable: ');
end

disp(PValues);

% Due to some sample data size, we also include an additional Ranksum study in case SW=0

if sum(SW)==0
   for i=1:cases
       for j=i+1:cases
          PValues(i,j)=ranksum(Variable{i},Variable{j});    
       end   
   end 
     disp('P values of statistical study also for Wilcoxon test: ');
     disp(PValues);
end


%% Graphical script


% Violin plot function is not implemented in Matlab code, for the the representation of the data we used the scrip developed by:

% Hoffmann H, 2015: violin.m - Simple violin plot using matlab default kernel density estimation. INRES (University of Bonn), Katzenburgweg 5, 53115 Germany.
% https://es.mathworks.com/matlabcentral/fileexchange/45134-violin-plot


figure % Plots Violin of the data
    Violin(Variable,'bw',bw);
%     ylabel(Var,'Fontsize',18);
%     tit=strcat('Violins of  ',Var);
%     title(tit);



