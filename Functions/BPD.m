classdef BPD
 methods(Static = true)
  
  function code = encode(v,pttn,stip)
   
   % support region around the STIP
   s_ = floor(9*sqrt(stip(4)));
   t_ = floor(9*sqrt(stip(5)));
   
   y0 = stip(1);
   x0 = stip(2);
   t0 = stip(3);
   
   ry = floor((1:s_)+y0-s_/2);
   rx = floor((1:s_)+x0-s_/2);
   rt = floor((1:t_+1)+t0-t_/2);
   
   sv = v(ry,rx,rt);
   
   % space of differences
   sv = abs(diff(sv,[],3));
   
   % orientation asignment
   sv = BPD.flipvideo(sv); 
   
   % fist 32 pairs generation
   codea = BPD.subencCAT(sv,pttn,32); 
   
   % 2 x 2 x 2 subvideo volume division
   Y = BPD.splitInt(size(sv,1),2); 
   X = BPD.splitInt(size(sv,2),2);
   T = BPD.splitInt(size(sv,3),2);
   
   sv = mat2cell(sv,Y,X,T);
   
   % 4 pairs generation of the subregions
   codeb = cellfun(@(var) BPD.subencCAT(var,pttn,4),sv,'UniformOutput',false);
   
   codeb = cell2mat(codeb(:));
   
   % final concatenation
   code = [codea',codeb'];
   
  end
  
  function code = subencCAT(sv,pttn,n)
   
   Y = BPD.splitInt(size(sv,1),4);
   X = BPD.splitInt(size(sv,2),4);
   T = BPD.splitInt(size(sv,3),2);
   
   sv = mat2cell(sv,Y,X,T);
   
   sva = sv(:,:,1);
   sva = sva(:);
   sva = cellfun(@(x) BPD.mergepx(x),sva,'UniformOutput',false);
   
   svb = sv(:,:,2);
   svb = svb(:);
   svb = cellfun(@(x) BPD.mergepx(x),svb,'UniformOutput',false);
   
   ksax = cellfun(@(var) BPD.pttnscan(sva,var),pttn(1:n,1),'UniformOutput',false);
   ksay = cellfun(@(var) BPD.pttnscan(sva,var),pttn(1:n,2),'UniformOutput',false);
   
   ksbx = cellfun(@(var) BPD.pttnscan(svb,var),pttn(1:n,1),'UniformOutput',false);
   ksby = cellfun(@(var) BPD.pttnscan(svb,var),pttn(1:n,2),'UniformOutput',false);
   
   ksax = cellfun(@mean ,ksax);
   ksay = cellfun(@mean ,ksay);
   
   ksbx = cellfun(@mean ,ksbx);
   ksby = cellfun(@mean ,ksby);
   
   pairs_x = ksax+ksby;
   pairs_y = ksay+ksbx;
   
   code = pairs_x > pairs_y;
      
  end
  
  function ks = pttnscan(sv,idx)
   ks = sv(idx);
   ks = vertcat(ks{:});
  end
  
  function px = mergepx(c)
   px = c(:);
  end
  
  function [r,p] = xytSpV(nx,ny,nt)
   p = struct;
   p.x = zeros(nx,ny,nt);
   p.y = zeros(nx,ny,nt);
   p.t = zeros(nx,ny,nt);
   for t = 1:nt
    for x = 1:nx
     for y = 1:ny
      p.y(y,x,t) = y;
      p.x(y,x,t) = x;
      p.t(y,x,t) = t;
     end
    end
   end
   a = p.y;
   b = p.x;
   c = p.t;
   r = [a(:),b(:),c(:)];
  end
  
  function v = flipvideo(v)

   o = [0,pi/2,pi,3*pi/2];
   o = cos(o) + 1j * sin(o);
   
   [Y,X,T] = size(v);
   
   hv = v(:,:,1:floor(T/2));
   
   [r,~] = BPD.xytSpV(Y,X,1);
   
   hv = sum(hv,3);
   
   hv = hv(:);
   
   x = hv .* r(:,1);
   y = hv .* r(:,2);
   
   c = sum([y,x])/(sum(hv)) - [Y,X]/2;
   
   c = c(1)+1j*c(2);
   c = c/abs(c);
   
   o = o-c;
   
   o = o .* conj(o);
   
   [~,o] = min(o);
   
   switch o
    case 1
     v =  fliplr(v);
    case 2
     v =  flipud(v);
    otherwise
    return
   end
   
   
  end
   
  function field = pttnfield()
   
   field = cell(32,2);
   
   field(01,:) = {[1;2;3;4;5;6;7;8],[9;10;11;12;13;14;15;16]};
   field(02,:) = {[1;5;9;13;2;6;10;14],[3;7;11;15;4;8;12;16]};
   field(03,:) = {[1;5;2;6;11;15;12;16],[9;13;10;14;3;7;4;8]};
   field(04,:) = {[1;5;9;13;4;8;12;16],[2;6;10;14;3;7;11;15]};
   field(05,:) = {[1;2;3;4;9;10;11;12],[5;6;7;8;13;14;15;16]};
   
   field(06,:) = {[1;2;3;4;13;14;15;16],[5;6;7;8;9;10;11;12]};
   field(07,:) = {[1;5;9;13;3;7;11;15],[2;6;10;14;4;8;12;16]};
   field(08,:) = {[2;6;3;7;9;13;12;16],[1;5;10;11;14;15;4;8]};
   field(09,:) = {[1;2;7;8;11;12;13;14],[3;4;5;6;9;10;15;16]};
   field(10,:) = {[1;4;6;7;10;11;13;16],[2;3;5;9;8;12;14;15]};
   
   
   field(11,:) = {[1;5;3;7;13;14;12;16],[2;6;4;8;9;13;11;15]};
   field(12,:) = {[1;2;7;8;9;10;15;16],[3;4;5;6;11;12;13;14]};
   field(13,:) = {[1;3;6;10;8;12;13;15],[2;4;5;6;7;11;14;16]};
   field(14,:) = {[1;4;6;7;9;11;14;16],[2;4;5;7;10;12;13;15]};
   field(15,:) = {[1;3;6;8;9;11;14;16],[2;4;5;7;10;12;13;15]};

   field(16,:) = {[1;2;5;6],[3;7;4;8]};
   field(17,:) = {[9;13;10;14],[11;15;12;16]};
   field(18,:) = {[1;2;3;4],[5;6;7;8]};
   field(19,:) = {[9;10;11;12],[13;14;15;16]};
   field(20,:) = {[1;5;3;7],[2;6;4;8]};

   field(21,:) = {[10;14;12;16],[9;13;11;15]};
   field(22,:) = {[1;5;2;6],[9;13;10;14]};
   field(23,:) = {[3;7;4;8],[11;15;12;16]};
   field(24,:) = {[1;5;9;13],[2;6;10;14]};
   field(25,:) = {[3;7;11;15],[4;8;12;16]};
 
   field(26,:) = {[1;2;9;10],[5;6;13;14]};
   field(27,:) = {[3;4;11;12],[7;8;15;16]};
   field(28,:) = {[1;5;2;6],[11;15;12;16]};
   field(29,:) = {[3;7;4;8],[9;10;13;14]};
   field(30,:) = {[1;5;4;8],[10;11;14;15]};

   field(31,:) = {[1;2;13;14],[7;11;8;12]};
   field(32,:) = {[2;3;14;15],[5;9;8;12]};
  
  end
  
  function s = splitInt(a,n)
   x = floor(a/n);
   s = x * ones(n,1);
   m = 0;
   while sum(s) ~= a
    m = m+1;
    s(m) = s(m)+1;
   end
  end
  
 end
end