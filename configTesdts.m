clear all;
fname='./setting.conf';
[labels,folders]=loadSetting(fname);
for i=1:size(labels,2)
    disp(strcat(labels{i},'=>',folders{i}));
end