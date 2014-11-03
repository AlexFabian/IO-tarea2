%------------------------------------------------------------
% programa DHMM_DEF donde se definen todos los parametros
% que intervienen en la definicion del HMM.
% Estos parametros se dividen en los siguientes conjuntos:
%     variables con el nombre de los ficheros listados en vnf
%     variables con los parametros de la base de datos listados en vBD
%     variables con los paremetros del HMM lisatdos en vHMM
%     variables con los parametros del VQ listados en vVQ
%     variables de la realizacion del TEST listados en vTEST
% Guarda todos esos parametros en un fichero que leer? dhmm
%-------------------------------------------------------------
function dhmm_def(fhmm)

% Nombre del fichero de configuracion
%fhmm='hmm';


% VARIABLES DE LA BASE DE DATOS
vDB=[' nc ng agrup Np'];
% numero de clases nc y numero de grupos ng.
% debe cumplirse que [nc,ng]=size(vl);
nc=21;
ng=1;
%ng=2;
%ng=3;
%ng=10;

% Definicion y numero de los parametros de entrada.
% cada realizacion es un grupo de vectores, y cada vector tiene
% una serie de componentes que se agrupan en parametros
% Se define el agrupamiento de las componentes cada vector.
% y el numero de parametros de cada agrupaci?n
% debe cumplirse que agrup{ig}=[1 .... size(vl{1,ig}{1},2)+1];
agrup=cell(ng,1);
Np=zeros(ng,1);
for ig=1:ng
%   agrup{ig}=[1 2 3];
   agrup{ig}=[1 2];
   %n?mero de par?metros: 1 (hace 2- 1)
   %ojo: definici?n del n?mero de par?metros eliminando el 3 de [1 2 3]
   Np(ig)=length(agrup{ig})-1;
end
% VARIABLES DEL HMM
vHMM=[' BAKIS salto maxiter umbral maxitermi TOPN Ne Ns A B Pi'];
% Numero de etiquetas a tener en cuenta para multilabeling en entrenamiento
TOPN=cell(ng,1);
for ig=1:ng   
   TOPN{ig}= 1.*ones(Np(ig),1); %una etiqueta
end
% Constantes del HMM
% Numero de estados de cada modelo.
%Ne= 60.*ones(nc,ng);
%Ne=150.*ones(nc,ng);
Ne= 30.*ones(nc,ng);
%Ne=50.*ones(nc,ng);
% Numero de simbolos por parametro en cada estado.
Ns=cell(ng,1);
for ig=1:ng
   Ns{ig}= 32.*ones(Np(ig),1);
   %Ns{ig}=40.*ones(Np(ig),1);
   %Ns{ig}=64.*ones(Np(ig),1);
   %Ns{ig}=128.*ones(Np(ig),1);
   %Ns{ig}=16.*ones(Np(ig),1);
   %Ns{ig}=8.*ones(Np(ig),1);
   %Ns{ig}= 2.*ones(Np(ig),1);
end
% Si BAKIS=1, se genera un modelo hmm de bakis (izqda-dcha).
BAKIS=1;
% salto de estados maximo permitido en el modelo de BAKIS.
salto=1;
% Numero maximo de iteraciones permitidas.
%maxiter= 240;
%maxiter= 60;
maxiter=30;
%maxiter= 5;
% Umbral de finalizacion.
umbral=0.001;
% Numero de iteraciones para la busqueda del modelo inicial
%maxitermi=1;
maxitermi=10;
% Matrices del HMM
A=cell(nc,ng);
B=cell(nc,ng);
Pi=cell(nc,ng);

% VARIABLES DE DISE?O DEL VQ
vVQ=[' LBG dpztoLBG maxiterVQ umbralVQ men biblio'];
% Parametros de dise?o del  VQ
% Si LBG=1 se utiliza el LBG, sino el de las Kmedias.s
LBG=0;
% Si LBG=1, porcentaje de desplazamiento de vectores codigo.
dpztoLBG=0.1;
% Numero maximo de iteraciones permitidas.
%maxiterVQ= 40;
%maxiterVQ= 60;
%maxiterVQ=30;
maxiterVQ= 5;
% Umbral de finalizacion.
umbralVQ=0.001;
% mensajes del VQ, si men=0 no hay mensajes
men=1;
% se define la variable de la biblioteca
biblio=cell(ng,1);
for ig=1:ng   
   biblio{ig}= cell(Np(ig),1);
end

% VARIABLES DEL TEST
vTEST=[' TOPNtest salhmm'];
% Numero de etiquetas a tener en cuenta para multilabeling en test
TOPNtest=cell(ng,1);
for ig=1:ng   
   TOPNtest{ig}=1.*ones(Np(ig),1);
end
% Vectores salida con las probabilidades de cada secuecni de test/modelo
salhmm=cell(nc,1);

% se graba el fichero del HMM
guardar=['save ',fhmm,vDB,vHMM,vVQ,vTEST,' vDB vHMM vVQ vTEST guardar'];
eval([guardar]);
