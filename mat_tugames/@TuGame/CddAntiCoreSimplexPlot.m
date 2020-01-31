function CddAntiCoreSimplexPlot(varargin)
% CDDANTICORESIMPLEXPLOT plots the anti-core of game v. 
%
% Requires the Multi-Parametric Toolbox 3
% http://people.ee.ethz.ch/~mpt/3/
%
% Usage: CddAntiCoreSimplexPlot(varargin)
% Define variables:
%  output:
%             -- A simplex plot of the anti-core of game v.
%
%  input:     At most five input arguments are admissible. Any order of
%             the input arguments below is allowed. Nevertheless, at
%             least a game v must be specified. 
%
%
%  clv        -- TuGame class object.
%  core_sol   -- An integer to draw the anti-imputation set in connection with the anti-core.
%                Permissible values are 1 (true) or 0 (false).
%                Default is 1 (true). 
%  add_sol    -- A string to invoke additional solutions into the plot.
%                Permissible solutions are:
%                'none', this is the default value.
%                'prk', a pre-kernel element will be incorporated.
%                'prn', the pre-nucleolus will be incorporated.
%                'shap', the Shapley value will be incorporated.
%                'all', all three solutions above will be incorporated.
%  vw_pt       -- A string command to determine the view point.
%                The default view point is
%                [120, 25]
%
%                To specify a different view point type, for instance
%                vw_pt='view(20,25)'
%                or
%                vw_pt='view(130,35)'
%                
%                Then invoke
%
%                CddAntiCoreSimplexPlot(v,'all',vw_pt)
%
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

narginchk(1,5);

v='';
add_sol='';
imp_sol='';
tol='';
vw_pt='';

for i=1:nargin

  if ischar(varargin{i})
    if strcmp(varargin{i},'none')
       add_sol='none';
    elseif strcmp(varargin{i},'prk')
       add_sol='prk';
    elseif strcmp(varargin{i},'prn')
       add_sol='prn';
    elseif strcmp(varargin{i},'shap')
       add_sol='shap';
    elseif strcmp(varargin{i},'all')
       add_sol='all';
    elseif isempty(regexp(varargin{i},'view'))==0
       vw_pt=varargin{i};
    else
      error(['Input argument at position ' int2str(i) ' not recognized']);
    end
  elseif isa(varargin{i},'TuGame')
    v=varargin{i}.tuvalues;
    N=varargin{i}.tusize;
    n=varargin{i}.tuplayers;
    gt=varargin{i}.tutype;
    clv=varargin{i};
    if length(v)>15
       error('Game has dimension larger than four!')
    elseif length(v)<7
       error('The game is too small to be ploted')
    end 
  else
    if varargin{i}==1
      imp_sol=varargin{i};
    elseif varargin{i}==0
      imp_sol=varargin{i};
    elseif varargin{i}>0 & varargin{i}<1
      tol=varargin{i};
    elseif varargin{i}>1
       error(['Input argument at position ' int2str(i) ' not recognized']);
    else
       error(['Input argument at position ' int2str(i) ' not recognized']);
    end    
  end
end


if isempty(add_sol)
  add_sol='none';
end
if isempty(imp_sol)
  crQ=clv.CddAntiCoreQ();
  imp_sol=true;
  core_sol=crQ;
else
  crQ=clv.CddAntiCoreQ();
  core_sol=crQ;
end
if isempty(tol)
  tol=10^9*eps;
end
if isempty(vw_pt)
%  vw_pt='view(120,25)';
vw_pt='view(235,25)';
end

if crQ==0
    error('Anti-Core is empty!');
else
  [~,~,cr_vol,Pv]=clv.CddAntiCoreSimplexVertices();
end
[~,~,~,Pip]=clv.CddAntiImputationSimplexVertices();
v_prk=clv.PreKernel();
v_prn=clv.CddPrenucl();
v_sh=clv.ShapleyValue();
ms1=min(Pip.V);
ml1=max(Pip.V);
v_prk=ToSimplex3d(v_prk);
v_prn=ToSimplex3d(v_prn);
v_sh=ToSimplex3d(v_sh);

clf;
if n==4
% Plot Imputation Set
 if imp_sol==1
