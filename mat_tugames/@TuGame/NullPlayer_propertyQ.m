function NPPQ=NullPlayer_propertyQ(clv,x,tol)
% NULLPLAYER_PROPERTYQ verifies if x satisfies the null player property. 
%
%  Usage: NPPQ=clv.NullPlayer_propertyQ(x,tol) 
%
% Define variables:
%  output: Fields
%  NppQ     -- Returns true (1), if x satisfies the null player property, otherwise
%              false (0).
%  snp      -- Set of null players.
%  pzp      -- Players with zero payoff.
%
%  input:
%  clv      -- TuGame class object.
%  x        -- payoff vector of size(1,n). Must be efficient.
%  tol      -- Tolerance value. By default, it is set to 10^6*eps.
%              (optional) 
%              

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   10/16/2015        0.7             hme
%   11/20/2015        0.8             hme
%

N=clv.tusize;
n=clv.tuplayers;
v=clv.tuvalues;

if nargin<2
   x=clv.ShapleyValue;
   tol=10^6*eps;
elseif nargin<3
   tol=10^6*eps;
end

S=1:N;
npQ=false(1,n);

for k=1:n
    a=bitget(S,k)==1;
    Swk=S(a==0);
    Sk=S(a);
    vS=min(v(Swk));
    npQ(k)=all(abs(v(Sk)-vS)<tol);
end    

NpQ=any(npQ);
J=1:n;
snp=J(npQ);

if NpQ==1
   zpQ=abs(x(snp))<tol;
   pzp=J(zpQ);
   NppQ=any(zpQ);
else
   NppQ=false;
   pzp=[];
end    

NPPQ=struct('NppQ',NppQ,'snp',snp,'pzp',pzp);

