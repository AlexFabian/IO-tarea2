%-------------------------------------------------------------------
% Funcion que genera un HMM de N estados y M simbolos por estado.
% Llamada:
%	[A,B,Pi]=genhmm(N,M,Np,BAKIS,salto)
% Parametros de entrada:
%	N: Numero de estados.
%	M: Numero de simbolos por estado.
%  Np: Numero de parametros por simbolo
%	BAKIS: Si BAKIS=1, se genera un  un modelo hmm de bakis (izqda-dcha).
%	salto: solo se utiliza cuando BAKIS=1. Es la longitud del salto de estados mas
%	   largo permitido. Debe cumplir 0<salto<N.
% Parametros de salida:
%	A(N,N): Matriz de probabilidad de transicion.
%		A(i,j)>=0, probabilidad de pasar del estado i al j.
%		sum(A(i,:))=1 para cualquier i.
%		Si BAKIS=1, se debe cumplir tambien que: A(i,j)=0, j<i
%		y para asegurar que no da saltos de estados mas largos
%		de lo permitido: A(i,j)=0, j>i+salto.
%	B(N,M): Distribucion de probabilidad de simbolo.
%		Probabilidad en el estado i de producir la salida k.
%		B(i,K)>=0, y sum(B(i,:))=1 para cualquier i.
%      Se generan tantas matriz B como Np parametros.
%      El formato de salida es la cell array B{Np)=B(N,M)
%	Pi(N,1): Distribucion de estado inicial.
%		Pi(i), probabilidad de comenzar en el estado i.
%		sum(Pi)=1.
%		Si BAKIS=1, debe cumplirse: Pi(i)=0 i<>1, y Pi(1)=1.
%--------------------------------------------------------------------

function [A,B,Pi]=genhmm(N,M,Np,BAKIS,salto);
randn('seed',0);

% Indice de bucle.
i=0;

% Matriz de probabilidad de transicion.
A=rand(N,N);
if BAKIS,
	A=triu(A)-triu(A,salto+1);%+eps.*ones(size(A));
end
A= A./(sum(A')'*ones(1,N));

% Matriz de probabilidad de simbolo.
B=cell(Np,1);
for ip=1:Np,
   B{ip}=rand(N,M(ip));
   B{ip}= B{ip}./(sum(B{ip}')'*ones(1,M(ip)))+1e-6;
end
% Distribucion de estado inicial.
if BAKIS,
   Pi=zeros(N,1);
   Pi(1)=1;
else
   Pi=rand(N,1);
	Pi=Pi./sum(Pi);
end
return