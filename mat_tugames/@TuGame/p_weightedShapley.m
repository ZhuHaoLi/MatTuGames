function [w_sh sh_uS]=p_weightedShapley(clv,w_vec);
% P_WEIGHTEDSHAPLEY computes the weighted Shapley-value of a TU-game v.
%
% Usage: [w_sh sh_uS]=p_weightedShapley(clv,w_vec)
%
% Define variables:
%  output:
%  w_sh     -- The weighted Shapley-value of a TU-game v.
%  sh_us    -- The Shapley value matrix of unanimity_games.
%
%  input:
%  clv      -- TuGame class object. 
%  w_vec    -- A vector of positive weights.
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   10/28/2012        0.3             hme
%   06/25/2013        0.4             hme
%                
if min(w_vec)<=0
  error('The vector of weights cannot contain zero or negative components!')
end

N=clv.tusize;
n=clv.tuplayers;

[u_coord sutm]=p_unanimity_games(clv);
k=1:n;
sh_uS=zeros(N,n);

parfor S=1:N;
    uw=zeros(1,n);
    clS=bitget(S,k)==1;
    sum_wS=clS*w_vec';
    plS=k(clS);
    uw(plS)=w_vec(plS);
    sh_uS(S,:)=uw/sum_wS;
end
w_sh=u_coord*sh_uS;

