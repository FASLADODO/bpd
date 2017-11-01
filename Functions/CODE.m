classdef CODE
 
 methods(Static = true)
  
  function files = codeFROMfile(des)
   
   files = cell(1);
   stip  = cell(1);
   
   load('KTHfiles.mat')
   load('STIPsLaptev.mat');
      
   for k = 1:numel(files)
    for j = 1:numel(files{k})
     fprintf('... coding video in %d:%d out of %d\n',k,j,numel(files{k}));
     v = VIDEO.readVideo(files{k}{j});
     files{k}{j} = CODE.codeVid(v,stip{k}{j},des);
    end
   end
  end
  
  function code = codeVid(v,stip,des)
   
   code = cell(size(stip,1),1);
   kpt  = true(size(stip,1),1);
   f_h = @des.encode;
   pttn = BPD.pttnfield();
   
   parfor k = 1:size(stip,1)
    try
     code{k} = f_h(v,pttn,stip(k,:));
    catch
     kpt(k) = false;
    end
   end
   code = cell2mat(code(kpt));
  end

 end
end
