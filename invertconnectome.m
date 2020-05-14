function Q = invertconnectome(W, Ncluster, NpC, Connectivity, Topology)
% W - the connectome (elements are 1 and 0), 
% W(i,j) = 1, means neuron i and j are connected
% Ncluster - the number of clusters or chips (fully connected inside)
% NpC - Number of neurons per cluster/chip (Chip/Cluster Dimensions)
% Connectivity - how many neurons are connected b/w any two chips(small)
% Topology - 1D, 2D, 3D

% Mask Matrix
cluster = rand(NpC, NpC);
ConCell = repmat({cluster},1,Ncluster);
BigCon = blkdiag(ConCell{:});
chipDensity = Connectivity/NpC; % interconnecting neuron densities

% 1D
if Topology == 1
    for i = 1:Ncluster-1
        % interconnection neurons 
        BigCon(1+NpC*(i-1):NpC*i, NpC*i+1:NpC*(i+1)) = sprand(NpC, NpC, chipDensity);
        BigCon(NpC*i+1:NpC*(i+1), 1+NpC*(i-1):NpC*i) = sprand(NpC, NpC, chipDensity);
    end
end
% 2D
if Topology == 2
    nRows = 2;
    chipCol = ceil(Ncluster / nRows);
    for i = 1:Ncluster-1
        if mod(i,chipCol) ~= 0
            BigCon(1+NpC*(i-1):NpC*i, NpC*i+1:NpC*(i+1)) = sprand(NpC, NpC, chipDensity);
            BigCon(NpC*i+1:NpC*(i+1), 1+NpC*(i-1):NpC*i) = sprand(NpC, NpC, chipDensity);
        end
    end
    for i = 1:Ncluster-chipCol
        BigCon(1+NpC*(i+chipCol-1):(i+chipCol)*NpC, NpC*(i-1)+1:NpC*i) = sprand(NpC, NpC, chipDensity);
        BigCon(NpC*(i-1)+1:NpC*i,1+NpC*(i+chipCol-1):(i+chipCol)*NpC) = sprand(NpC, NpC, chipDensity);
    end
end

M = sparse(BigCon>0);
[r c] = size(W);
Q = speye(r);
constraints = [-1 1];
nIter = 5000;

stepSize = 5/25000;

W = sparse(W);
objVals = zeros(nIter, 1);
I = eye(r);

for i = 1:nIter


    res = sparse(I - W*Q);
    objVals(i) = normest(res)^2;

    Q = sparse(Q + stepSize * (W' * res));
    Q = sparse(Q .* M);
    
    Q(Q < constraints(1)) = -1; Q(Q > constraints(2)) = 1;
        
    fprintf('[%d/%d] [step: %.1e] [objective: %.1e]\n',...
        i, nIter, stepSize, objVals(i));
    figure(1);
    set(gcf, 'Color', 'w');
    loglog(1:i, objVals(1:i), 'b-', i, objVals(i), 'b*', 'LineWidth', 2);
    grid on;
    axis tight;
    xlabel('iteration');
    ylabel('objective');
    title(sprintf('cost: %.4e', objVals(i)));
    xlim([1 nIter]);
    set(gca, 'FontSize', 16);
    drawnow;
end
