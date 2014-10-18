%---------------------------------------------------
% Función que calcula los modelos iniciales óptimos 
% para el entrenamiento de Baum-Welch
%---------------------------------------------------
function [Aa,Ba,Pia]=iniciahmm(Ne,Ns,Np,BAKIS,salto,labels,maxitermi)

% se calculan variables
nr=size(labels{1},1);
Ltd=size(cat(1,labels{:}),1);

% Se inician los modelos de Markov.
itermi=1;
% se inician las matrices del modelo de Markov
[A,B,Pi]=genhmm(Ne,Ns,Np,BAKIS,salto);
Aa=A;Ba=B;Pia=Pi;
if gt(maxitermi,1)
   % para asegurar que la inicializacion es buena, tomo como criterio
   % el que todos los estados tengan al menos el doble de simbolos
   % generados que Ns.
   % Calculo el numero de simbolos que genera cada estado del hmm.
   for ir=1:nr,
      OqP{ir}=viterbi(A,B,Pi,labels{ir});
   end;
   % Y se calcula la mayor distancia a la equi-ocupacion
   dmim=max(abs(Ltd/Ne-hist(cat(1,OqP{:}),Ne)));
   % Si todos los estados no tienen el numero minimo
   % de simbolos generados, reinicio el modelo.
   % AVISO: aqui puede quedarse colgado en un bucle infinto
   while and(dmim>0.3*Ltd/Ne,itermi<maxitermi),
      itermi=itermi+1;
      [A,B,Pi]=genhmm(Ne,Ns,Np,BAKIS,salto);
      for ir=1:nr,
         OqP{ir}=viterbi(Aa,Ba,Pia,labels{ir});
      end;
      dmi=max(abs(Ltd/Ne-hist(cat(1,OqP{:}),Ne)));
      if dmi<dmim,
         dmim=dmi;
         Aa=A;Ba=B;Pia=Pi;
      end;
   end;
end
return