function [SCRGP SCRGPC]=k_StrConverse_RGP_Q(clv,x,K,str,tol)
% k_StrConverse_RGP_Q checks a stronger version of k-CRGP, 
% that is, the k-converse reduced game property (k-converse consistency)
% for ever 2<=|S|<=K.
%
% Usage: [SCRGP SCRGPC]=clv.k_StrConverse_RGP_Q(x,K,str,tol)
%
% Define variables:
%  output:
%  kCrgpQ   -- Returns 1 (true) whenever the k-CRGP is satisfied, 
%              otherwise 0 (false).
%  kcrgpQ   -- Gives a precise list of reduced games for which the 
%              restriction of x on S is a solution of the reduced game vS. 
%              It returns a list of zeros and ones.
%  vS       -- All Davis-Maschler or Hart-MasColell reduced games on S at x 
%              with k or less players but having at least 2 players.
%  sV_x     -- Returns a vector of extended solutions x_s to x_N for 
%              all reduced games vS.              
%
%  input:
%  clv      -- TuGame class object.
%  x        -- payoff vector of size(1,n). Must be efficient.
%  K        -- An integer value equal to or greater than 2, 
%              but not larger than n.
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
%   05/29/2013        0.3             hme
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
  K=2;
elseif nargin<3
  tol=10^6*eps;
  str='PRK';
  K=2;
elseif nargin<4
  tol=10^6*eps;
  str='PRK';
elseif nargin<5
  tol=10^6*eps;
else
  tol=10^6*eps;
end

S=1:N;
PlyMat=false(N,n);
for k=1:n, PlyMat(:,k) = bitget(S,k)==1;end

% Checking now whether the imputation solves the reduced game for 
% every K-player or smaller coalitions with at least two players, 
% that is 2<=|S|<=K.
%
sumPM=PlyMat*ones(n,1);
kcrgpQ=cell(K-1,1);
CrgpQ=zeros(1,K-1);

for int=2:K;
  slcl2=sumPM==int;
  cl2=S(slcl2);
  PlyMat2=PlyMat(cl2,:);
  siPM2=size(PlyMat2,1);

  vS=cell(K,siPM2);
  stdsol=cell(K,siPM2);
  crgpq=cell(K,siPM2);
  crgpQ=zeros(K,siPM2);
  sV_x=cell(K,siPM2);
  rS=cell(K,siPM2);

 for k=1:siPM2
 sV_x{int,k}=x;
   if strcmp(str,'SHAP')
     vS{int,k}=clv.HMS_RedGame(x,cl2(k)); %Hart-MasColell reduced game.
     stdsol{int,k}=ShapleyValue(vS{int,k}); % solution x restricted to S.
     rS{int,k}=PlyMat2(k,:);
     sV_x{int,k}(rS{int,k})=stdsol{int,k}; % extension to (x,x_N\S).
     crgpq{int,k}=abs(sV_x{int,k}-x)<tol;
     crgpQ(int,k)=all(crgpq{int,k});
   elseif strcmp(str,'PRK')
     vS{int,k}=clv.RedGame(x,cl2(k)); % Davis-Maschler reduced game.
     stdsol{int,k}=PreKernel(vS{int,k}); % solution x restricted to S.
     rS{int,k}=PlyMat2(k,:);
     sV_x{int,k}(rS{int,k})=stdsol{int,k}; % extension to (x,x_N\S).
     crgpQ(int,k)=clv.PrekernelQ(sV_x{int,k});
   elseif strcmp(str,'PRN')
     vS{int,k}=clv.RedGame(x,cl2(k)); % Davis-Maschler reduced game.
     try
       stdsol{int,k}=Prenucl(vS{int,k}); % solution x restricted to S.
     catch
       stdsol{int,k}=PreNucl(vS{int,k});  % use a third party solver instead!
     end
     rS{int,k}=PlyMat2(k,:);
     sV_x{int,k}(rS{int,k})=stdsol{int,k}; % extension to (x,x_N\S).
     crgpq{int,k}=abs(sV_x{int,k}-x)<tol;
     crgpQ(int,k)=all(crgpq{int,k});
   else
     vS{int,k}=clv.RedGame(x,cl2(k)); % Davis-Maschler reduced game.
     stdsol{int,k}=PreKernel(vS{int,k}); % solution x restricted to S.
     rS{int,k}=PlyMat2(k,:);
     sV_x{int,k}(rS{k})=stdsol{int,k}; % extension to (x,x_N\S).
     crgpQ(int,k)=clv.PrekernelQ(sV_x{int,k});
   end
 end
kcrgpQ{int-1,1}=crgpQ(int,:);
CrgpQ(1,int-1)=all(kcrgpQ{int-1,1});
end
kCrgpQ=all(CrgpQ);
%Formatting Output
if nargout>1
 SCRGP=struct('kCrgpQ',kCrgpQ,'kcrgpQ',kcrgpQ);
 SCRGPC={'vS',vS,'sV_x',sV_x};
else
  SCRGP=struct('kCrgpQ',kCrgpQ,'kcrgpQ',kcrgpQ);
end



