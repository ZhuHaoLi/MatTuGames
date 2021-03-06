function [core_vert,crst,cr_vol,P]=CddAntiCoreSimplexVertices(clv,tol)
% CDDANTICORESIMPLEXVERTICES computes all anti-core vertices of game v, 
% whenever the anti-core exits. Projection method is simplex. 
% The cdd-library by Komei Fukuda is needed.
% It is recommended to install the cdd-library that accompanies
% the Multi-Parametric Toolbox 3.
% http://people.ee.ethz.ch/~mpt/3/
%
% Usage: [core_vert,crst,cr_vol,P]=CddCoreSimplexVertices(clv)
% Define variables:
%  output:
%  core_vert  -- Matrix of anti-core vertices. Output is numeric.
%  crst       -- The anti-core constraints.
%  cr_vol     -- Anti-core volume, if the core is full dimensional,
%                otherwise zero. 
%  P          -- Returns V- and H-representation (class Polyhedron)
%  input:
%  clv        -- TuGame class object.
%  tol        -- A positive tolerance value. Its default value is set to 10^9*eps.
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   07/18/2015        0.7             hme
%                

% Here we assume that the user has represented the game correctly.
if nargin<2
  tol=10^9*eps;
end

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
gt=clv.tutype;

if strcmp(gt,'cv')
elseif strcmp(gt,'cr')
else
  if clv.CddAntiCoreQ(tol)==0
    error('Anti-Core is empty!');
  else
  end
end


S=1:N;
for k=1:n, PlyMat(:,k) = bitget(S,k);end
%
% Defining core constraints.
%

A1=PlyMat(end,:);
A2=PlyMat(1:N-1,:);
B1=v(N);
B2=v(:,1:N-1)';
% Defining the H polyhedron
H=struct('A',[A1;A2],'B',[B1;B2],'lin',(1:size(B1,1))');

% Calling cddmex
V=cddmex('extreme',H);
core_vert=V.V;
if nargout == 2
   crst=[H.A,H.B];
elseif nargout > 2
  crst=[H.A,H.B];
  cr_v=core_vert;
  cr_v=ToSimplex3d(cr_v); 
  P=Polyhedron(cr_v); % V-representation on R^n-1.
  cr_vol=volume(P);
end
