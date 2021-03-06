function v_x=p_ECCoverGame(clv,x)
% P_ECCoverGame computes from (v,x) an excess comparability cover of game v using Matlab's PCT.
%
% Source:  H. I. Meinhardt. The Modiclus Reconsidered. Technical report, Karlsruhe Institute of Technology (KIT), Karlsruhe, Germany,
%          2018. URL http://dx.doi.org/10.13140/RG.2.2.32651.75043.
%
%          Meinhardt (2018), "Analysis of Cooperative Games with Matlab and Mathematica".
%
%          Sudhoelter (1997), The modified nucleolus: Properties and axiomatizations. International Journal of Game Theory, 26
%          (2):147–182, Jun 1997. ISSN 1432-1270. doi: 10.1007/BF01295846. URL https://doi.org/10.1007/BF01295846.
%
% Usage: vt=p_ECCoverGame(v,x)
%
% Define variables:
%  output:
%  v_x     -- The excess comparability cover game w.r.t. x.
%  input:
%  clv      -- TuGame class object.
%  x        -- payoff vector of size(1,n).
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   03/01/2018        1.0             hme
%                

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;

exc_v=clv.excess(x);
dv=clv.dual_game();
exc_dv=excess(dv,x);
sx_v=sort(exc_v,'descend');
sx_dv=sort(exc_dv,'descend');
mx_v=sx_v(1);
mx_dv=sx_dv(1);
v_x=zeros(1,N);

parfor k=1:N-1
    v_x(k)=max(v(k)+mx_v+2*mx_dv,dv(k)+mx_dv+2*mx_v);
end
v_x(N)=v(N);
