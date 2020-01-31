function sbs_v=substitutes(clv,tol)
% SUBSTITUTES establishes which pair of players are substitutes.
%
% Usage: sbs_v=clv.substitutes
%
% Define variables:
% output:
% sbs_v       -- A matrix of maximal size(binom(n,2),2). Shows
%               in each row the pair that are substitutes.
%
%  input:
%  clv      -- TuGame class object.
%  tol      -- Tolerance value. Its default value is set to 10^6*eps.
%
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   02/05/2015        0.6             hme
%

if nargin <2
   tol=10^6*eps;
end

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
S=1:N;
sbs_v=[];

for ii=1:n-1
    for jj=ii+1:n
       Sni=bitget(S,ii)==0;
       Snj=bitget(S,jj)==0;
       Snij=S(Sni & Snj);
       ci=2^(ii-1);
       cj=2^(jj-1);
       Si=bitor(Snij,ci);
       Sj=bitor(Snij,cj);
       eqQ=all(abs(v(Si)-v(Sj))<tol);
       if eqQ==1
          sbs_v=[sbs_v;ii,jj];    
       end    
    end    
end    
