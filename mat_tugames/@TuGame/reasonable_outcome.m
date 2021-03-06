function r=reasonable_outcome(clv)
%REASONABLE_OUTCOME computes the largest amount vector. 
%This is the largest amount players can contribute to a coalition.
% 
%  Usage: r=reasonable_outcome(clv);
%
%
% Define variables:
%  output:
%  r        -- Largest amount vector
%
%  input:
%  clv        -- TuGame class object.
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   10/29/2012        0.3             hme
%                
    
v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
S=1:N;
r=zeros(1,n);

for i=1:n
 a=bitget(S,i)==1;
 Sa=S(a);
 b=Sa-Sa(1);
 bg=b>0;
 s=b(bg);
 vni=[0, v(s)];
 r(i)=max(v(Sa)-vni);
end
