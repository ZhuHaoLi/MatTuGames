classdef p_TuPrk < p_TuSol
% P_TUPRK creates the subclass object p_TuPrk to perform several computations for retrieving 
% and modifying game data. It stores relevant game information and
% pre-kernel elements obtained by overloading functions from various solvers.
%
% Usage: clv = p_TuPrk(v,'gtype','gformat')
%
% Define variables:
% output:
% clv           -- p_TuPrk class object (subclass of TuGame).
%
% input:
% v             -- A Tu-Game v of length 2^n-1.
% gtype         -- A string to define the game type.
%                    Permissible types are:
%                    -- 'cv' (convex/average-convex, semi-convex).
%                    -- 'cr' game with non-empty core.
%                    -- 'sv' simple game.
%                    -- 'acr' game with non-empty anti-core.
%                    -- ''   empty string (default)
% gformat       -- A string to define the game format.
%                    Permissible formats are:
%                    -- 'mattug' i.e., unique integer representation to perform computation
%                                under MatTuGames. (default)
%                    -- 'mama'   i.e. generic power set representation, i.e Mathematica.
%
% p_TuPrk properties:
%
%  tu_pk_cplex       -- stores a pre-kernel element obtained with the CPLEX interface.
%  tu_pk_cvx         -- stores a pre-kernel element obtained with the CVX interface.
%  tu_pk_gurobi      -- stores a pre-kernel element obtained with the GUROBI interface.
%  tu_pk_hsl         -- stores a pre-kernel element obtained with the HSL interface.
%  tu_pk_ipopt       -- stores a pre-kernel element obtained with the IPOPT interface.
%  tu_pk_lin         -- stores a pre-kernel element obtained with MATLAB's linsolve.
%  tu_pk_msk         -- stores a pre-kernel element obtained with the MOSEK interface.
%  tu_pk_oases       -- stores a pre-kernel element obtained with the OASES interface.
%  tu_pk_ols         -- stores a pre-kernel element obtained with MATLAB's lscov.
%  tu_pk_qpc         -- stores a pre-kernel element obtained with the QPC interface.
%  tu_tol            -- stores the tolerance value. Default is set to 10^6*eps.
%  cplex_pk_valid    -- returns 1 if tu_pk_cplex stores a pre-kernel element, otherwise 0.
%  cvx_pk_valid      -- returns 1 if tu_pk_cvx stores a pre-kernel element, otherwise 0.
%  gurobi_pk_valid   -- returns 1 if tu_pk_gurobi stores a pre-kernel element, otherwise 0.
%  hsl_pk_valid      -- returns 1 if tu_pk_hsl stores a pre-kernel element, otherwise 0.
%  ipopt_pk_valid    -- returns 1 if tu_pk_ipopt stores a pre-kernel element, otherwise 0.
%  lin_pk_valid      -- returns 1 if tu_pk_lin stores a pre-kernel element, otherwise 0.
%  msk_pk_valid      -- returns 1 if tu_pk_msk stores a pre-kernel element, otherwise 0.
%  oases_pk_valid    -- returns 1 if tu_pk_oases stores a pre-kernel element, otherwise 0.
%  ols_pk_valid      -- returns 1 if tu_pk_ols stores a pre-kernel element, otherwise 0.
%  qpc_pk_valid      -- returns 1 if tu_pk_qpc stores a pre-kernel element, otherwise 0.
%
%  Properties inherited from the superclass p_TuSol:
%
%  tu_prk       -- stores a pre-kernel element.
%  tu_prk2      -- stores a second pre-kernel element instead of the pre-nucleolus.
%  tu_prn       -- stores the pre-nucleolus.
%  tu_sh        -- stores the Shapley value.
%  tu_tauv      -- stores the Tau value.
%  tu_bzf       -- stores the Banzhaf value.
%  tu_aprk      -- stores the anti-pre-kernel.
%  prk_valid    -- returns 1 if tu_prk stores a pre-kernel element, otherwise 0.
%  prk2_valid   -- returns 1 if tu_prk2 stores a pre-kernel element, otherwise 0.
%  prn_valid    -- returns 1 if tu_prn stores the pre-nucleolus, otherwise 0.
%
%  Properties inherited from the superclass TuGame:
%
%  tuvalues     -- stores the characteristic values of a Tu-game.
%  tusize       -- stores the length of the game array/vector.
%  tuplayers    -- stores the number of players involved.
%  tutype       -- stores the game type information ('cv','cr', or 'sv').
%  tuessQ       -- stores if the game is essential.
%  tuformat     -- stores the format how the game is represented.
%  tumv         -- stores the value of the grand coalition.
%  tumnQ        -- stores the information whether a proper coalition has a higher value
%                  than the grand coalition
%  tuSi         -- stores the coalitions having size of n-1.
%  tuvi         -- stores the values of singleton coalitions.
%  tustpt       -- stores a starting point for doing computation. Has lower priority than
%                  providing a second input argument as an alternative starting point.
%                  Thus, if a starting point is provided as second input argument the
%                  information stored in tustpt will not be used.
%
% p_TuPrk methods:
%  p_TuPrk                       -- creates the class object p_TuPrk.
%  p_setAllVendorPrk             -- sets all computed pre-kernel elements to p_TuPrk.
%  p_setCplexPrk                 -- sets the computed pre-kernel element dervied with the interface CPLEX to p_TuPrk. 
%  p_setCvxPrk                   -- sets the computed pre-kernel element dervied with the interface CVX to p_TuPrk. 
%  p_setGurobiPrk                -- sets the computed pre-kernel element dervied with the interface GUROBI to p_TuPrk. 
%  p_setHslPrk                   -- sets the computed pre-kernel element dervied with the interface HSL to p_TuPrk. 
%  p_setIpoptPrk                 -- sets the computed pre-kernel element dervied with the interface IPOPT to p_TuPrk. 
%  p_setLinPrk                   -- sets the computed pre-kernel element dervied with MATLAB's linsolve to p_TuPrk. 
%  p_setMskPrk                   -- sets the computed pre-kernel element dervied with the interface MOSEK to p_TuPrk. 
%  p_setOasesPrk                 -- sets the computed pre-kernel element dervied with the interface OASES to p_TuPrk. 
%  p_setOlsPrk                   -- sets the computed pre-kernel element dervied with MATLAB's lscov to TuPrk. 
%  p_copyTuSol                   -- copies all solutions from TuSol/p_TuSol to p_TuPrk.
%  p_copyTuPrk                   -- copies consistency properties from TuPrk to p_TuPrk.
%
%  Methods inherited from the superclass p_TuSol:
%
%  p_setAllSolutions  -- sets all solutions listed below to the class object p_TuSol.
%  p_setPreKernel     -- sets a pre-kernel element to the class object p_TuSol.
%  p_setPreNuc        -- sets the pre-nucleolus to the class object p_TuSol.
%  p_setShapley       -- sets the Shapley value to the class object p_TuSol.
%  p_setTauValue      -- sets the Tau value to the class object p_TuSol.
%  p_setBanzhaf       -- sets the Banzhaf value to the class object p_TuSol.
%  p_setAntiPreKernel -- sets an anti-pre-kernel element to the class object p_TuSol.
%
%  Methods inherited from the superclass TuGame:
%
%  startpt      -- sets a starting point for doing computation.
%
%


