function [x1, fmin]=nucl_lpp(clv,tol)
% NUCL_LLP computes the nucleolus of game v using the optimization toolbox.
% Uses now Dual-Simplex (Matlab R2015a).
%
% Usage: [x, fmin]=nucl_llpclv,tol)
% Define variables:
%  output:
%  x1        -- The nucleolus of game clv.
%  fmin      -- The minmax excess value.
%
%  input:
%  clv      -- TuGame class object.
%  tol      -- Tolerance value. Its default value is set to 10^8*eps.


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   12/23/2014        0.6             hme
%   03/29/2015        0.7             hme
%                


if nargin<2
 tol=10^6*eps;
end

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
essQ=clv.tuessQ;
vi=clv.tuvi';
if essQ==0
   error('Game is not essential!')
end
if N==3
  x1=StandardSolution(v);
  return
end

S=1:N;
for k=1:n, A1(:,k) = -bitget(S,k);end
A1(N+1,:)=-A1(end,:);
A1(:,end+1)=-1;
A1(N:N+1,end)=0;
A2=sparse(A1);
B1=[-v';v(N)];
bS2=[];
C=[zeros(1,n),1];

ra = reasonable_outcome(clv)';
cvr=vi==ra;
if any(cvr)
   fi=find(cvr);
   ra(fi)=Inf;
end
lb=[vi;-Inf];
ub=[ra;Inf];

opts.Display='off';
opts.Simplex='on';
opts.LargeScale='on';
opts.Algorithm='dual-simplex';
opts.TolFun=1e-10;
opts.TolX=1e-10;
opts.TolRLPFun=1e-10;
%opts
%% for dual-simplex
opts.MaxTime=9000;
opts.Preprocess='none';
opts.TolCon=1e-6;
opts.MaxIter=10*(N+n);
it=0:-1:1-n;
bA=find(A1(:,end)==0)';
while 1
  [xmin,fmin,exitflag,~,lambda]=linprog(C,A2,B1,[],[],lb,ub,[],opts);
  x=xmin;
  x1=x';
  x1(end)=[];
  bS1=find(lambda.ineqlin'>tol);
  bS2=setdiff(bS1,bA);
  if isempty(bS2)==1
     break;
  end
  bA=[bA,bS2];
  mS2=rem(floor(bA(:)*pow2(it)),2);
  rk=rank(mS2);
  B1(bS2)=B1(bS2)+fmin;
  if rk==n
     x=(-mS2\B1(bA))';
     break;
  end
  A1(bS2,end)=0;
  A2=sparse(A1);
end
