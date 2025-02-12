function [ sdfOrdered ] = orderSdfByChannelMap( sdfStruct, channelOrder )
%ORDERSDFBYCHANNELMAP Summary of this function goes here
%   Detailed explanation goes here
  
    % Validate
    assert(size(sdfStruct,1) == numel(channelOrder),...
        sprintf(['Ordering single-unit Sdfs by channelMap is not yet implemented.\n'...
        'Use only for multi-unit sdfs.\n Number of units [%d] in sdf_mean '...
        'must equal number of channels [%d] in channelOrder'],...
        size(sdfStruct,1), numel(channelOrder)));
    % the channel Order must be numbers form 1 to n.  So if we have channel
    % order as 33,34,35,...64 -> these need to be offset to -32 effectively
    % making them 1-32 (This is the case for recording with 2 probes
    channelOffset = 0;
    if min(channelOrder) > 1
        channelOffset = min(channelOrder) - 1;
    end
    channelOrder = channelOrder - channelOffset;
    
    %% For multi-unit mean sdfs
    sdfOrdered.channelMap = channelOrder(:);
    sdfOrdered.sdfMean = cell2mat({sdfStruct.sdfMean}');
    sdfOrdered.sdfMean = sdfOrdered.sdfMean(channelOrder,:);
    sdfOrdered.sdfPopulationZscoredMean = cell2mat({sdfStruct.sdfPopulationZscoredMean}');
    sdfOrdered.sdfPopulationZscoredMean = sdfOrdered.sdfPopulationZscoredMean(channelOrder,:);
    sdfOrdered.populationMean = sdfStruct.populationMean;
    sdfOrdered.populationStd = sdfStruct.populationStd;
    
    sdfOrdered.spikeIds = {sdfStruct(channelOrder).spikeIds}';
    sdfOrdered.sdfWindow = sdfStruct(1).sdfWindow;
    sdfOrdered.nTrials = sdfStruct(1).nTrials;
    
    %% For multi-unit trial sdfs
    nTrials = size(sdfStruct(1).sdf,1);
    % create ordering vector where
    % If there are 25 trials then
    % For channelOrder == 1 -> replace with 1:25
    % For channelOrder == 2 -> replace with 26:50
    % For channelOrder == 32 -> replace with 776:800
    sdfOrdered.trialMap = cell2mat(arrayfun(@(x) [(x-1)*nTrials+1:x*nTrials],channelOrder,'UniformOutput',false))';
    % rows = nTrials*nChannels; cols = length(sdfWindow)
    sdfOrdered.sdf = cell2mat({sdfStruct.sdf}');
    sdfOrdered.sdf = sdfOrdered.sdf(sdfOrdered.trialMap,:);
    sdfOrdered.sdfPopulationZscored = cell2mat({sdfStruct.sdfPopulationZscored}');
    sdfOrdered.sdfPopulationZscored = sdfOrdered.sdfPopulationZscored(sdfOrdered.trialMap,:);
    
end


