%------------------------------------------------------------------------
% Funcion que evalua el logaritmo de la probabilidad de una secuencia
% de observables en una hmm.
% El logaritmo evita problemas de precision numerica.
% Cuanto mas negativo sea logPO, menos probable es la secuencia O.
% Llamada:
%	[logPO,logalfaT]=probsec(A,B,Pi,O)
% Parametros de entrada:
%	A(N,N): Matriz de probabilidad de transicion del hmm.
%	B{Np}(N,M): Distribucion de probabilidad de simbolo del hmm.
%	Pi(N,1): Distribucion de estado inicial del hmm.
%	O{Np}(T,M): Secuencia de observables a evaluar.
% Parametros de salida:
%	logPO: log(Probabilidad de la secuencia O.
%	logalfaT: vector log(alfa(:,T)) donde alfa es la matriz de
%		probabilidad forward y T la duracion de la secuencia O
% NOTA: Utiliza las subrutina alfabeta
%--------------------------------------------------------------------------
function [logPO,logalfaT]=probsec(A,B,Pi,O)

% Variables de los hmm.
% N: Numero de estados del hmm.
% M: Numero de gausianas por estado del hmm.
[N,M]=size(B{1});
% Variables de la secuencia de vectores.
% T: Longitud de la secuencia de estados y observables.
[T,M]=size(O{1});
% Matriz de probabilidad forward.
alfa=zeros(N,T);
% variable de escala para alfa.
c=ones(T,1);
% Logarirmo natural de la probabilidad de la secuencia O.
logPO=0.;
% Indice de bucle.
t=0;

% Calculo las matrices alfa y c.
% Se calculas variable para el calculo de la alfa
prob=zeros(N,T);
for t=1:T
   prob(:,t)=prodBO(B,O,t);
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


% Probabilidad de secuencia PO.
% Por definicion, para alfa y beta no escalado:
%	PO=sum(alfa(:,T))=alfa(:,t)'*beta(:,t);
% Para alfa y beta escaladas, la formula de calculo de PO sale de:
%	h=cumprod(c);
%	sum(alfa(:,T))=1=h(T)*sum(alfa_no_escalada(:,T))=h(T)*PO
%	Asi: PO=1/h(T);
% La formula utilizada de PO que sirve para alfa y beta escalada o n es:
%	h=cumprod(c);
%	PO=sum(alfa(:,T))/h(T);
% En el caso no escalado: PO=sum(alfa(:,T)). Como h(T)=1, la formula es valida.
% caso escalado: PO=1/h(T). Como sum(alfa(:,T))=1 la formula tambien es valida.
% NOTA: logPO=log(sum(exp(logalfaT)))

logPO=-sum(log(c))+log(sum(alfa(:,T)));
logalfaT=log(alfa(:,T)')-sum(log(c));

return