function y=rotateResample(x)
angles=[-45 -20 -10 0 10 20 45];
% disp(angles);
for i=1:size(angles,2)
    y{i}=imrotate(x,angles(i),'bilinear','crop');
end
end