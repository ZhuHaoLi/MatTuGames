function fdv=feasible_dividends(clv,cs)
% FEASIBLE_DIVIDENDS computes a collection of feasible dividends from a 
% Tu-game v and a coalition structure cs.
%
% Source: E. Calvoy and Esther Gutiérrez-López (2015); The value in games with restricted cooperation
%         http://www.erices.es/upload/workingpaper/68_0115.pdf
%
% Usage: fdv=feasible_dividends(v,cs)
% Define variables:
%  output:
%  fdv       -- A collection of feasible dividends.
%
%  input:
%  clv      -- TuGame class object.
%  cs       -- A coalition structure like 
%              cs = [13    51    74    82    97   102   120   127]
%              for {[1 2 5 6] [1 3 4], [1 6 7], [2 3 6 7], [2 4 7], 
%                   [2 5 7], [4 5 6 7], [1 2 3 4 5 6 7]}.
%              The grand coalition must be given.
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   12/23/2015        0.8             hme
%

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
if nargin < 2
   if isa(clv,'TuVal')
      cs = clv.tu_cs;
      str='cs';
   elseif isa(clv,'p_TuVal')
      cs = clv.tu_cs;
      str='cs';
   else
      if isempty(cs)
         error('A game and coalition structure must be given!');
      else
         if iscell(cs)
            cs=clToMatlab(cs);
         end
      end
   end
else
   if isempty(cs)
      error('A game and coalition structure must be given!');
   else
      if iscell(cs)
         cs=clToMatlab(cs);
      end
   end
end

lF=length(cs);
sF=1:lF-1;
fdv=zeros(1,lF);

for k=1:lF
    sS=SubSets(cs(k),n);
    FwS=cs;
    FwS(k)=[];
    FS=sF(ismember(FwS,sS));
    if isempty(FS)
       fdv(k)=v(cs(k));
    else
       fdv(k)=v(cs(k))-sum(fdv(FS));
    end
end

