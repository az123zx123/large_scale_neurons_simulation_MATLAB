function [y, yInit, spk] = snnFunc(Q, ~, nIter, yInit)
% Initialize iteration variables
% tau_list = evalin('base','tau_list');
nNeurons = size(Q,1); % Set synaptic weight matrix
thr = 0.0; % Spike threshold
lambda = 10*ones(nNeurons,1); % Convergence hyperparameters

Vi = -0.3*ones(nNeurons,1);
y = zeros(nNeurons,nIter); % Spike
y(:,1) = yInit;  

% Modulation Function  
% tau = zeros(numel(tau_list),1);

% External stimuli current
bi = randn(nNeurons,1);

% Regularization hyper-parameter
% psi = C if Vi > thr; psi = 0 if Vi < thr
C = .5; 

% Updating
for t = 2:nIter
     ind = (Vi > thr);        
     Vi(Vi > thr) = thr;
     psi = ind*C;
     G = -Q*Vi - bi + psi;
%      for i = 1:nNeurons
%         tau(i) = arrayfun(tau_list{i},1);
%      end
%      Vi = ((G + lambda.*Vi)./(Vi.*G + lambda)-Vi)./tau-Vi;
          Vi = ((G + lambda.*Vi)./(Vi.*G + lambda)-Vi)-Vi;
     y(:,t) = Vi + psi;
     disp(t);
end
yInit = y(:,end);
spk = y(:,2:end) > thr;
end