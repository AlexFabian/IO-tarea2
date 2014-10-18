%------------------------------------------------------------
% Programa DHMM_MEN auxiliar para imprimir
% en pantalla los parametros de disenho del modelo de Markov
%-------------------------------------------------------------
fprintf('\n_______________________________________________________\n\n');
fprintf('Generacion del HMM de la clase %g, grupo %g del fichero %s\n',ic,ig,fptrain)
fprintf('Numero de estados del modelo: %g\n',Ne(ic,ig));
fprintf('Numero de parametros: %g\n',Np(ig));
fprintf('Dimension de los vectores de cada parametro: %g\n',diff(agrup{ig}))
fprintf('Numero de simbolos por parametro: %g\n',Ns{ig});
fprintf('Numero de etiquetas por simbolo (Multilabeling)/parametro: %g\n',TOPN{ig});
fprintf('maximo de iteraciones,umbral fin de iteracion: %g %g\n',maxiter,umbral);
fprintf('Realizaciones de entrenamiento de entrada: %g\n',size(pl{ic,1},1));
