classdef HIST
 methods(Static = true)
  
  function [Bag,Lbl] = Bag2Hist(Bag,BOV)
   Lbl = cell(numel(Bag),1);
   for k = 1:numel(Bag)
    A = Bag{k};
    parfor j = 1:numel(Bag{k})
     A{j} = HIST.getHistogram(A{j},BOV);
    end
    Lbl{k} = ones(numel(Bag{k}),1) * k;
    Bag{k} = cell2mat(A);
   end
   Bag = cell2mat(Bag);
   Lbl = cell2mat(Lbl);
  end
  
  function h = getHistogram(codes,BOV)
    h = zeros(1,size(BOV,1));
    for k = 1:size(codes,1)
     cls = HIST.dist2BOV(codes(k,:),BOV);
     h(cls) = h(cls) + 1;
    end
    h = h/sum(h);
  end
  
  function cls = dist2BOV(x,BOV)
   A = bsxfun(@xor,BOV,x);
   A = sum(A,2);
   [~,cls] = min(A);
  end
  
 end
end