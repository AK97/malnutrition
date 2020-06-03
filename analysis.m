clear;

%%% Import Data %%%

% All data values are averaged 1983 - 2019
GDP_avgs = readtable('GDP_avgs.csv'); %gdp (usd)
GDP_PC_avgs = readtable('GDPpc_avgs.csv'); %per capita (usd)
malnutrition = readtable('country-wise-average.csv');

GDP_avgs.Properties.VariableNames = {'Country', 'GDP'};
GDP_PC_avgs.Properties.VariableNames = {'Country', 'GDP_PC'};
malnutrition.Properties.VariableNames{'U5Population__000s_'} = 'Population';
GDP_avgs.Country = upper(GDP_avgs.Country);
GDP_PC_avgs.Country = upper(GDP_PC_avgs.Country);

%%% Parse %%%

% Throw out countries with incomplete data
GDP_avgs = rmmissing(GDP_avgs);
GDP_PC_avgs = rmmissing(GDP_PC_avgs);
malnutrition = rmmissing(malnutrition);

% Focus on countries present in both datasets and merge into one table
[~, index1, index2] = intersect(GDP_PC_avgs.Country, malnutrition.Country);
data = [GDP_avgs(index1, 2:end) GDP_PC_avgs(index1, 2:end) malnutrition(index2, 2:end)];

% Clean up
clear index1 index2

%%% Analyze %%%

% Visualize correlations
% scatter(log10(data.GDP_PC), data.SevereWasting);
% scatter(log10(data.GDP_PC), data.Overweight);

% PCA

[coeff, score, latent] = pca(normalize(data{:,[2 4:8]}));
scatter3(score(:,1), score(:,2), score(:,3));
