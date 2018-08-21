function [featVector,visualize]=getCustomFeature(src)
%     region1=detectMSERFeatures(src,'ThresholdDelta',2,...
%         'MaxAreaVariation',.1);
%     region2=detectMSERFeatures(src,'ThresholdDelta',2,...
%         'MaxAreaVariation',0.25);
%     region3=detectMSERFeatures(src,'ThresholdDelta',.25,...
%         'MaxAreaVariation',0.25);
%     disp(region1);
%     disp(region2);
%     disp(region3);
%     featVector=region1;
%     visualize=zeros(size(src,1),size(src,2));
%     for i=1:size(region1.Location,1)
%         for j=1:size(region1.PixelList{i},1)
%             visualize(region1.PixelList{i}(j,1),...
%                 region1.PixelList{i}(j,2))=1;
%         end
%     end
    output=CFeatureExtraction(src);
    featVector=output.vector';
    visualize=output.edges;
end