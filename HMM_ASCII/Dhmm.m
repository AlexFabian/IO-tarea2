% ------------------------------------------------------------------------------------------------------
% Este programa disenha modelos de markov discretos para cada clase mediante
% el procedimiento de Baum-Welch y realiza el test
% Programa: DHMM(fhmm)
% Parametros de entrada:
%	 fptrain: nombre del fichero con los parametros de entrada
%        Las series de entrada son secuencias de vectores, repeticiones de diferentes clases.
%        Cada repetición esta formada por un grupo de vectores que contiene
%          los parametros caracteristicos a partir de los cuales el HMM debe clasificar.
%         Se entrenara un HMM por cada vector del grupo.
%         El formato de entrada es el siguiente: todos las repeticiones de todas
%         las clases se deben encontrar en la cell array
%            vl{clase,grupo}{repeticion}(numero de vector,componentes del vector)
%        Un grupo sirve para tratar con HMMs distintos diferentes manifestaciones
%        de una misma clase (ej, distintas locuciones de un mismo locutor, distintos
%        rasgos de una misma persona (manos, voz, firma), etc.).
%            Y las componentes del vector se pueden considerar de forma aislada o
%        agrupada segun indique la variable "agrup" definida en dhmm_def.
%            Cada conjunto de componentes de vector agrupadas se denomina parametro.
%	 fptest: parametros de entrada para el test en el fichero fptest. Con el mismo formato que fptrain
%	    fsalhmm: nombre del fichero con los parametros de salida 
%			       en la cell array salhmm{clase}(indice vector, numero de clases).
%   fhmm: fichero donde están los parametros de diseño (y al final resultados) del HMM que son:
%		Los modelos de Markov calculados en las variables:
%				cell array A{clase,grupo}(Numero de estados, Numero de estados)
%				cell array B{clase,grupo}{parametro}(Numero de estados, Numero de simbolos)
%				cell array Pi{clase,grupo}(Numero de estados)
%     La biblioteca calculada a partir de los parametros de entrada.
%            Se calcula una biblioteca por cada parametro de cada grupo
%            El numero de centroides de cada biblioteca coincide con el 
%               el numero de simbolos posibles de dicho parametro.
%            se almacena la biblioteca en mod\bibo en la cell array
%               biblio{grupo}{parametro}(indice de centroides,componentes del centroide)
%		Ne(nc,ng): Numero de estados del HMM para cada clase y grupo.
%		Ns{ng}(Np): El numero de simbolos por cada parametros de cada grupo.
%     agrup{ng}: agrupacion de las componentes de cada vetor de grupo en parametros
%     TOPN{ng}(Np): Numero de etiquetas para multilabeling de cada parametro de cada grupo
%		BAKIS: Los modelos HMM que se quieren de izqda-dcha. 
%     salto: en caso de modelo de BAKIS, el salto de cada modelo.
%		maxiter: maximo numero de iteraciones en el entrenamiento del HMM
%		umbral: umbral de fin de iteracion en el entrenamiento del HMM
%     maxitermi: numero de iteraciones para el modelo inicial en el entrenamiento del HMM
%     LeoVQ: si leo el VQ del fichero bibo o calculo el VQ y lo escribo en bibo
%     LBG: diseño el VQ con el algoritmo LBG o Kmedias
%     dpztoLBG: desplazamiento de los centroides en el algoritmo LBG
%		maxiterVQ: maximo numero de iteraciones en el entrenamiento del VQ
%		umbralVQ: umbral de fin de iteracion en el entrenamiento del VQ
%     men: Si se escribe en pantalla los mensajes de entrenamiento
%     Constantes nc, Np, ng 
%	   fsalhmm: nombre del fichero con los parametros de salida 
%			       en la cell array salhmm{clase}(indice vector, numero de clases).
%
% NOTA: utiliza los script dhmm_def, gen_bib, y dhmm_men.
% NOTA: utiliza las funciones: etiquetado, iniciaHMM genhmm, alfabeta, probsec, viterbi y baum.
% NOTA: si fptrain='' tan solo realiza el test
% NOTA: si fptest='' tan solo se entrena
% NOTA: si fhmmout no se pasa, fhmmout=fhmmin;
%------------------------------------------------------------------------------------------------------
function dhmm(fhmm,fptrain,fptest,fhmmout)

% Nombre del fichero de parametros de entrenamiento
%fptrain='vtrain.mat';
% Nombre del fichero de parametros de test
%fptest='vtest.mat';

