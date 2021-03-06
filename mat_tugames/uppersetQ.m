function usQ=uppersetQ(v)
% UPPERSETQ checks if the lower set is non empty.
% Is a kernel catcher under certain conditions if it is non-empty.
%
%  Usage: usQ=uppersetQ(v) 
%
%
% Define variables:
%  output:
%  usQ      -- Returns true (1) if the upper set is non empty,
%              otherwise false (0).
%  input:
%  v        -- A Tu-Game v of length 2^n-1. 
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   12/05/2014        0.6             hme
%
if nargin<1
    error('The game must be given!');
else
   N=length(v);
   [~, n]=log2(N);
end

pa=proper_amount(v);
usQ=sum(pa)>=v(N);
