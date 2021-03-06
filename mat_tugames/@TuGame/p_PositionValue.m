function [pos_vl, vG]=p_PositionValue(clv,cs,str)
% P_POSITIONVALUE computes the position value w.r.t. 
% a union stable or a hypergraph system using Matlab's PCT.
%
% Usage: pos_vl=p_PositionValue(clv,cs,str)
%
% Define variables:
%  output:
%  pos_vl   -- The position value of a Tu game.
%  vG       -- The derived restricted game.
%
%  input:
%  clv      -- TuGame class object.
%  cs       -- A  union stable system like [1 7 14 15] 
%              for {[1],[1 2 3], [2 3 4],[1 2 3 4]} or a
%              hypergraph communication situation like
%              [3 6 7 24] for {[1 2],[2 3],[1 2 3], [4 5]}.
%  str      -- A string that defines different communication structures
%              'us' -- for a union stable structure.
%              'hs' -- for a hypergraph communication structure.
%              ''   -- the empty set otherwise, this is the default 'us'.
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   07/31/2013        0.4             hme
%   05/12/2014        0.5             hme
% 
v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
if isa(clv,'p_TuVal')
   us=clv.tu_us;
   hs=clv.tu_hs;
   if nargin < 3
      str='';
   end
elseif isa(clv,'TuVal')
   us=clv.tu_us;
   hs=clv.tu_hs;
   if nargin < 3
      str='';
   end
else
   us='';
   str='';
end


if nargin < 2
   if isempty(us)
       error('A game and coalition structure must be given!');
   else
      cs = us;
      str='us';
   end
elseif nargin==2
       usQ=p_union_stableQ(cs);
       if usQ==0
           msg='Coalition structure is not union stable, checking hypergraph.';
           msg2=['Wrong coalition structure will result in an ' ...
                'incorrect result!'];
           warning('usQ:fcs',msg);
           warning('usQ:fcs2',msg2);     
           str='hs';
           hsQ=hypergraphQ(cs,n);
           if hsQ==1
              msg3=['Coalition structure is a hypergraph!. Assuming ' ...
                    'hypergraph.'];               
              warning('usQ:fcs3',msg3);     
              hs=cs; 
           else
              msg4='System is not a hypergraph! Constructing one!';
              warning('usQ:fcs4',msg4);     
              J=1:n; 
              pl=2.^(J-1);                
              hs=setdiff(cs,pl); 
           end    
       else
           str='us';
       end
else
    if strcmp(str,'us')
       usQ=p_union_stableQ(cs);
       if usQ==0
           msg='Coalition structure is not union stable, assuming hypergraph.';
           msg2=['Wrong coalition structure will result in an ' ...
                'incorrect result!'];
           warning('usQ:fcs',msg);
           warning('usQ:fcs2',msg2);     
           str='hs';
           hs=cs;
       end
    elseif strcmp(str,'')
        str='us';
    else
        str='hs';
        hsQ=hypergraphQ(cs,n);
        if hsQ==1
           msg3=['Coalition structure is a hypergraph!. Assuming ' ...
                 'hypergraph.'];
           warning('usQ:fcs3',msg3);
           hs=cs;
        else
           msg4=['System is not a hypergraph! Constructing one!'];
           warning('usQ:fcs4',msg4);
           J=1:n;
           pl=2.^(J-1);
           hs=setdiff(cs,pl);
         end
    end
end

J=1:n;
pl=2.^(J-1);
lcs=length(cs);
bd=lcs-1;
int=0:-1:1-n;
if strcmp(str,'us')
 parfor ii=1:bd  % Constructing the set D(F).
    tdf=zeros(1,lcs);  
    for jj=1:lcs
    u=bitand(cs(ii),cs(jj));
     if u > 0
        g=bitor(cs(ii),cs(jj));
        gcs=any(g==cs);
        eQ=(g==[cs(ii),cs(jj)]);
        gQ=eQ==false(1,2);
        if gcs & gQ
          tdf(jj)=g;
        end
     end
    end
 df(ii,:)=tdf; 
 end

 % Constructing the basis set B(F).  
 df=sort(unique(df));
 bf=setdiff(cs,df);
 cf=setdiff(bf,pl);

 
 pcf=PowerSet(cf);
 lcf=length(cf);
 ll=1:lcf;
 rpl=2.^(ll-1);
 nl=numel(pcf);
 pus=cell(nl,1);
 parfor l=1:nl
    pus{l}=genUnionStable(pcf{l});
 end    
 % Constructing the restricted game vG.
 pos_vl=zeros(1,n);    
 vG=zeros(nl,1);
 parfor k=1:nl
     iS=pus{k};  
     csm=rem(floor(iS(:)*pow2(int)),2)==1;
     scl=csm*ones(n,1);
     mc=max(scl);
     SG=iS(scl==mc);
     vG(k)=sum(v(SG));
 end
else
 cf=setdiff(hs,pl);
 pcf=PowerSet(cf);
 nl=numel(pcf);
 lcf=length(cf);
 ll=1:lcf;
 rpl=2.^(ll-1);
 vG=zeros(nl,1);
 % Constructing the restricted game vG.
  parfor k=1:nl
     SG=PartitionSA(N,pcf{k},n);
     SG(SG==0)=[];
     vG(k)=sum(v(SG));
  end
end    
sh_vG=p_ShapleyValue(vG);

% Correcting order of players and applying formula
% of the position value. 
if strcmp(str,'us')
   svg=length(sh_vG);
   J=1:svg;
   spl=cell2mat(pcf(rpl));
   [sg, six]=sort(spl);
   sh_vG=sh_vG(six);
   parfor ip=1:n
      Ci=cf(bitget(cf,ip)==1);
      slc=J(ismember(sg,Ci));
      rsh=sh_vG(slc);
      cim=rem(floor(Ci(:)*pow2(int)),2)==1;
      szc=cim*ones(n,1);
      szc=1./szc;
      pos_vl(ip)=rsh*szc;
   end
else
   svg=length(sh_vG);
   J=1:svg;
   spl=cell2mat(pcf(rpl));
   [sg, six]=sort(spl);
   sh_vG=sh_vG(six);
   parfor ip=1:n
      Ci=cf(bitget(cf,ip)==1);
      slc=J(ismember(sg,Ci));
      rsh=sh_vG(slc);
      cim=rem(floor(Ci(:)*pow2(int)),2)==1;
      szc=cim*ones(n,1);
      szc=1./szc;
      pos_vl(ip)=rsh*szc;
   end
end    