%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   10/12/2013        0.5             hme
%   10/31/2016        0.9             hme
%





    properties(SetObservable = true)
       tu_pk_cplex
       tu_pk_cvx  
       tu_pk_gurobi
       tu_pk_hsl  
       tu_pk_ipopt
       tu_pk_lin  
       tu_pk_msk  
       tu_pk_oases
       tu_pk_ols  
       tu_pk_qpc
       tu_tol=10^8*eps; 
    end
  
    properties(GetAccess = 'public', SetAccess = 'private')
       cplex_pk_valid = false; 
       cvx_pk_valid = false;     
       gurobi_pk_valid = false;  
       hsl_pk_valid = false;     
       ipopt_pk_valid = false;   
       lin_pk_valid = false;     
       msk_pk_valid = false;     
       oases_pk_valid = false;   
       ols_pk_valid = false;     
       qpc_pk_valid = false;            
     end
      
      
       methods
         function obj = p_TuPrk(w,gtype,gformat)
       % P_TUPRK creates the subclass object p_TuPrk to perform several computations for retrieving 
       % and modifying game data. It stores relevant game information and
       % pre-kernel elements needed by overloading functions from various solvers.
       %
       % Usage: clv = p_TuPrk(v,'gtype','gformat')
       %
       % Define variables:
       % output:
       % clv           -- p_TuPrk class object (subclass of TuGame).
       %
       % input:
       % v             -- A Tu-Game v of length 2^n-1.
       % gtype         -- A string to define the game type.
       %                    Permissible types are:
       %                    -- 'cv' (convex/average-convex, semi-convex).
       %                    -- 'cr' game with non-empty core.
       %                    -- 'sv' simple game.
       %                    -- 'acr' game with non-empty anti-core.
       %                    -- ''   empty string (default)
       % gformat       -- A string to define the game format.
       %                    Permissible formats are:
       %                    -- 'mattug' i.e., unique integer representation to perform computation
       %                                 under MatTuGames. (default)
       %                    -- 'mama'   i.e. generic power set representation, i.e Mathematica.
       %
           if nargin > 3
              error('Too many input arguments');
           elseif nargin < 1
              error('Game information must be given as a 2^n-1 vector!');
           elseif nargin < 2 
              gtype = '';
              gformat = 'mattug';
           elseif nargin < 3
              gformat = 'mattug';
           else
           end
           obj = obj@p_TuSol(w,gtype,gformat); 
         end

         function obj = p_setCplexPrk(obj,sol) 
         % P_SETCPLEXPKR sets a pre-kernel element using CPLEX to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setCplexPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_cplex)
                   obj.tu_pk_cplex = [];   % Calls setter set.tu_pk_cplex.
               end
             else
               obj.tu_pk_cplex = sol;      % Calls setter set.tu_pk_cplex.
             end
         end


         function obj = set.tu_pk_cplex(obj,pt)
            if isempty(pt)
               try 
                 sol = p_cplex_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_cplex = sol;
                 obj.cplex_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_cplex = inf(1,n);
                 obj.cplex_pk_valid = false;                 
               end    
            else
               obj.tu_pk_cplex = pt;
               tol = obj.tu_tol;
               obj.cplex_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end
         

         function obj = p_setCvxPrk(obj,sol) 
         % P_SETCVXPKR sets a pre-kernel element using CVX to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setCvxPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_cvx)
                   obj.tu_pk_cvx = [];   % Calls setter set.tu_pk_cvx.
               end
             else
               obj.tu_pk_cvx = sol;      % Calls setter set.tu_pk_cvx.
             end
         end


         function obj = set.tu_pk_cvx(obj,pt)
            if isempty(pt)
               try 
                 sol = p_cvx_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_cvx = sol;
                 obj.cvx_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_cvx = inf(1,n);
                 obj.cvx_pk_valid = false;                 
               end    
            else
               obj.tu_pk_cvx = pt;
               tol = obj.tu_tol;
               obj.cvx_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end         
         

         function obj = p_setGurobiPrk(obj,sol) 
         % P_SETGUROBIPKR sets a pre-kernel element using GUROBI to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setGurobiPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_gurobi)
                   obj.tu_pk_gurobi = [];   % Calls setter set.tu_pk_gurobi.
               end
             else
               obj.tu_pk_gurobi = sol;      % Calls setter set.tu_pk_gurobi.
             end
         end


         function obj = set.tu_pk_gurobi(obj,pt)
            if isempty(pt)
               try 
                 sol = p_gurobi_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_gurobi = sol;
                 obj.gurobi_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_gurobi = inf(1,n);
                 obj.gurobi_pk_valid = false;                 
               end    
            else
               obj.tu_pk_gurobi = pt;
               tol = obj.tu_tol;
               obj.gurobi_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end                  
         
         
         function obj = p_setHslPrk(obj,sol) 
         % P_SETHSLPKR sets a pre-kernel element using HSL to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setHslPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_hsl)
                   obj.tu_pk_hsl = [];   % Calls setter set.tu_pk_hsl.
               end
             else
               obj.tu_pk_hsl = sol;      % Calls setter set.tu_pk_hsl.
             end
         end


         function obj = set.tu_pk_hsl(obj,pt)
            if isempty(pt)
               try 
                 sol = p_hsl_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_hsl = sol;
                 obj.hsl_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_hsl = inf(1,n);
                 obj.hsl_pk_valid = false;                 
               end    
            else
               obj.tu_pk_hsl = pt;
               tol = obj.tu_tol;
               obj.hsl_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end                  
         
         function obj = p_setIpoptPrk(obj,sol) 
         % P_SETIPOPTPKR sets a pre-kernel element using IPOPT to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setIpoptPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_ipopt)
                   obj.tu_pk_ipopt = [];   % Calls setter set.tu_pk_ipopt.
               end
             else
               obj.tu_pk_ipopt = sol;      % Calls setter set.tu_pk_ipopt.
             end
         end


         function obj = set.tu_pk_ipopt(obj,pt)
            if isempty(pt)
               try 
                 sol = p_ipopt_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = PrekernelQ(obj,sol,tol);
                 obj.tu_pk_ipopt = sol;
                 obj.ipopt_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_ipopt = inf(1,n);
                 obj.ipopt_pk_valid = false;                 
               end    
            else
               obj.tu_pk_ipopt = pt;
               tol = obj.tu_tol;
               obj.ipopt_pk_valid = PrekernelQ(obj,pt,tol);
            end
         end                  

         
         function obj = p_setLinPrk(obj,sol) 
         % P_SETLINPKR sets a pre-kernel element using Matlab's linsolve to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setLinPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_lin)
                   obj.tu_pk_lin = [];   % Calls setter set.tu_pk_lin.
               end
             else
               obj.tu_pk_lin = sol;      % Calls setter set.tu_pk_lin.
             end
         end


         function obj = set.tu_pk_lin(obj,pt)
            if isempty(pt)
               try 
                 sol = p_lin_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_lin = sol;
                 obj.lin_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_lin = inf(1,n);
                 obj.lin_pk_valid = false;                 
               end    
            else
               obj.tu_pk_lin = pt;
               tol = obj.tu_tol;
               obj.lin_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end                  
         

         function obj = p_setMskPrk(obj,sol) 
         % P_SETMSKPKR sets a pre-kernel element using MOSEK to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setMskPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_msk)
                   obj.tu_pk_msk = [];   % Calls setter set.tu_pk_msk.
               end
             else
               obj.tu_pk_msk = sol;      % Calls setter set.tu_pk_msk.
             end
         end


         function obj = set.tu_pk_msk(obj,pt)
            if isempty(pt)
               try 
                 sol = p_msk_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = PrekernelQ(obj,sol,tol);
                 obj.tu_pk_msk = sol;
                 obj.msk_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_msk = inf(1,n);
                 obj.msk_pk_valid = false;                 
               end    
            else
               obj.tu_pk_msk = pt;
               tol = obj.tu_tol;
               obj.msk_pk_valid = PrekernelQ(obj,pt,tol);
            end
         end                           
         

         function obj = p_setOasesPrk(obj,sol) 
         % P_SETOASESPKR sets a pre-kernel element using OASES to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setOasesPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_oases)
                   obj.tu_pk_oases = [];   % Calls setter set.tu_pk_oases.
               end
             else
               obj.tu_pk_oases = sol;      % Calls setter set.tu_pk_oases.
             end
         end


         function obj = set.tu_pk_oases(obj,pt)
            if isempty(pt)
               try 
                 sol = p_oases_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_oases = sol;
                 obj.oases_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_oases = inf(1,n);
                 obj.oases_pk_valid = false;                 
               end    
            else
               obj.tu_pk_oases = pt;
               tol = obj.tu_tol;
               obj.oases_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end                           
         
         function obj = p_setOlsPrk(obj,sol) 
         % P_SETOLSPKR sets a pre-kernel element using Matlab's lscov to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setOlsPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_ols)
                   obj.tu_pk_ols = [];   % Calls setter set.tu_pk_ols.
               end
             else
               obj.tu_pk_ols = sol;      % Calls setter set.tu_pk_ols.
             end
         end


         function obj = set.tu_pk_ols(obj,pt)
            if isempty(pt)
               try 
                 sol = p_ols_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_ols = sol;
                 obj.ols_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_ols = inf(1,n); 
                 obj.ols_pk_valid = false;                 
               end    
            else
               obj.tu_pk_ols = pt;
               tol = obj.tu_tol;
               obj.ols_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end                  
         
         function obj = p_setQpcPrk(obj,sol) 
         % P_SETQPCPKR sets a pre-kernel element using QPC to the class object p_TuPrk.
         % 
         %  Usage: clv = p_setQpcPrk(clv,sol)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %     sol      -- a pre-kernel element (optional).   
         %
             if nargin < 2
               if isempty(obj.tu_pk_qpc)
                   obj.tu_pk_qpc = [];   % Calls setter set.tu_pk_qpc.
               end
             else
               obj.tu_pk_qpc = sol;      % Calls setter set.tu_pk_qpc.
             end
         end


         function obj = set.tu_pk_qpc(obj,pt)
            if isempty(pt)
               try 
                 sol = p_qpc_prekernel(obj);
                 tol = obj.tu_tol;
                 pkQ = p_PrekernelQ(obj,sol,tol);
                 obj.tu_pk_qpc = sol;
                 obj.qpc_pk_valid = pkQ;
               catch
                 n=obj.tuplayers;
                 obj.tu_pk_qpc = inf(1,n); 
                 obj.qpc_pk_valid = false;                 
               end    
            else
               obj.tu_pk_qpc = pt;
               tol = obj.tu_tol;
               obj.qpc_pk_valid = p_PrekernelQ(obj,pt,tol);
            end
         end                  
         
         
         
         
         
         function obj = p_setAllVendorPrk(obj)
         % P_SETALLVENDORPRK sets a set of pre-kernel solutions
         % to the class object p_TuPrk using Matlab's PCT.
         %
         %  Usage: clv = p_setAllVendorPrk(clv)
         %
         %  output:
         %    clv       -- p_TuPrk class object.
         %
         %  input:
         %     clv      -- p_TuPrk class object.
         %
                %
                % CPLEX Pre-Kernel
                  try 
                    solpk = p_cplex_prekernel(obj);
                    obj.tu_pk_cplex = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.cplex_pk_valid = pkQ;                  
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_cplex = inf(1,n); 
                    obj.cplex_pk_valid = false;
                  end    
                %
                % CVX Pre-Kernel
                  try
                    solpk = p_cvx_prekernel(obj);
                    obj.tu_pk_cvx = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.cvx_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_cvx = inf(1,n);
                    obj.cvx_pk_valid = false;                      
                  end    
                %
                % GUROBI Pre-Kernel
                  try
                    solpk = p_gurobi_prekernel(obj);
                    obj.tu_pk_gurobi = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.gurobi_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_gurobi = inf(1,n);
                    obj.gurobi_pk_valid = false;                      
                  end    
                %
                % HSL Pre-Kernel
                  try
                    solpk = p_hsl_prekernel(obj);
                    obj.tu_pk_hsl = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.hsl_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_hsl = inf(1,n);
                    obj.hsl_pk_valid = false;                      
                  end    
                %
                % IPOPT Pre-Kernel
                  try
                    solpk = p_ipopt_prekernel(obj);
                    obj.tu_pk_ipopt = solpk;
                    tol = obj.tu_tol;
                    pkQ = PrekernelQ(obj,solpk,tol);
                    obj.ipopt_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_ipopt = inf(1,n);
                    obj.ipopt_pk_valid = false;                      
                  end    
                %
                % LIN Pre-Kernel
                  try
                    solpk = p_lin_prekernel(obj);
                    obj.tu_pk_lin = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.lin_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_lin = inf(1,n);
                    obj.lin_pk_valid = false;                      
                  end                    
                %
                % MOSEK Pre-Kernel
                  try
                    solpk = p_msk_prekernel(obj);
                    obj.tu_pk_msk = solpk;
                    tol = obj.tu_tol;
                    pkQ = PrekernelQ(obj,solpk,tol);
                    obj.msk_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_msk = inf(1,n);
                    obj.msk_pk_valid = false;                      
                  end                    
                %                
                % OASES Pre-Kernel
                  try
                    solpk = p_oases_prekernel(obj);
                    obj.tu_pk_oases = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.oases_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_oases = inf(1,n);
                    obj.oases_pk_valid = false;                      
                  end                    
                %
                % OLS Pre-Kernel
                  try
                    solpk = p_ols_prekernel(obj);
                    obj.tu_pk_ols = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.ols_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_ols = inf(1,n);
                    obj.ols_pk_valid = false;                      
                  end                    
                %
                % QPC Pre-Kernel
                  try
                    solpk = p_qpc_prekernel(obj);
                    obj.tu_pk_qpc = solpk;
                    tol = obj.tu_tol;
                    pkQ = p_PrekernelQ(obj,solpk,tol);
                    obj.qpc_pk_valid = pkQ;
                  catch
                    n=obj.tuplayers;
                    obj.tu_pk_qpc = inf(1,n);
                    obj.qpc_pk_valid = false;                      
                  end                    
                %
                
        end
         
         


        function obj = p_copyTuSol(obj,clv)
        % copy constructor: class object clv to class object obj.
        %
        %  Usage: obj = p_copyTuSol(obj,clv)
        %
        %  output:
        %    obj       -- p_TuPrk class object.
        %
        %  input:
        %     obj      -- p_TuPrk class object.
        %     clv      -- TuSol/p_TuSol class object.
        %
          fns = properties(clv);
             for i=1:7
              try 
                 obj.(fns{i}) = clv.(fns{i});
              catch
                 if strcmp(obj.tutype,'sv') 
                    obj.(fns{i}) = clv.(fns{i});
                 end
              end
             end
        end


        function obj = p_copyTuPrk(obj,clv)
        % copy constructor: class object clv to class object obj.
        %
        %  Usage: obj = copy_p_TuPrk(obj,clv)
        %
        %  output:
        %    obj       -- p_TuPrk class object.
        %
        %  input:
        %     obj      -- p_TuPrk class object.
        %     clv      -- TuPrk class object.
        %
          fns = properties(clv);
             for i=1:10
              try
                 obj.(fns{i}) = clv.(fns{i});
              catch
              end
             end
        end



       end

 
end