% se lee el fichero de configuración del hmm
eval(['load ',fhmm]);
if eq(nargin,4),fhmm=fhmmout;end
guardar=['save ',fhmm,vDB,vHMM,vVQ,vTEST,' vDB vHMM vVQ vTEST guardar'];

% se inician variables temporales y aleatorias
randn('state',sum(100*clock));
rand('state',sum(100*clock));

% compruebo si se realiza el entrenamiento.
if ne(length(fptrain),0)
   % en caso de realizar entrenamiento
   % se lee la base de datos de entrenamiento
   eval(['load ',fptrain,' vl']);
   % Constantes de la base de datos: numero de clases, numero de grupos
   % (logicamente todas las clases tienen el mismo numero de grupos)
   [nc,ng]=size(vl);
   
   % se calcula la biblioteca de cuantificación del dhmm
   biblio=gen_bib(vl,agrup,Ns,LBG,dpztoLBG,maxiterVQ,umbralVQ,men,biblio);
   eval([guardar]);
   
   % Se calculan los modelos HMM
   % calculo las etiquetas de toda la base de datos
   pl=etiquetado(vl,agrup,Ns,biblio,TOPN);
   clear vl
   % Estima de los modelos HMM para cada clase
   for ic=1:nc, 
      for ig=1:ng,
         % Mensajes de los parametros de disenho de esta clase y grupo
         if men, dhmm_men;end
         % se calcula el modelo HMM inicial
         [A{ic,ig},B{ic,ig},Pi{ic,ig}]=iniciahmm(Ne(ic,ig),Ns{ig},Np(ig),BAKIS,salto,pl{ic,ig},maxitermi);
         % se inicia la iteracion para maximizar la P(OTrain/(A,B,Pi))
         % mediante el metodode Baum-Welch (EM).
         % La iteracion finaliza cuando la distancia entre dos modelos 
         % estimados consecutivos es menor a cierto umbral.
         iter=0;
         cfe=umbral+1;logPOs=-1e10;MlogPO=[];SlogPO=[];
         while and(cfe>umbral,iter<maxiter),            
            iter=iter+1;
            logPOa=logPOs;
            % Reestimo la matriz de transisicion de estados
            % con el algoritmo de Baum-Welch.
            [A{ic,ig},B{ic,ig},Pi{ic,ig},logPOs]=baum(A{ic,ig},B{ic,ig},Pi{ic,ig},pl{ic,ig});          
            % Criterio fin de iteracion.
            cfe=(mean(logPOa)/mean(logPOs))-1;
            if men, fprintf('iter. Baum: %g,\tProb.: %g\tStd: %g\tCfe: %g\n',iter,mean(logPOs),std(logPOs),cfe);end;
         end;
         if men,fprintf('FIN modelo de markov, grupo %g, clase %g.\n',ig,ic);end;
      end;
   end;
   fprintf('FIN entrenamiento de Markov.\n')   
   % Se guarda el fichero con todas las variables
   eval([guardar]);
end

% se comprueba que se ha pedido realizar el test
if ne(length(fptest),0)
   % en caso afirmativo se realiza el test
   % Se lee la base de datos de test
   eval(['load ',fptest,' vl']);
   % se calcula el número de repeticiones de cada clase en test
   nrtest=zeros(nc,1);
   for ic=1:nc,
      nrtest(ic)=size(vl{ic,1},1);
   end
   
   % Mensajes del programa de test.
   if men,
   fprintf('Parametros de entrada del fichero: %s\n',fptest);
   fprintf('Numero de clases: %g\n',nc);
   fprintf('Numero de grupos: %g\n',ng);
   fprintf('Numero de repeticiones primera clase: %g\n',nrtest(1))
   end;
   % se etiquetan todas las muestras de entrada
   pl=etiquetado(vl,agrup,Ns,biblio,TOPNtest);
   clear vl;
   
   for ic=1:nc,
      % Vectores salida con las probabilidades de cada secuecni de test/modelo
      salhmm{ic}=cell(size(pl{ic,1},1),1);      
      % se realiza el test por realizacion
      for ir=1:size(pl{ic,1},1),
         % cada realizacion consta de un grupo de vectores
         for ig=1:ng,
            % Se evalua su probabilidad con cada uno de los modelos.
            for ihmm=1:nc;
               salhmm{ic}{ir}(ihmm,ig)=probsec(A{ihmm,ig},B{ihmm,ig},Pi{ihmm,ig},pl{ic,ig}{ir});
            end
         end
      end;
   end;
   fprintf('FIN test.\n');
   % se guarda la salida del hmm.
   eval([guardar]);
end
return
