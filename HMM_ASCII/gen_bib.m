% ----------------------------------------------------------------
% Programa que calcula una libreria de centroides para cada parametro
% y para cada uno de los modelo de cada clase. Los centroides se obtienen
% de los vectores de entrada al HMM
% Programa: biblio=gen_bib(vl,agrup,Ns,bout)
% Parametros de entrada:
%		pin: vectores a partir de los cuales calcular las bibliotecas de cada parametro
%			en la cell array: vl{clase,grupo}{repeticion}
%     agrup: agrupamiento de las componentes de cada vector que forman los parametros
%     Ns(noHMM,Np): Numero de simbolos por parametro que coincide con el numero de
%                   centroides por parametro.
%     LBG: Si LBG=1 se utiliza el LBG, sino el de las Kmedias.s
%     dpztoLBGSi LBG=1, porcentaje de desplazamiento de vectores codigo.
%     maxiterVQ: Numero maximo de iteraciones permitidas.
%     umbralVQ: Umbral de finalizacion.
%     biblio: matriz con el formato de la biblioteca
% Parametros de salida:
%     biblio: biblioteca calculada, en el mismo formato que se almacena
%             en fichero (ver bout)
% NOTA: utiliza la funcion Kmedias.
% -----------------------------------------------------------
function biblio=gen_bib(vl,agrup,Ns,LBG,dpztoLBG,maxiterVQ,umbralVQ,men,biblio)

% Se calcula el numero de parametros y modelos por clase
ng=size(Ns,1);
Np=zeros(ng,1);
for ig=1:ng
   Np(ig)=size(Ns{ig},1);
end

% MENSAJES GENERALES
if men,fprintf('CALCULO DE LAS VQ\n')
fprintf('Numero de grupos: %g\n',ng)
if (LBG==1),
   fprintf('Algoritmo LBG. Porcentaje del desplazamiento utilizado: %g\n',dpztoLBG);
else
   fprintf('Algoritmo Kmedias\n');
end;
fprintf('maximo de iteraciones,umbral fin de iteracion: %g %g\n',maxiterVQ,umbralVQ);end

% DISEÑO DE LAS LIBRERIAS DEL CUANTIFICADOR
tiempo=0;
% se calculan las librerias de los parametros de cada agrupación
for ig=1:ng,
   
   % se obtienen los vectores de entrenamiento de dicho grupo
   vtrain=cat(1,vl{:,ig});
   vtrain=cat(1,vtrain{:});
   Nv=size(vtrain,1);
   
   % Se imprimen los mensajes de diseño particulares
   if men,fprintf('CALCULO DE LAS VQ del GRUPO %g de %g\n',ig,ng)
   fprintf('Numero de librerias (parametros) a generar: %g\n',Np(ig))
   fprintf('Numero de centroides de cada libreria: %g\n',Ns{ig})
   fprintf('dimension de los centroides de cada libreria: %g\n',diff(agrup{ig}));
   fprintf('Numero de vectores de entrenamiento: %g\n',Nv);end
   for ip=1:Np(ig),
      if men,fprintf('CALCULO DE LA VQ del GRUPO %g PARAMETRO %g\n',ig,ip);end
      Nslib=Ns{ig}(ip);
      dinic=agrup{ig}(ip);dfinal=agrup{ig}(ip+1)-1;
      dim=dfinal-dinic+1;
      if (LBG==1),
         % se calcula la primera biblioteca.
         bib=mean(vtrain(:,dinic:dfinal));
         while (2*size(bib,1)<=Nslib),
            % se dublica la biblioteca
            bib=[bib; bib.*(1.+randn(size(bib)).*dpztoLBG)./100];
            % se mejora la biblioteca con el algoritmo de las Kmedias.
				[bib,puntero]=kmedias(vtrain(:,dinic:dfinal),bib,maxiterVQ,umbralVQ, men);
            if (men), fprintf('\tFIN libreria de %g centroides.\n',size(bib,1)); end
         end;
         if (size(bib,1)<Nslib)
            [Y, I] = sort(hist(puntero,size(bib, 1)));
            addbib = bib(I(2*size(bib,1)-Nslib+1:size(bib,1)),:).*(1.+randn(Nslib-size(bib,1),dim).*dpztoLBG./100);
            bib = [bib; addbib];
				[bib,puntero]=kmedias(vtrain(:,dinic:dfinal),bib,maxiterVQ,umbralVQ, men);
            if (men), fprintf('\tFIN libreria de %g centroides.\n',Nslib); end
         end
         biblio{ig}{ip}=bib;
         if (men), fprintf('FIN CALCULO de la libreria del grupo %g, parametro %g.\n',ig,ip); end
      else
         % Algoritmo de las Kmedias.
         % Se inicia la libreria escogiendo Lb vectores de la secuencia
         % de entrenamiento de forma aleatoria.
         tic
         inic=randperm(Nv);
         inic=inic(1:Nslib);
         % Se inicia la libreria.
         bib=vtrain(inic,dinic:dfinal);
         %bib=vtrain{inic}{dinic:dfinal};
         % Y se disenha la libreria final
         bib=kmedias(vtrain(:,dinic:dfinal),bib,maxiterVQ,umbralVQ,men);
         biblio{ig}{ip}=bib;
         if men,fprintf('FIN CALCULO de la libreria del grupo %g, parametro %g. Tiempo %g\n',ig,ip,toc);end
      end;
   end
end   
return
   