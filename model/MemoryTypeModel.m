classdef MemoryTypeModel < EphysModel
    %MEMORYTYPEMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    % dataSource =
    % '/Volumes/schalllab/Users/Chenchal/Jacob/data/joule/jp121n01.mat'
    %% Public methods
    methods
        %% Constructor
        function obj = MemoryTypeModel(source)
            obj.dataSource = source;
            [~,f,e] = fileparts(source);
            obj.sourceFile = [f e];
            obj.checkFileExists;
        end
        
        %% Abstract Functions implemented
        %% GETEVENTDATA
        function [ outVars ] = getEventData(obj, eventNames)

            if iscellstr(eventNames)
                outVars = load(obj.dataSource, eventNames{:});
            elseif ischar(eventNames)
                outVars = load(obj.dataSource, eventNames);
            else
                throw(MException('MemoryTypeModel:getVariables','eventNames must be cellstr or char'));
            end
            outVars = coerceCell2Mat(obj, outVars);           
        end
        
        %% GETSPIKEDATA
        function [ outVars ] = getSpikeData(obj, varargin)
            % Vargars:
            %    spikeIdPattern : For mat file with vars DSP01a, DSP09b
            %    spikeIdVar : Spike IDs are in a variable: SessionData.spikeUnitArray
            %    spiketimeVar : A cell array of { nTrials x nUnits}
            %    channelMap : Linear mapping of channels. 
            %
            % Usage:
            % [ out ] = obj.getSpikeData(...
            %           'spikeIdVar', 'SessionData.spikeUnitArray',...
            %           'spiketimeVar', 'spikeData',...
            %           'channelMap', [9:16,25:32,17:24,1:8])
           try
                args = parseArgs(obj, varargin);
                if ~isempty(args.spikeIdPattern)
                   throw(MException('MemoryTypeModel:getSpikeData','Not yet implemented for spikeIdPattern')); 
                elseif ~isempty(args.spikeIdVar)
                    if ~contains(who('-file',obj.dataSource),args.spiketimeVar)
                        throw(MException('MemoryTypeModel:getSpikeData',...
                            sprintf('Spike data variable [ %s ] does not exist  in file %s',...
                            args.spiketimeVar,obj.dataSource)));
                    end
                    % spiketimes
                    t = load(obj.dataSource,args.spiketimeVar);
                    outVars.spiketimes = t.(args.spiketimeVar);
                    clear t
                    % spikeIds - in a struct variable 
                    v = cellstr(split(args.spikeIdVar,'.'));
                    s = load(obj.dataSource,v{1});
                    s = s.(v{1});
                    tempSpk.spikeIds = s.(v{2});
                    clear s v
                else
                    throw(MException('MemoryTypeModel:getSpikeData','Unknown process to get spikeData'));
                end
                tempSpk.spikeIds =tempSpk.spikeIds';
                %Channel map order for spike Ids
                channelMap = args.channelMap;
                for ch = 1:max(channelMap)
                    channel = channelMap(ch);
                    spikeChannels = ~cellfun(@isempty,regexp(tempSpk.spikeIds,num2str(ch,'%02d')));
                    tempSpk.unitSortOrder(spikeChannels,1)= channel; 
                    tempChan.channelIds{ch,1} =  ['chan',num2str(ch,'%02d')];
                    % for comparing with jacob's code
                    tempSpikeUnitArray{1,ch} =  ['spikeUnit',num2str(ch,'%02d')];
                end
                tempChan.channelSortOrder(:,1)= channelMap';                
                outVars.spikeIdsTable = struct2table(tempSpk);
                outVars.channelIdsTable = struct2table(tempChan);
                outVars.spikeUnitArray = tempSpikeUnitArray;
            catch ME
                msg = [ME.message, char(10), char(10), help('MemoryTypeModel.getSpikeData') ];
                error('MemoryTypeModel:getSpikeData', msg);                
            end
        end
        
        %% GETTRILALIST
        function [ outVars ] = getTrialList(obj, varargin)
            
            error('Not yet implemented..')
        end
        
    end
    %% Helper Functions
    methods (Access=private)
        function [ vars ] = coerceCell2Mat(obj,vars)
            fields = fieldnames(vars);
            for jj=1:numel(fields)
                field = fields{jj};
                if iscell(vars.(field)) && ~iscellstr(vars.(field))
                    maxDim = max(cellfun(@(x) max(size(x)),vars.(field)));
                    if  maxDim == 1 % each value is a scalar
                        vars.(field) = cell2mat(vars.(field));
                    else % May be NaN pad if numeric?
                        % {[1xn1] [1xn2],...[1xnn]} -> diff vector sizes
                        % {[m1xn1] [m2xn2],...mnxnn]} --> diff matrices
                        % {{} {} ...{}}
                    end
                end
            end
        end
        
        function [ args ] = parseArgs(obj,inArgs)
            argsObj = inputParser;
            argsObj.addParameter('spikeIdPattern', '', @(x) assert(ischar(x),'Value must be a char array'));
            argsObj.addParameter('spikeIdVar', '', @(x) assert(ischar(x),'Value must be a char array'));
            argsObj.addParameter('spiketimeVar', '', @(x) assert(ischar(x),'Value must be a char array'));
            argsObj.addParameter('channelMap', [], @(x) assert(isnumeric(x),'Value must be a vector of channel numbers'));
            argsObj.parse(inArgs{:});
            args = argsObj.Results;
        end
        
    end
end

