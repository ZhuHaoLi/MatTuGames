function [aprkQ, smat, e]=Anti_ModPrekernelQ(clv,x,tol)
% ANTI_MODPREKERNELQ checks whether the imputation x is a modified anti-pre-kernel element 
% of the TU-game v.
% 
%  Usage:    [aprkQ smat e]=clv.Anit_ModPrekernelQ(x,tol);
%
%
% Define variables:
%  output:
%  aprkQ    -- Returns 1 (true) whenever the impuatation x is 
%              a modified anti-pre-kernel element, otherwise 0 (false).
%  smat     -- Matrix of minimum surpluses.
%  input:
%  clv      -- TuGame class object.
%  x        -- payoff vector of size(1,n) (optional)
%  tol      -- Tolerance value. By default, it is set to 10^6*eps.
%             (optional) 
    

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   03/11/2018        1.0             hme
%                

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;

if nargin < 2
  x=clv.Anti_ModPreKernel();
  warning('APKQ:NoPayoffInput','Computing default payoff!');
  tol=10^6*eps;
elseif nargin< 3
  tol=10^6*eps;
end
smat=-inf;
e=0;
effQ=abs(v(end)-sum(x))<tol;
aprkQ=0;
if effQ==0, return; end 

exc_v=clv.excess(x);
dv=clv.dual_game();
exc_dv=excess(dv,x);
sx_v=sort(exc_v,'ascend');
sx_dv=sort(exc_dv,'ascend');
mx_v=sx_v(1);
mx_dv=sx_dv(1);
v_x=zeros(1,N);

for k=1:N-1
    v_x(k)=min(v(k)+mx_dv,dv(k)+mx_v);
end
v_x(N)=v(N);

smat=msrpls(v_x,x,n);
lms=abs(smat-smat')<tol;
aprkQ=all(all(lms));


%-------------------------------------
function smat=msrpls(v,x,n) 
% Computes the minimum surpluses w.r.t. payoff x.
% output:
%  smat     -- Matrix of minimum surpluses.
%
%  input:
%  v      -- A Tu-Game v of length 2^n-1.
%  x      -- payoff vector of length(1,n)


% the excesses of x wrt. the game v
% Borrowed from J. Derks
Xm=x(1); for ii=2:n, Xm=[Xm x(ii) Xm+x(ii)]; end
e=v-Xm;
clear v Xm;
% Determing min surpluses.
[se, sC]=sort(e,'ascend');
smat=-inf(n);
q0=n^2-n;
q=0;
k=1;
pl=1:n;
while q~=q0
  kS=sC(k);
  ai=bitget(kS,pl)==1;
  bj=ai==0;
  pli=pl(ai);
  plj=pl(bj);
  if isempty(plj)==0
    for i=1:numel(pli)
      for j=1:numel(plj)
        if smat(pli(i),plj(j))==-Inf
           smat(pli(i),plj(j))=se(k); % min surplus of i against j.
           q=q+1;
        end
      end
    end
  end
  k=k+1;
end
smat=tril(smat,-1)+triu(smat,1);
