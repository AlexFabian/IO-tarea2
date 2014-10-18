%------------------------------------------------------------------------
% Funcion que me reestima un modelo hmm (A,B,Pi) a partir
% de una secuencia de entrenamiento de observables labels
% Llamada:
%	[A1,B1,Pi1,logPOs]=baum(A,B,Pi,labels)
% Parametros de entrada:
%	A(N,N): Matriz de probabilidad de transicion del hmm.
%	B{Np}(N,M(ip)): Distribucion de probabilidad de simbolo del hmm.
%	Pi(N,1): Distribucion de estado inicial del hmm.
%  labels{nr}{Np}(numero de vectores,Numero de simbolos),
%           secuencia de etiquetas observables de entrenamiento
% Parametros de salida:
%	A1(N,N): Matriz de probabilidad de transicion del hmm actualizada.
%	B1(N,M(ip)): Distribucion de probabilidad de simbolo del hmm actualizada.
%	Pi1(N,1): Distribucion de estado inicial del hmm actualizada.
%	logPOs(nr,1): Probabilidad de que el HMMM de entrada (A,B,Pi) genere
%        cada realizacion de labels de entrada a la subrutina
% NOTA: utiliza la funcion alfabeta.
%--------------------------------------------------------------------------

function [A1,B1,Pi1,logPOs,numB1]=baum(A,B,Pi,labels)

% Variables de los hmm.
% Np: Numero de parametros por simbolo.
% N: Numero de estados del hmm.
% M(ip): Numero de simbolos por parametro
Np=size(B,1);
M=zeros(Np,1);
for ip=1:Np
   [N,M(ip)]=size(B{ip});
end
% nr: Numero de secuencias de observables de entrenamiento,
% o numero de repeticiones
nr=size(labels,1);

% Matrices del modelo hmm reestimado.
A1=zeros(N,N);Pi1=zeros(N,1);
B1=cell(Np,1);
for ip=1:Np
   B1{ip}=zeros(N,M(ip));
end
% Matrices auxiliar para el calculo de A1.
numA1=zeros(N,N);denA1=zeros(N,1);Eps=zeros(N,N);
% Matrices auxiliar para el calculo de B1.
numB1=cell(Np,1);denB1=cell(Np,1);Psi=cell(Np,1);
for ip=1:Np,
   numB1{ip}=zeros(N,M(ip));denB1{ip}=zeros(N,1);Psi{ip}=zeros(N,M(ip));
end
% Variable auxiliar para la probabilidad.
POl=0.0;
% Vector de probabilidad
logPOs=zeros(nr,1);
% Indices de bucle.
i=0;k=0;t=0;l=0;

% Calculo la aportacion de cada secuencia de observables
% de la secuencia de entrenamiento.
for ir=1:nr,
	% Las matrices cuya dimension depende de T, hay que redefinirlas
	% dentro del bucle, pues la T depende de l.
   % valor de T.
   T=size(labels{ir}{1},1);
	% Matriz de probabilidad forward.
	alfa=zeros(N,T);
	% Matriz de probabilidad backward.
	beta=zeros(N,T);
	% Variable gama.
	% Gama(i,t) es la probabilidad de estar en el estado i en el tiempo t
	% dada una secuencia de observables O.
	% sum(gama(:,t))=1 para cualquier t..
	gama=zeros(N,T);
	% Matrices auxiliar para el calculo de B1.
	punt=zeros(T,1);unos=ones(T,1);
	% Variable escala para alfa y beta.
	c=ones(T,1);

	% calculo alfa y beta escalada.
   % el resto del algoritmo es valido para alfa y beta
   % escaladas o no.
   
   % Se calcula la probabilidad de la escuencia en cada estado
   prob=zeros(N,T);
   for t=1:T
      prob(:,t)=prodBO(B,labels{ir},t);
   end
   
   % Calculo matriz forward escalada.
   alfa(:,1)=Pi.*(prob(:,1));
   c(1)=1/sum(alfa(:,1));		% factor de escala. Poner c(1)=1 para no escalar.
   alfa(:,1)=alfa(:,1).*c(1);	% Escalado.
   for t=2:T,
      alfa(:,t)=(alfa(:,t-1)'*A)'.*(prob(:,t));
      c(t)=1/sum(alfa(:,t));	% factor de escala. Poner c(t)=1 para no escalar.
      alfa(:,t)=alfa(:,t).*c(t)+realmin;
   end;
   
   % Calculo de la matriz backward Escalada.
   % hacer c=ones(T,1) para no escalar.
   beta(:,T)=ones(N,1)*c(T);
   for t=T-1:-1:1,
      beta(:,t)=A*(prob(:,t+1).*beta(:,t+1))*c(t)+realmin;
   end;
   
   POl=sum(alfa(:,T));
	logPOs(ir)=log(POl)-sum(log(c));
	
	% Calculo de la matriz gama.
	% calculo valido para alfa y beta escaladas o no escaladas, pues
	% en el caso escalado el numerador y el denominador
	% estan ponderados por el mismo factor cada t: h(T)*c(t), siendo h=cumprod(c);
	for t=1:T,
		gama(:,t)=(alfa(:,t).*beta(:,t))./(alfa(:,t)'*beta(:,t))+realmin;
	end;

	% Calculo la contribucion al numerados y denominador de la
	% matriz de transicion de estados correspondiente a la
	% secuencia l de observables de entrenamiento.
	Eps=zeros(N,N);
	for t=1:T-1,
		for i=1:N,
			Eps(i,:)=Eps(i,:)+alfa(i,t)*(A(i,:).*(prob(:,t+1))'.*beta(:,t+1)');
		end;
	end;
	numA1=numA1+Eps/POl;
	denA1=denA1+sum(gama(:,1:T-1)')'/POl;

	% Calculo la contribucion al numerador y denominador de la
	% matriz distribucion de probabilidad de simbolo correspondiente
	% a la secuencia l de observables de entrenamiento.
	% Se inicializa Psi con valores muy pequenhos para evitar que, cuando
	% hay un simbolo que nunca se da, la probabilidad de cero, lo cual
	% lleva a resultados falsos.
   %   Psi=eps.*ones(N,M);
   for ip=1:Np,
      Psi=zeros(N,M(ip));
      for i=1:N
         for k=1:M(ip),
            % Reestima de B con la probabilidad heuristica.
            Psi(i,k)=Psi(i,k)+gama(i,:)*labels{ir}{ip}(:,k);
            % Reestima de B con la contribucion normalizada.
%            for t=0:T-1,
%               Psi(i,k)=Psi(i,k)+gama(i,t+1)*labels{ir}{ip}(t+1,k)*B{ip}(i,k)/sum(B{ip}(i,:).*labels{ir}{ip}(t+1,:));
%            end;
         end;
      end;
      numB1{ip}=numB1{ip}+Psi/POl;
      denB1{ip}=denB1{ip}+sum(gama')'/POl;
   end;
   	
   % Calculo la contribucion a la distribucion de estados
	% inicial correspondiente a la secuencia l de observables
	% de entrenamiento.
	Pi1=Pi1+gama(:,1);
end;

% Reestimo la matriz de transicion de estados, la
% distribucion de probabilidad de simbolo, y la distribucion
% de estados iniciales.
A1=numA1./(denA1*ones(1,N));
for ip=1:Np,
   B1{ip}=numB1{ip}./(denB1{ip}*ones(1,M(ip)))+1e-6;
end
Pi1=Pi1/nr;
return
