Z = {'D-Uprobe-MG-021616a-FEF.plx''D-Uprobe-MG-021916a-FEF.plx''D-Uprobe-MG-022216a-FEF.plx''D-Uprobe-MG-022316a-FEF.plx''D-Uprobe-MG-022516a-FEF.plx''D-Uprobe-MG-022616a-FEF.plx''D-Uprobe-MG-022916a-FEF.plx''D-Uprobe-MG-030316a-F2-FEF.plx''D-Uprobe-MG-030716a-F2-FEF.plx''D-Uprobe-MG-030816a-F2-FEF.plx''D-Uprobe-MG-031016a-F2-FEF.plx''D-Uprobe-MG-031116a-F2-FEF.plx'};toks=regexp(Z,'.*-(\d*a).*','tokens')tok=cellfun(@(x) datestr(datenum(x{1},'mmddyya'),'yyyy-mm-dda') ,toks,'UniformOutput',false)