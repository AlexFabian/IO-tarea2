clear;
%Rotulos de inicio de simulacion y cracion de una bitacora (resultados)
rotulo= ['INICIO DE LA SIMULACION: '];
fprintf(rotulo);
fprintf('\n');
rotulo= date;
fprintf(['EL DIA: ' rotulo ' ']);
rotulo= clock;
fprintf(['A LAS: ' num2str(rotulo(4)) ' Horas con ' num2str(rotulo(5)) ' Minutos']);
fprintf('\n');

if eq(exist('resultados.txt'),2)
   diary off;delete('resultados.txt')
end

diary resultados.txt

for nveces=1:1,

   load vl
   % separo en dos bases de datos: entrenamiento y test-----------
   %determino el numero de clases y parametros a considerar
   [nc ng]=size(vl);
   %numero de muestras por clase:
   [nr nulo] = size(vl{1,1});
   % Porcentaje de entrenamiento
   ptrain=25;
   %numero de muestras de entrenamiento
   nrt=ceil(nr*ptrain/100);
   %numero de muestras de test
   nrtest=nr-nrt;
   
   %creacion de celdas para vtrain y vtest
   vtrain=cell(nc,ng);
   vtest =cell(nc,ng);
   
   %generacion aleatoria de indices de muestreo
   ind=randperm(nr);
   indtr=ind(1:nrt);   %indices de entrenamiento
   indts=ind(nrt+1:nr);%indices de test
   
   for ic=1:nc
      for ir=1:nrt
         for ig=1:ng
            vtrain{ic,ig}{ir,1}=vl{ic,ig}{indtr(ir),1};
         end
      end
      for ir=1:nrtest
         for ig=1:ng
            vtest{ic,ig}{ir,1}=vl{ic,ig}{indts(ir),1};
         end
      end
   end
   vl=vtrain;
   save vtrain vl
   vl=vtest;
   save vtest vl
   clear vtest vtrain vl;
   
   rotulo= ['-------------------------------------------------------------------------'];
   fprintf(rotulo);
   fprintf('\n');
   rotulo= ['ITERACION N: ' num2str(nveces)];
   fprintf(rotulo);
   fprintf('\n');
   rotulo= ['PORCENTAJE DE ENTRENAMIENTO: ' num2str(ptrain) '%'];
   fprintf(rotulo);
   fprintf('\n')
   
   
   fhmm= 'hmm.mat';
   dhmm_def(fhmm);
   salida= ['salida.mat'];
   Dhmm(fhmm,'vtrain.mat','vtest.mat', salida);
   resulhmm(salida);
   
   
   
end;

rotulo= ['FINALIZACION DE LA SIMULACION: '];
fprintf(rotulo);
fprintf('\n');
rotulo= date;
fprintf(['EL DIA: ' num2str(rotulo) ' ']);
rotulo= clock;
fprintf(['A LAS: ' num2str(rotulo(4)) ' Horas con ' num2str(rotulo(5)) ' Minutos']);
fprintf('\n');

diary off
