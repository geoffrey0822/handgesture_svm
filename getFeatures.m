function [features,visual]=getFeatures(x)
    [features,visual]=extractHOGFeatures(x,'CellSize',[8,8],...
            'NumBins',9);
end