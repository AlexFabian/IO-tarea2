%------------------------------------------------------------------------
% Funcion que estima la secuencia de estados mas probable dada
%	una secuencia de observables y un hmm.
%	El metodo utilizada es el de VITERBI logaritmico para
%	  evitar problemas de precision numerica.	
% Llamada:
%	qP=viterbi(A,B,Pi,O)
% Parametros de entrada:
%	A(N,N): Matriz de probabilidad de transicion del hmm.
%	B{Np}(N,M): Distribuciones de probabilidad de simbolo del hmm.
%	Pi(N,1): Distribucion de estado inicial del hmm.
%	O{Np}(T,M): Secuencia de observables.
% Parametros de salida:
%	qP(T,1)=secuencia de estados mas probable.
%--------------------------------------------------------------------------
function qP=viterbi(A,B,Pi,O)

% Variables de los hmm:
N=size(A,1);
% Variables de la secuencia de vectores.
% T: Longitud de la secuencia de estados y observables.
% Dim: Dimension de O.
T=size(O{1},1);

% Secuencia de estados mas probable.
qP=zeros(T,1);
% Variable delta: delta(i,t).
% Probabilidad mas alta de alcanzar el estado i en el tiempo t
% dada una secuencia de observables O.
delta=zeros(N,T);
% Variable Psi. Psi(i,t).
% Camino de estados mas probable para alcanzar el estado i en el tiempo t
% dada una secuencia de observables O.
Psi=zeros(N,T);
% Indices de bucle.
t=0;j=0;

% calculo los logaritmos naturales del modelo hmm.
A=log(A+realmin);
Pi=log(Pi+realmin);
% Calculo de la matriz delta.
delta(:,1)=Pi+log(prodBO(B,O,1));
Psi(:,1)=zeros(N,1);
for t=2:T,
	for j=1:N,
		[delta(j,t),Psi(j,t)]=max(delta(:,t-1)+A(:,j));
	end;
	delta(:,t)=delta(:,t)+log(prodBO(B,O,t));
end;
% Calculo de la secuencia de estados mas probable.
[aux,qP(T)]=max(delta(:,T));
for t=T-1:-1:1,
	qP(t)=Psi(qP(t+1),t+1);
end;
return