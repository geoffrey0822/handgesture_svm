function [files,dirs]=getDirInfos(pathStr)
files=[];
dirs=[];
if(strcmp(pathStr,'.') || strcmp(pathStr,'..'))
    return;
end
result=dir(pathStr);
result2=[dir(fullfile(pathStr,'*.jpg')); dir(fullfile(pathStr,'*.png'))];
files={result2(~[result2.isdir]).name};
n=1;
while(n<=size(files,2))
    files{1,n}=strcat(pathStr,'/',files{1,n});
    n=n+1;
end
folder={result([result.isdir]).name};
i=1;
while (i<=size(folder,2))
    %disp(folder{1,i});
    if(~strcmp(folder{1,i},'.') && ~strcmp(folder{1,i},'..'))
        [tmpFile,tmpDir]=getDirInfos(strcat(pathStr,'/',folder{1,i}));
        if(size(tmpFile)>0)
            k=1;
            h=size(files,2);
            while(k<=size(tmpFile,2))
                files{1,h+k}=tmpFile{k};
                k=k+1;
            end
%             files=[files,tmpFile];
        end
    end
    i=i+1;
end
%dirs={result([result.isdir && ~strcmp(result.name,'.') && ~strcmp(result.name,'..')]).name};
end