classdef BAG
 methods(Static = true)
  
  function cBag = selectSubBag(Bag,sbj,op)
   
   if strcmp(op,'select')
    cBag = cell(numel(Bag),1);
   else
    cBag = Bag;
   end
   
   for k = 1:numel(Bag)
    switch op
     case 'remove'
      cBag{k}(sbj) = [];
     case 'select'
      cBag{k} = Bag{k}(sbj);
    end
   end
  end
  
  function Bag = Bag2FullMatrix(Bag)
   for k = 1:numel(Bag)
    Bag{k} = cell2mat(Bag{k});
   end
   Bag = cell2mat(Bag);
  end
  
 end
end
 