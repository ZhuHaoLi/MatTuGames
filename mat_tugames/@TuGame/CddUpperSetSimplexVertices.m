function [imp_vert,crst,ip_vol,P]=CddUpperSetSimplexVertices(clv)
% CDDUPPERSETVERTICES computes all vertices of the upper set of game v, 
% whenever the upper set is non-empty. Projection method is simplex.
% The cdd-library by Komei Fukuda is needed.
% http://www.cs.mcgill.ca/~fukuda/download/cdd
%
% It is recommended to install the cdd-library that accompanies
% the Multi-Parametric Toolbox 3.
% http://people.ee.ethz.ch/~mpt/3/
%
% Usage: [imp_vert crst]=clv.CddUpperSetSimplexVertices()
% Define variables:
%  output:
%  reas_vert  -- Matrix of vertices of the upper set. Output is numeric or a string.
%  crst       -- The constraints of the upper set.
%  ip_vol     -- Volume of the upper set. 
%  P          -- Returns V- and H-representation (class Polyhedron)
%
%  input:
%  clv      -- TuGame class object.
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   06/15/2015        0.7             hme
%                


v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;

J=1:n;
S=bitset(0,J);
sS=S;
vi=v(S);
s_vi=vi*ones(n,1);
if s_vi>v(N)
  error('Game is inessential!');
end
S(end+1)=N;
it=0:-1:1-n;
PlyMat=rem(floor(S(:)*pow2(it)),2);
%
% Defining imputation set.
%
A1=PlyMat(end,:);
A2=PlyMat(1:n,:);
B1=v(N);
B2=clv.proper_amount()';
% Defining the H polyhedron
H=struct('A',[A1;A2],'B',[B1;B2],'lin',(1:size(B1,1))');

% Calling cddmex
V=cddmex('extreme',H);
imp_vert=V.V;
if nargout == 2
   crst=[H.A,H.B];
elseif nargout > 2
  crst=[H.A,H.B];
  ip_v=imp_vert;
  ip_v=ToSimplex3d(ip_v);
  P=Polyhedron(ip_v); % V-representation on R^n-1.
  ip_vol=volume(P);
end