% All Solutions
  if strcmp(add_sol,'all')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot3(v_prk(1),v_prk(2),v_prk(3));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      hn=plot3(v_prn(1),v_prn(2),v_prn(3));
      hs=plot3(v_sh(1),v_sh(2),v_sh(3));
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      hc=Pv.plot('linewidth', 0.9);
      set(hc,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 .5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Pre-Kernel
  elseif strcmp(add_sol,'prk')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot3(v_prk(1),v_prk(2),v_prk(3));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Pre-Nucleolus
  elseif strcmp(add_sol,'prn')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hn=plot3(v_prn(1),v_prn(2),v_prn(3));
      grid on;
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Shapley Value
  elseif strcmp(add_sol,'shap')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hs=plot3(v_sh(1),v_sh(2),v_sh(3));
      grid on;
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% No solution
  elseif strcmp(add_sol,'none')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Default is none
  else
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
  end
%
% No Imputation Set
 else
  if strcmp(add_sol,'all')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot3(v_prk(1),v_prk(2),v_prk(3));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      hn=plot3(v_prn(1),v_prn(2),v_prn(3));
      hs=plot3(v_sh(1),v_sh(2),v_sh(3));
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Pre-Kernel
  elseif strcmp(add_sol,'prk')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot3(v_prk(1),v_prk(2),v_prk(3));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Pre-Nucleolus
  elseif strcmp(add_sol,'prn')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hn=plot3(v_prn(1),v_prn(2),v_prn(3));
      grid on;
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Shapley Value
  elseif strcmp(add_sol,'shap')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hs=plot3(v_sh(1),v_sh(2),v_sh(3));
      grid on;
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% No solution
  elseif strcmp(add_sol,'none')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
%      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
% Default is none
  else
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
%      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)],'ZLim',[sm(3) lr(3)]);
      hold on
      h=Pv.plot('linewidth', 0.9);
      set(h,'FaceLighting','phong','FaceAlpha',0.5,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      eval(vw_pt);
      hold off;
      camlight('headlight');
      lighting phong;
      material shiny;
  end
 end
%
%
% 3-Perons 
else
% Plot Imputation Set
 if imp_sol==1
% All Solutions
  if strcmp(add_sol,'all')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot(v_prk(1),v_prk(2));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      hn=plot(v_prn(1),v_prn(2));
      hs=plot(v_sh(1),v_sh(2));
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% Pre-Kernel
  elseif strcmp(add_sol,'prk')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot(v_prk(1),v_prk(2));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% Pre-Nucleolus
  elseif strcmp(add_sol,'prn')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hn=plot(v_prn(1),v_prn(2));
      grid on;
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% Shapley Value
  elseif strcmp(add_sol,'shap')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hs=plot(v_sh(1),v_sh(2));
      grid on;
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% No solution
  elseif strcmp(add_sol,'none')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      hold off;
% Default is none
  else
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      hold off;
  end
% Plot No Imputation Set
 else
% All Solutions
  if strcmp(add_sol,'all')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot(v_prk(1),v_prk(2));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      hn=plot(v_prn(1),v_prn(2));
      hs=plot(v_sh(1),v_sh(2));
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% Pre-Kernel
  elseif strcmp(add_sol,'prk')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hp=plot(v_prk(1),v_prk(2));
      grid on;
      set(hp,'Marker','s','MarkerSize',6,'MarkerFaceColor','r');
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% Pre-Nucleolus
  elseif strcmp(add_sol,'prn')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hn=plot(v_prn(1),v_prn(2));
      grid on;
      set(hn,'Marker','^','MarkerSize',8,'MarkerFaceColor','c');
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% Shapley Value
  elseif strcmp(add_sol,'shap')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
      hs=plot(v_sh(1),v_sh(2));
      grid on;
      set(hs,'Marker','o','MarkerSize',6,'MarkerFaceColor','y');
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
%      Pip.plot('alpha',0,'linewidth', 0.7);
      title(['Anti-Core of the Game']);
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold off;
% No solution
  elseif strcmp(add_sol,'none')
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
%      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      hold off;
% Default is none
  else
      ms2=min(Pv.V);
      ml2=max(Pv.V);
      mrg=min(max(ml2)/4,1/2);
      sm=floor(min(ms1,ms2))-mrg;
      lr=ceil(max(ml1,ml2))+mrg;
%      Pip.plot('alpha',0,'linewidth', 0.7);
      grid on;
      set(gca,'XLim',[sm(1) lr(1)],'YLim',[sm(2) lr(2)]);
      hold on
      h=Pv.plot('linewidth', 1.3);
      set(h,'FaceAlpha',0.3,'FaceColor',[0 0.5 1]);
      title(['Anti-Core of the Game']);
      hold off;
  end
 end 
end
