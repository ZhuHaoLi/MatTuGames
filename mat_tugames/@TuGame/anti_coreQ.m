function [acrq x]=anti_coreQ(clv,tol)
% ANTI_COREQ checks the existence of the anti-core of game v.
% 
%
% Usage: [acrq a_x]=anti_coreQ(v,tol)
% Define variables:
%  output:
%  acrq     -- Returns 1 (true) or 0 (false).
%  x        -- The smallest allocation that satisfies all anti-core constraints.
%  input:
%  v        -- TuGame class object. 
%  tol      -- Tolerance value. Its default value is set to 10^8*eps.


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   11/22/2012        0.3             hme
%                

if nargin<2
 tol=10^5*eps;
end

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;

S=1:N;
for k=1:n, PlyMat(:,k) = bitget(S,k);end
S(N)=[];
v1(S)=v(S)-tol;
v1(N)=v(N);

opts.Display='off';
opts.Simplex='on';
opts.LargeScale='on';
opts.Algorithm='dual-simplex';
opts.TolFun=1e-10;
opts.TolX=1e-10;
opts.TolRLPFun=1e-10;
%% for dual-simplex
opts.MaxTime=9000;
opts.Preprocess='none';
opts.TolCon=1e-6;
opts.MaxIter=10*(N+n);


%opts=optimset('Simplex','on','LargeScale','on','Algorithm','simplex','MaxIter',128);
[x,fval,exitflag]=linprog(ones(n,1),PlyMat,v1,[],[],[],[],[],opts);
x=x';
acrq=abs(v(N)-fval)<=abs(tol);

