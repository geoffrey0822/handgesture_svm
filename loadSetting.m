function [labels,folders,names]=loadSetting(filename)
% fid=fopen('./setting.conf');
fid=fopen(filename);
tline=fgets(fid);
i=1;
labels={};
folders={};
classLabels=[];
names={};
while ischar(tline)
    if(strncmpi(tline,'label',5))
%         disp(tline);
        data=strsplit(tline,' ');
        name=data(4);
        label=data(2);
        if(iscellstr(name))
            name=char(name);
        end
        name=strrep(name,char(10),'');
        
        folder=strrep(fgetl(fid),char(10),'');
        while ~strncmpi(folder,'end',3)
            labels{i}=label;
            folders{i}=folder;
            names{i}=name;
            i=i+1;
            folder=strrep(fgetl(fid),char(10),'');
            folder=strtrim(folder);
        end
    end
    tline=fgetl(fid);
end

fclose(fid);
end