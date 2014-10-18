%----------------------------------------------------------------
% El producto de las B con la secuencia de observables O
% es muy frecuente para el diseño de los HMM discretos.
% por esa razon se genera esta subrutina
% LLamada:
%       prob=prodBO(B,O,nc)
% parametros de entrada
%    B{Np}(numero de estados,numero de simbolos)
%    O{Np}(numero de vectores,Numero de simbolos)
%    nc: componente de O{Np} a evaluar
% parametros de salida
%     prob: resultado del producto-> probabilidad de que cada estado
%           genere la componente nc de la secuencia O.
%-----------------------------------------------------------------
function prob=prodBO(B,O,nc)

Np=size(B,1);
prob=ones(size(B{1},1),1);
for ip=1:Np
   prob=prob.*(B{ip}*O{ip}(nc,:)');
end
prob=prob+realmin;
return
