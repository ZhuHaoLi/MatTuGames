function SDFP=SDFP_propertyQ(v,x,str,tol)
%SDFP_PROPERTYQ checks wheter the solution x satisfies a strong dual floor property.
%
%
% Source:  H. I. Meinhardt. The Modiclus Reconsidered. Technical report, Karlsruhe Institute of Technology (KIT), Karlsruhe, Germany,
%          2018. URL http://dx.doi.org/10.13140/RG.2.2.32651.75043.
%
%          Meinhardt (2018), "Analysis of Cooperative Games with Matlab and Mathematica".
%  
%
% Usage: SDFP=SDFP_propertyQ(v,x,str,tol)
%
% Define variables:
%
%  output:
%  DFP      -- Returns true (1) whenever the solution fulfills dual floor property,
%              otherwise false (0).
%  input:
%  v        -- A Tu-Game v of length 2^n-1. 
%  x        -- payoff vector of size(1,n). Must be efficient.
%  str      -- A string that defines different Methods. 
%              Permissible methods are: 
%              'APRN' that is, the dual floor of game v 
%               in accordance with the anti-pre-nucleolus.
%              'APRK' that is, the dual floor of game v 
%               in accordance with anti-pre-kernel solution.
%              'SHAP' that is, the dual floor of game v 
%               in accordance with the Shapley Value.
%              'MODIC' that is, the dual floor of game v.
%               equivalence in accordance with the modiclus.
%              'MPRK' that is, the dual floor of game v 
%               in accordance with modified pre-kernel solution.
%              'PMPRK' that is, the dual floor of game v 
%               in accordance with proper modified pre-kernel solution.
%              Default is 'MPRK'.
%  tol      -- Tolerance value. By default, it is set to 10^6*eps.
%              (optional) 
%
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   07/16/2018        1.0             hme
%

if nargin<3
 tol=10^6*eps; % Change this value if the solution is not correct.
 str='MODIC';
elseif nargin<4
 tol=10^6*eps;
end


N=length(v);
[~, n]=log2(N);
[~,ext_v]=DualFloor(v);

%[df_v,ext_v]=DualFloor(v);
y=[x,x];
%exy=excess(ext_v.p,y);
%t=-3*min(exy)
%v_x=streps_value(df_v,t);
v_x=ECFloorGame(ext_v.p,y);



if strcmp(str,'SHAP')
     solQ=ShapleyQ(v,x,tol);
     if solQ==1
        z=ShapleyValue(v_x);
        y=[x,x];
        solQ_x=all(abs(y-z)<tol);
    else
      solQ_x=false;
    end
elseif strcmp(str,'APRN')
   solQ=Anti_balancedCollectionQ(v,x,tol);
   if solQ==1
      solQ_x=Anti_balancedCollectionQ(v_x,y,tol);
   else
      solQ_x=false;
   end
elseif strcmp(str,'APRK')
   solQ=Anti_PrekernelQ(v,x,tol);
   if solQ==1
      solQ_x=Anti_PrekernelQ(v_x,y,tol);
   else
      solQ_x=false;
   end
elseif strcmp(str,'MODIC')
   solQ=modiclusQ(v,x,tol);
   if solQ==1
      solQ_x=modiclusQ(v_x,y,tol);
   else 
      solQ_x=false;
   end
elseif strcmp(str,'MPRK')
   solQ=ModPrekernelQ(v,x,tol);
   if solQ==1
      solQ_x=ModPrekernelQ(v_x,y,tol);
   else
      solQ_x=false;
   end
elseif strcmp(str,'PMPRK')
   solQ=PModPrekernelQ(v,x,tol);
   if solQ==1
      solQ_x=PModPrekernelQ(v_x,y,tol);
   else
      solQ_x=false;
   end
else
   solQ=ModPrekernelQ(v,x,tol);
   if solQ==1
      solQ_x=ModPrekernelQ(v_x,y,tol);
   else
      solQ_x=false;
   end
end 
SDFP.propQ=solQ_x;
SDFP.xQ=solQ;
SDFP.y=y;
SDFP.x=x;
