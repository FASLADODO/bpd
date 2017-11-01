classdef VIDEO
 
 methods(Static = true)
  
  function v = readVideo(varargin)
   
   file = varargin{1};
   
   if nargin == 1
    videoFReader = vision.VideoFileReader(which(file),'ImageColorSpace','Intensity');
    v = cell(1,1e+3);
    n = 0;
    while ~isDone(videoFReader)
     n = n+1;v(n) = {step(videoFReader)};
    end
    v = v(1:n);
    release(videoFReader);
    v = reshape(cell2mat(v),[size(v{1}),n]);
    return
   end
   
   if nargin ~= 3
    return
   end
   
   codec  = varargin{2};
   stream = varargin{3};
   
   tmp_file = 'tmp_vid.avi';
   fileID = fopen('temp_script','w');
   unix_script = strcat(stream,' -i %s -vcodec %s -y -loglevel quiet %s');
   fprintf(fileID,unix_script,which(file),codec,tmp_file);
   fclose(fileID);
   !bash temp_script
   
   videoFReader = vision.VideoFileReader(tmp_file,'ImageColorSpace','Intensity');
   
   v = cell(1,1e+3);
   n = 0;
   while ~isDone(videoFReader)
    n = n+1;v{n} = step(videoFReader);
   end
   v = v(1:n);
   release(videoFReader);
   v = reshape(cell2mat(v),[size(v{1}),n]);
   !rm temp_script tmp_vid.avi
  end
  
  function insertvideoSTIP(varargin)
   v     = varargin{1};
   stip  = varargin{2};
   if nargin > 2
    sc    = varargin{3};
    shape = varargin{4};
   else
    sc = 6;
    shape = true;
   end
   n = 0;
   nv(:,:,1,:) = v;nv(:,:,2,:) = v;nv(:,:,3,:) = v;
   for j = 1:size(stip,1)
    yxt = stip(j,:);
    lsc = sc * yxt(4);
    if shape
     nv(:,:,:,yxt(3)) = insertShape(nv(:,:,:,yxt(3)), ...
      'circle', [yxt(2),yxt(1),floor(lsc)],...
      'Color',rand(1,3),...
      'Opacity',0.6);     
    else
     nv(:,:,:,yxt(3)) = insertShape(nv(:,:,:,yxt(3)), ...
      'rectangle', [yxt(2) - lsc/2,yxt(1) - lsc/2,lsc,lsc],...
      'Color',rand(1,3),...
      'Opacity',0.6);          
    end
    n = n+1;
   end
   implay(nv)
   disp(n)
  end
  
 end
end