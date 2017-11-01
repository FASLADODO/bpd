classdef MISC
 
 methods(Static = true)
  
  function [train,validate,test] = seedKTH()
   
   x1 = [11,12,13,14,15,16,17,18];
   x2 = [19,20,21,23,24,25,01,04];
   x3 = [22,02,03,05,06,07,08,09,10];
   s = [x1,x2,x3];
   
   train    = cell(8,1);
   validate = cell(8,1);
   test     = cell(9,1);
   
   for k = 1:numel(train)
    x = s(k);
    train(k) = {((x-1)*4+1:x*4)'};
   end
   
   train = cell2mat(train);
   
   for k = 1:numel(validate)
    x = s(k+8);
    validate(k) = {((x-1)*4+1:x*4)'};
   end
   
   validate = cell2mat(validate);
   
   for k = 1:numel(test)
    x = s(k+16);
    test(k) = {((x-1)*4+1:x*4)'};
   end
   
   test = cell2mat(test);
  end
  
  function dockStyle()
   set(0, 'ShowHiddenHandles', 'on');
   set(gcf,'WindowStyle','docked');
   set(0,'DefaultFigureWindowStyle','docked')
   %warning('off','all');
  end
  
 end
end