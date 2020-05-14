% % GT Neuron Model Simulation
clear all; close all;
% addpath('C:\Users\Song\Documents\9. FinalTool\exported-traced-adjacencies')
% addpath('C:\Users\Song\Documents\9. FinalTool\NeuronClasses')
% % collecting neuron information 
% importTable = readtable('neuronTable.csv');
% bodyID_list = string(table2array(importTable(:,1)));
% type_list = table2array(importTable(:,3));
% % location_list = table2array(importTable(:,2));
% 
% % initialize parameters
% nNeurons = numel(bodyID_list);
% tau_list{numel(bodyID_list),1}={};
% bursting_frequency = 1;
% adapt_constant = 1;
% 
% for i = 1:nNeurons
%     if string(type_list(i)) == "Neuron"
%         neuron = feval('Neurons', bodyID_list(i),'Normal');
%         tau_list{i} = neuron.tau;
%     elseif string(type_list(i)) == "SpikeAdapt"
%         neuron = feval('SpikeAdapt', bodyID_list(i),'SpikeAdapt',adapt_constant);
%         tau_list{i} = neuron.tau;
%     elseif string(type_list(i)) == "Bursting"
%         neuron = feval('Bursting', bodyID_list(i),'Bursting',bursting_frequency);
%         tau_list{i} = neuron.tau;
%     elseif string(type_list(i)) == ""
%         neuron = feval('Unknown', bodyID_list(i),'Unknown');
%         tau_list{i} = neuron.tau;
%     end
%     % More to add
% end
% 
% % construct connectome
% connectome = zeros(nNeurons, nNeurons);
% connectivity = readtable('connectionTest.csv');
% for i = 1:size(connectivity,1)
%     r = find(contains(bodyID_list, string(connectivity{i,1})));
%     c = find(contains(bodyID_list, string(connectivity{i,2})));
%     weight = double(connectivity{i,3});
%     connectome(r,c) = weight;
% end
% disp('Done');
% Q = pinv(connectome);

% connectome = load('connectome');
invertMat = load('invertedMat');
Q = invertMat.invertedMat;
%%
connectomeDim = 36;
% connectome = (sprand(connectomeDim,connectomeDim,0.2) + 0.1*eye(connectomeDim)) > 0;
% 
% nCluster = 4;
% NpC = 9;
% Connectivity = 4; % Should not exceed NpC
% Topology = 2;
% 
% Q = invertconnectome(connectome,nCluster,NpC,Connectivity,Topology);
% Q = invertedMat;
[spiking, raster] = snnGUI(Q,[],[],connectomeDim);
