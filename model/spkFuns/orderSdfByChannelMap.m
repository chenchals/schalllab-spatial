function [ sdfOrdered ] = orderSdfByChannelMap( sdfStruct, channelOrder )
%ORDERSDFBYCHANNELMAP Summary of this function goes here
%   Detailed explanation goes here
  
    % Validate
    assert(size(sdfStruct,1) == numel(channelOrder),...
        sprintf(['Ordering single-unit Sdfs by channelMap is not yet implemented.\n'...
        'Use only for multi-unit sdfs.\n Number of units [%d] in sdf_mean '...
        'must equal number of channels [%d] in channelOrder'],...
        size(sdfStruct,1), numel(channelOrder)));
    
    %% For multi-unit mean sdfs
    sdfOrdered.channelMap = channelOrder(:);
    sdfOrdered.sdf_mean = cell2mat({sdfStruct.sdf_mean}');
    sdfOrdered.sdf_mean = sdfOrdered.sdf_mean(channelOrder,:);
    sdfOrdered.spikeIds = {sdfStruct(channelOrder).spikeIds}';
    
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
    

    
end


