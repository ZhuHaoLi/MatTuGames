function [CRGP CRGPC]=Converse_RGP_Q(clv,x,str,tol)
% Converse_RGP_Q checks whether an imputation x satisfies the CRGP, that is,
% the converse reduced game property (converse consistency).
%
% Usage [CRGP CRGPC]=clv.Converse_RGP_Q(x,str,tol)
%
% Define variables:
%  output: Fields
%  CrgpQ    -- Returns 1 (true) whenever the CRGP is satisfied, 
%              otherwise 0 (false).
%  crgpQ    -- Gives a precise list of reduced games for which the 
%              restriction of x on S is a solution of the reduced game vS. 
%              It returns a list of zeros and ones.
%  vS       -- All Davis-Maschler or Hart-MasColell reduced games on S 
%              with two players at x.
%  sV_x     -- Returns a vector of extended solutions x_s to x_N for 
%              all reduced games vS.              
%
%  input:
%  clv      -- TuGame class object.
%  x        -- payoff vector of size(1,n). Must be efficient.
%  str      -- A string that defines different Methods. 
%              Permissible methods are: 
%              'PRN' that is, the Davis-Maschler reduced game 
%               in accordance with the pre-nucleolus.
%              'PRK' that is, the Davis-Maschler reduced game 
%               in accordance with pre-kernel solution.
%              'SHAP' that is, the Hart-MasColell reduced game
%               in accordance with the Shapley value.
%              Default is 'PRK'.
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
%   10/29/2012        0.3             hme
%                

N=clv.tusize;
n=clv.tuplayers;

if nargin<2
   if isa(clv,'TuSol')
      x=clv.tu_prk;
   elseif isa(clv,'p_TuSol')
      x=clv.tu_prk;
   else
      x=clv.PreKernel();
   end
   if isempty(x)
     x=clv.PreKernel();
   end
  tol=10^6*eps;
  str='PRK';
elseif nargin<3
  tol=10^6*eps;
  str='PRK';
elseif nargin<4
  tol=10^6*eps;
else
  tol=10^6*eps;
end

S=1:N;
PlyMat=false(N,n);
for k=1:n, PlyMat(:,k) = bitget(S,k)==1;end

% Checking now whether the imputation solves the reduced game for 
% every two player coalitions.
sumPM=PlyMat*ones(n,1);
slcl2=sumPM==2;
PlyMat2=PlyMat(slcl2,:);
siPM2=size(PlyMat2,1);
Jmat=zeros(siPM2,2);

J=1:n;
for k=1:siPM2 
   Jmat(k,:)=J(PlyMat2(k,:));
end
Jmat=Jmat-1;
pw=2.^Jmat;
cl2=(pw*ones(2,1))';


vS=cell(1,siPM2);
stdsol=cell(1,siPM2);
crgpq=cell(1,siPM2);
crgpQ=false(1,siPM2);
sV_x=cell(1,siPM2);
rS=cell(1,siPM2);

for k=1:siPM2
sV_x{1,k}=x;
 if strcmp(str,'SHAP')
   vS{1,k}=clv.HMS_RedGame(x,cl2(k)); %Hart-MasColell reduced game.
   stdsol{1,k}=StandardSolution(vS{1,k}); % solution x restricted to S.
   rS{k}=PlyMat2(k,:);
   sV_x{1,k}(rS{k})=stdsol{1,k}; % extension to (x,x_N\S).
   crgpq{k}=abs(sV_x{1,k}-x)<tol;
   crgpQ(k)=all(crgpq{k});
 else
   vS{1,k}=clv.RedGame(x,cl2(k)); % Davis-Maschler reduced game.
   stdsol{1,k}=StandardSolution(vS{1,k}); % solution x restricted to S.
   rS{k}=PlyMat2(k,:);
   sV_x{1,k}(rS{k})=stdsol{1,k}; % extension to (x,x_N\S).
   if strcmp(str,'PRK')
     crgpQ(k)=clv.PrekernelQ(sV_x{1,k});
   elseif strcmp(str,'PRN')
    crgpq{k}=abs(sV_x{1,k}-x)<tol;
    crgpQ(k)=all(crgpq{k});
   else
    crgpQ(k)=clv.PrekernelQ(sV_x{1,k});
   end
 end
end
CrgpQ=all(crgpQ);
%Formatting Output
if nargout>1
 CRGP=struct('CrgpQ',CrgpQ,'crgpQ',crgpQ);
 CRGPC={'vS',vS,'sV_x',sV_x};
else
  CRGP=struct('CrgpQ',CrgpQ,'crgpQ',crgpQ);
end
