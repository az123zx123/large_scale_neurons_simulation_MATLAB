function [yTarget, SPK] = snnGUI(Q, ~, ~, nNeuron)

nNeuron = size(Q,1);
figNumber = figure;
figNumber.WindowState = 'maximized';
% set(figNumber,'NumberTitle','off',...
%     'Name','Growth Transform Neuron Network Model',...
%     'Units','normalized','toolbar','figure',...
%     'Position',[0.05 0.1 0.9 0.8]);

colorMap = repmat(linspace(0,0.7,30)',1,3);
colorMap = [colorMap;[1 1 1];colorMap(end:-1:1,:)];
colorMap(1:30,1) = 1;
colorMap(32:61,3) = 1;
        
hConn=axes('Position',[0.05 0.20 0.40 0.70]);
conn_im = imagesc(hConn, round(Q,5));
colormap(hConn,colorMap)
set(gca,'xtick',[],'ytick',[])
xlabel('Post-synaptic')
ylabel('Pre-synaptic')
% title('Inversed Connectome')
caxis([-1 1])
caxis manual
colorbar

hRaster=axes('Position',[0.50 0.15 0.20 0.80]);
% title('Raster plot')
xlabel('Time (ms)')

hAveFR = axes('Position',[0.75 0.15 0.20 0.80]);
% title('Average Firing Rate')
xlabel('Average Firing Rate')

% Pause button
runFlag = 0;
runButton = uicontrol('Style', 'pushbutton','String','Run',...
    'Min',0,'Max',1,'Value',0, 'Units','normalized', ...
    'Position',[0.55 0.02 0.1 0.05],...
    'tag','runFlag','Callback',@changepars);

nIter = 1000;

nTimes = 1;
SPK = zeros(nNeuron,nIter*nTimes-1);

aveFR = zeros(1,nNeuron);

while ishandle(figNumber)
    if runFlag
        runButton.Enable = 'off';
        S = [];
        yInit = zeros(nNeuron,1);
        
        for t1 = 1:nTimes
            [yTarget,  yInit, spk] = snnFunc(Q,[],nIter+1,yInit);
            S = cat(2,S,spk);
        end
        
        runFlag = 0;
        runButton.Value = 0;
        runButton.Enable = 'on';
        
        SPK(:,:) = (logical(S(:,1:end-1))|logical(S(:,2:end)));
        axes(hRaster)
        imagesc(SPK(:,:))
%         title('Raster plot')
        xlabel('Time (ms)')
        
        aveFR = sum(SPK,2)/size(SPK,2);
        cVect = aveFR;
        axes(hAveFR);
        barh(aveFR); %# get counts and bin locations
        set(gca, 'YDir','reverse')

%         hScat = scatter([1:nNeuron], aveFR, 100, cVect, 'Filled');
%         hcbar = colorbar;
%         caxis([min(aveFR) max(aveFR)])
%         title('Average Firing Rate')
        xlabel('Average Firing Rate')
        

%         cla(hAveFR);
%         cVect = aveFR;
%         axes(hAveFR);
%         hold on;
%         for i = 1:20
%             plot(yTarget(i,:) - (i-1))
%             set(gca, 'XTick',[],'YTick',[]);
%         end
%         xlabel('Time'); ylabel('Neuron Responses');
%         xlim([0 nTimes*nIter]);
        
        
        
    end
    pause(0.1) % electrical synapse delay = 0.1 msec
end

function changepars(source, ~)
    t = source.Tag;
    switch t
        case 'runFlag'
            runFlag = source.Value;
    end
end

end