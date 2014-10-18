%------------------------------------------------------------------------
% Funcion que calcula alfa y beta escaladas
% para evitar problemas de precision numerica.
% Llamada:
%	[alfa,beta,c]=alfabeta(A,B,Pi,O)
% Parametros de entrada:
%	A(N,N): Matriz de probabilidad de transicion del hmm.
%	B(N,M): Distribucion de probabilidad de simbolo del hmm.
%	Pi(N,1): Distribución de estado inicial del hmm.
%	O(T,1): Secuencia de observables a evaluar.
% Parametros de salida:
%	alfa(N,T): Matriz de probabilidad forward.
%	     alfa(i,t) no escalada es la probabilidad de la secuencia de observables
%		O(1),..,O(t) y el estado i en el tiempo t.
%	     alfa no escalada cumple que P(O/A,B,Pi)=sum(alfa(:,T))
%	     Para alfa escalada se tiene sum(alfa(:,t))=1 para cualquier t.
%	beta(N,T): Matriz de probabilidad backward.
%	     Beta(i,t) no escalada es la probabilidad de la secuencia de observables
%		O(t+1),..,O(T) dado el estado i y el tiempo t.
%	c(T,1): Vector donde guardo la constante de escalado para cada t.
%	     Si no quiero escalar, he de mantener c=ones(T,1).
%	     La relacion entre alfa y beta escalados y sin escalar es la siguiente:
%		h=cumprod(c);
%		alfa_escalado(:,t)=h(t)*alfa_no_escalado(:,t);
%		g=cumprod(c(T:-1:1);
%		beta_escalado(:,t)=g(t)*beta_no_escalado(:,t);
% NOTA: para alfa y beta no escalados se tiene:
%	Probabilidad de la secuencia O = alfa(:,t)'*beta(:,t)= sum(alfa(:,T)).
%	   constante para todo t.
%	En el caso de alfa y beta escalado dicho producto vale:
%		alfa(:,t)'*beta(:,t)=c(t)*sum(alfa(:,T))
%	asi no es constante con el tiempo.
%--------------------------------------------------------------------------
function [alfa,beta,c]=alfabeta(A,B,Pi,O)

% Variables de los hmm:
% N: Numero de estados del hmm.
% M: Numero de gausianas por estado del hmm.
[N,M]=size(B);
% Variables de la secuencia de vectores.
% T: Longitud de la secuencia de estados y observables.
[T]=size(O,1);
% Matriz de probabilidad forward.
alfa=zeros(N,T);
% Matriz de probabilidad backward.
beta=zeros(N,T);
% defino la variable escala para alfa y beta.
c=ones(T,1);
% Indice de bucle.
t=0;

% Calculo matriz forward escalada.
alfa(:,1)=Pi.*B(:,O(1));
c(1)=1/sum(alfa(:,1));		% factor de escala. Poner c(1)=1 para no escalar.
alfa(:,1)=alfa(:,1).*c(1);	% Escalado.
for t=2:T,
	alfa(:,t)=(alfa(:,t-1)'*A)'.*B(:,O(t));
	c(t)=1/sum(alfa(:,t));	% factor de escala. Poner c(t)=1 para no escalar.
	alfa(:,t)=alfa(:,t).*c(t);
end;

% Calculo de la matriz backward Escalada.
% hacer c=ones(T,1) para no escalar.
beta(:,T)=ones(N,1)*c(T);
for t=T-1:-1:1,
	beta(:,t)=A*(B(:,O(t+1)).*beta(:,t+1))*c(t);
end;

return