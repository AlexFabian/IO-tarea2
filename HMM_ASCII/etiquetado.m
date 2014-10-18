%-----------------------------------------------------------------
% Función que realiza el etiquetado de la base de datos.
% LLamada pl=etiquetado(vl,agrup,Ns,biblio,TOPN)
%------------------------------------------------------
function pl=etiquetado(vl,agrup,Ns,biblio,TOPN)
% Para el diseño del HMM discreto, el primero paso es etiquetar 
% cada parametros del vector de entrada con las librerias calculadas.
% Este programa permite multiple etiquetado.
% la matriz de etiquetas para cada realizacion temporal es
%    labels{ir}{parametro}(indice de vector,Numero de simbolos);

% se obtiene numero de clases, numero de grupos
% y realizaciones por clase 
[nc,ng]=size(vl);
nr=zeros(nc,1);
for ic=1:nc,
   nr(ic)=size(vl{ic,1},1);
end
Np=zeros(ng,1);
for ig=1:ng
   Np(ig)=length(agrup{ig})-1;
end


% se define la variable celda que contendrá las etiquetas, igual que vl
pl=cell(nc,ng);
for ic=1:nc,
   for ig=1:ng,
      pl{ic,ig}=cell(nr(ic),1);
   end
end

% se obtienen las etiquetas
for ic=1:nc
   for ig=1:ng

		labels=cell(nr(ic),1);
   
   	% se calcula el número de vectores a etiquetar
		Ltd=size(cat(1,vl{ic,ig}{:}),1);
      % Se calculan las etiquetas para cada parametro
      for ir=1:nr(ic),
         pl{ic,ig}{ir}=cell(Np(ig),1);
         for ip=1:Np(ig)
           Nslib=Ns{ig}(ip);TOPNl=TOPN{ig}(ip);
           dinic=agrup{ig}(ip);dfinal=agrup{ig}(ip+1)-1;
            labels=zeros(size(vl{ic,ig}{ir}(:,dinic:dfinal),1),Nslib);
            for iv=1:size(labels,1),
               vaux1=ones(Nslib,1)*vl{ic,ig}{ir}(iv,dinic:dfinal)-biblio{ig}{ip};
               vaux2=1./sum(([realmin*ones(Nslib,1) vaux1.*vaux1])');
               [Y,I]=sort(vaux2);
               labels(iv,I(Nslib-TOPNl+1:Nslib))=Y(Nslib-TOPNl+1:Nslib).*ones(1,TOPNl);
            end;
            % Normalizo a uno.
            labels=labels./(ones(Nslib,1)*sum(labels'))';
            pl{ic,ig}{ir}{ip}=labels;
         end
      end      
   end
end
return
