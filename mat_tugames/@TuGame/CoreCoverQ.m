function ccQ=CoreCoverQ(clv,tol)
% CORECOVERQ checks if the core cover a TU game v is non-empty.
%
% Usage:  ccQ=CoreCoverQ(v,tol
% Define variables:
%  output:
%  ccQ      -- Returns 1 (true) whenever the core cover exists, 
%              otherwise 0 (false).
%
%  input:
%  clv      -- TuGame class object.
%  tol      -- A tolerance value. Default is 10^7*eps
%
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   12/01/2014        0.6             hme
%                


if nargin < 2
  tol=10^7*eps;
end

ccQ=clv.compromiseAdmissibleQ(tol);
