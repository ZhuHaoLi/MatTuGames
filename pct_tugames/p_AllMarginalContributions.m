function [Mgc mgc P ix]=p_AllMarginalContributions(v)
% P_ALLMARGINALCONTRIBUTIONS computes all marginal worth vectors 
% of a TU-game v. Using Matlab's PCT.
%
% Usage: [Mgc mgc P ix]=p_AllMarginalContributions(v)
% Define variables:
%  output:
%  Mgc      -- The matrix of marginal contributions.
%  input:
%  v        -- A TU-Game of length 2^n-1.
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   05/22/2011        0.1 alpha        hme
%   10/27/2012        0.3              hme
%                


N=length(v);
[~, n]=log2(N);
pl=1:n;
pm=perms(pl);
sz=size(pm);
P=zeros(sz);
mgc=zeros(sz);
Mgc=zeros(sz);
A=triu(ones(n));

spm=bitset(0,pm);

k=1:sz(1);
P(k,:)=spm(k,:)*A;

if n<11
SP=circshift(P,[0 1]);
shv=v(SP);
shv(:,1)=0;
mgc=v(P)-shv;
 else
vm=v(P);
dv=diff(vm,1,2);
mgc(:,[2:n])=dv;
end


[spmix ix]=sort(pm,2);

spmd
% codistributed(spmix);
 codistributed(ix);
 codistributed(Mgc);
end

parfor k=1:sz(1)
  Mgc(k,:)=mgc(k,ix(k,:));
end

Mgc=gather(Mgc);
ix=gather(ix);

