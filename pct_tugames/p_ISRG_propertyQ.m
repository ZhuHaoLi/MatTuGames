function [ISRG ISRGC]=p_ISRG_propertyQ(v,x,str,tol)
% P_ISRG_PROPERTYQ checks whether an imputation x satisfies the
% imputation saving reduced game property (consistency).
%
% Usage: [ISRG ISRGC]=p_ISRG_propertyQ(v,x,str,tol)
% Define variables:
%  output: Fields
%  isrgQ     -- Returns 1 (true) whenever the ISISRG is satisfied, 
%              otherwise 0 (false).
%  isrgq     -- Gives a precise list of imutation saving reduced games for which the 
%              restriction of x on S is a solution of the imputation saving reduced game vS. 
%              It returns a list of zeros and ones.
%  vS       -- All Davis-Maschler or Hart-MasColell imputation saving reduced games on S at x.
%  impVec   -- Returns a vector of restrictions of x on all S.
%  input:
%  v        -- A Tu-Game v of length 2^n-1. 
%  x        -- payoff vector of size(1,n). Must be efficient.
%  str      -- A string that defines different Methods. 
%              Permissible methods are: 
%              'NUC' that is, the Davis-Maschler imputation saving reduced game 
%               in accordance with the nucleolus.
%              'KRN' that is, the Davis-Maschler imputation saving reduced game 
%               in accordance with kernel solution.
%              'SHAP' that is, Hart-MasColell imputation saving reduced game 
%               in accordance with the Shapley Value.
%              'HMS_KR' that is, Hart-MasColell imputation saving reduced game 
%               in accordance with the kernel solution.
%              'HMS_NC' that is, Hart-MasColell imputation saving reduced game 
%               in accordance with the nucleous.
%              Default is 'KRN'.
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
%   10/14/2015        0.7             hme
%   02/23/2017        0.9             hme
%                



if nargin<2
  x=Kernel(v);
  n=length(x);
  tol=10^6*eps;
  str='PRK';
elseif nargin<3
  n=length(x);
  tol=10^6*eps;
  str='PRK';
elseif nargin<4
  n=length(x);
  tol=10^6*eps;
else
  n=length(x);
end

N=length(v);
S=1:N;
isrgq=false(1,N);
it=0:-1:1-n;
PlyMat=rem(floor(S(:)*pow2(it)),2)==1;
impVec=cell(1,N);
isrgq_sol=cell(1,N);
sol=cell(1,N);
isrgQ=all(isrgq);

vS=cell(N-1,1);
if strcmp(str,'SHAP')
  vSa=p_HMS_ImputSavingReducedGame(v,x,'SHAP');
  vS=vSa{:,1};
  clear vSa;
elseif strcmp(str,'HMS_KR')
  vSa=p_HMS_ImputSavingReducedGame(v,x,'KRN');
  vS=vSa{:,1};
  clear vSa;
elseif strcmp(str,'HMS_NC')
  vSa=p_HMS_ImputSavingReducedGame(v,x,'NUC');
  vS=vSa{:,1};
  clear vSa;
else
  vSa=p_ImputSavingReducedGame(v,x);
  vS=vSa{:,1};
  clear vSa;
end

parfor k=1:N-1
 impVec{k}=x(PlyMat(k,:));
  if strcmp(str,'SHAP')
% Checks whether a solution x restricted to S is a solution of the
% reduced game vS.
   sol{k}=ShapleyValue(vS{1,k});
   isrgq_sol{k}=abs(sol{k}-impVec{k})<tol;
   isrgq(k)=all(isrgq_sol{k});
  elseif strcmp(str,'KRN')
% Checks whether a solution x restricted to S is a solution of the
% reduced game vS. To speed up computation, we use this code below for both,
% the nucleolus and and the kernel.
   isrgq(k)=kernelQ(vS{k},impVec{k});
  elseif strcmp(str,'NUC')
   if length(vS{k})==1
     isrgq(k)=kernelQ(vS{k},impVec{k});
   else
     try
       sol{k}=cplex_nucl2(vS{k},impVec{k}); % using cplex.
     catch
       sol{k}=nucl2(vS{k},impVec{k}); % use a third party solver instead!
     end
     isrgq_sol{k}=abs(sol{k}-impVec{k})<tol;
     isrgq(k)=all(isrgq_sol{k});
   end
  elseif strcmp(str,'HMS_KR')
   isrgq(k)=kernelQ(vS{k},impVec{k});
  elseif strcmp(str,'HMS_NC')
   if length(vS{k})==1
     isrgq(k)=kernelQ(vS{k},impVec{k});
   else
     try
       sol{k}=cplex_nucl2(vS{k},impVec{k}); % using cplexmex for nucleolus function.
     catch
       sol{k}=nucl2(vS{k},impVec{k}); % use a third party solver instead!
     end
     isrgq_sol{k}=abs(sol{k}-impVec{k})<tol;
     isrgq(k)=all(isrgq_sol{k});
   end
  end
end


if strcmp(str,'SHAP')
   sol{N}=p_ShapleyValue(v);
   isrgq_sol{N}=abs(sol{N}-x)<tol;
   isrgq(N)=all(isrgq_sol{N});
elseif strcmp(str,'KRN')
  isrgq(N)=p_kernelQ(v,x);
elseif strcmp(str,'NUC')
   try
     sol{N}=cplex_nucl2(v,x); % using cplexmex for nucleolus function.
  catch
     sol{N}=nucl2(v,x); % use a third party solver instead!
   end 
   isrgq_sol{N}=abs(sol{N}-x)<tol;
   isrgq(N)=all(isrgq_sol{N});
elseif strcmp(str,'HMS_KR')
  isrgq(N)=p_kernelQ(v,x);
elseif strcmp(str,'HMS_NC')
   try
     sol{N}=cplex_nucl2(v,x); % using cplexmex for nucleolus function.
   catch
     sol{N}=nucl2(v,x); % use a third party solver instead!
   end
   isrgq_sol{N}=abs(sol{N}-x)<tol;
   isrgq(N)=all(isrgq_sol{N});
end


isrgQ=all(isrgq);
%Formatting Output
if nargout>1
 ISRG=struct('isrgQ',isrgQ,'isrgq',isrgq);
 ISRGC={'vS',vS,'impVec',impVec};
else
  ISRG=struct('isrgQ',isrgQ,'isrgq',isrgq);
end
