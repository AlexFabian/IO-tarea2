% ----------------------------------------------------------------
% programa que analiza los resultados del TEST con el HMM
% Programa TESTHMM(fhmm)
% Parametros de entrada:
%		fhmm: fichero de configuración del hmm
% NOTA: Utiliza subrutinas probsec y alfabeta.
%---------------------------------------------------------------------------------
function [Mc,Mc0,Mc1]=testhmm(fhmm)


% Se lee la base de datos, la biblioteca y los HMM.
eval(['load ',fhmm])
% Se definen las Matrices de confusión.
Mc=cell(ng,1);
for ig=1:ng
   Mc{ig}=zeros(nc,nc);
end
Mc0=zeros(nc,nc);
Mc1=zeros(nc,nc);
% Se definen vectores con las probabilidades de salida.
logPO=zeros(nc,ng);
% Mensajes del programa de analisis de resultados.
fprintf('Numero de clases: %g\n',nc);
fprintf('Numero de grupos: %g\n',ng);

for ic=1:nc,
   % se realiza el test por realizacion
   for ir=1:size(salhmm{ic,1},1)
      % cada realizacion consta de un grupo de vectores
      logPO=salhmm{ic}{ir};
      % decisión por cada grupo de formas individual
      for ig=1:ng,
         [aux,Modrec]=max(logPO(:,ig));
         % Se rellena la matriz de confusion.
         Mc{ig}(ic,Modrec)=Mc{ig}(ic,Modrec)+1;
      end
      if gt(ng,1)
         % decisión por votaciones
         [Y,I]=sort(-logPO);
         [aux,Modrec]=max(hist(I(1,:),1:nc));
         Mc1(ic,Modrec)=Mc1(ic,Modrec)+1;
         % decisión por medias
         [aux,Modrec]=max(mean(logPO'));
         Mc0(ic,Modrec)=Mc0(ic,Modrec)+1;     
      end
      % se presenta la decisión por medias
      %fprintf('repeticion: %g\tclase real: %g\tclase estimada: %g\n',ir,ic,Modrec);
   end;
end;
% Imprimo Matriz de confusion por medias
%if 0
%caso de varios grupos:
%  Mp=[Mc1 diag(Mc0)./sum(Mc0')'.*100];
%caso de un sólo grupo:
   Mp=[Mc{1} diag(Mc{1})./sum(Mc{1}')'.*100];

   fprintf('CLASES');for ic=1:nc,fprintf('\t %2.0f',ic-1);end;fprintf('\t OK\n')
   for i=1:nc,
      fprintf('%2.0f',i-1);
      for j=1:nc,
         fprintf('\t%3.0f',Mp(i,j))
      end;
      fprintf('\t%4.2f %%\n',Mp(i,nc+1));
   end;
%end
% se presentan los reconocimientos medios
for ig=1:ng
   recmed=sum(diag(Mc{ig}))./sum(sum(Mc{ig})).*100;
   fprintf('RECONOCIMIENTO MEDIO GRUPO %g: %g\n',ig,recmed)
end
if gt(ng,1)
   recmed=sum(diag(Mc0))./sum(sum(Mc0)).*100;
   fprintf('RECONOCIMIENTO MEDIO POR MEDIAS: %g\n',recmed)
   recmed=sum(diag(Mc1))./sum(sum(Mc1)).*100;
   fprintf('RECONOCIMIENTO MEDIO POR votaciones: %g\n',recmed)
end
return
