function v_t=HMS_DervGame(v,x,S,str)
% DM_DERVGAME computes from (v,x,S) a modified Hart-Mas-Colell derived game vS on S at x for
% game v.
%
% Usage: vt=DM_DervGame(v,x)
% Define variables:
%  output:
%  v_t     -- A modified Davis-Maschler reduced game vS w.r.t. x and S
%  input:
%  v        -- A Tu-Game v of length 2^n-1. 
%  x        -- payoff vector of size(1,n).
%  S        -- A coalition/set identified by its unique integer representation.
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

n=length(x);
N=length(v);

exc_v=excess(v,x);
dv=dual_game(v);
exc_dv=excess(dv,x);
[sx_v,idx_v]=sort(exc_v,'descend');
[sx_dv,idx_dv]=sort(exc_dv,'descend');
mx_v=sx_v(1);
mx_dv=sx_dv(1);
v_t=cell(1,N-1);
%dv_t=cell(2,N-1);


vS=HMS_RedGame(v,x,S);
dvS=HMS_RedGame(dv,x,S);


v_t=max(vS-mx_v,dvS-mx_dv);
v_t(end)=vS(end);
