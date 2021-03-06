function lcrQ=belongToLeastCoreQ(clv,x,tol)
% BELONGTOLEASTCOREQ checks whether the imputation x belongs to the
% least core of game v.
% 
%

% Define variables:
%  output:
%  lcrQ      -- It returns 1 (true) or 0 (false).
%
%  input:
%  clv      -- TuGame class object.
%  x        -- payoff vector of size(1,n) 
%  tol      -- A positive tolerance value. The default is set to
%              10^8*eps'.

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   11/09/2013        0.5             hme
%                

if nargin < 3
   tol=10^6*eps; 
end    

fmin=LeastCore(clv,tol);
exc=excess(clv,x);
mexc=max(exc);
lcrQ=fmin>=mexc-tol;
