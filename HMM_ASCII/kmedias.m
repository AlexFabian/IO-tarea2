%-------------------------------------------------------
% funcion que realiza el algoritmo KMEDIAS
% Llamda: 	[biblio,puntero]=kmedias(tabla,biblio,maxiter,umbral)
% parametros de entrada:
%		tabla: vectores de entrenamiento de la biblioteca.
%		biblio: biblioteca inicial
%		maxiter: maximo numero de iteraciones.
%		umbral: umbral de fin de iteracion.
%     men: Si men=1, salen los mensajes, si men=0 no salen mensajes
%	parametros de salida:
%		biblio: biblioteca entrenada.
%		puntero: indica cada vector de tabla a que vector de
%				de la biblioteca pertenece.
%--------------------------------------------------------
function	[biblio,puntero]=kmedias(tabla,biblio,maxiter,umbral,men);

% Variables necesarias para aumentar la velocidad.
[Lb,dim]=size(biblio);
Lt=size(tabla,1);
puntero=zeros(Lt,1);
punt=0;
vaux1=zeros(size(biblio));
unos=ones(Lb,1);
vector=zeros(dim,1);
dis=0;
dif=zeros(Lt,1);

% Se comienza el bucle de disenho de la libreria
% del cuantificador vectorial.
if men,fprintf('Libreria de dimension: %g\n',Lb);end
cfe=umbral+1;

iter=1;
for i=1:Lt,
   vaux1=unos*tabla(i,:)-biblio;
   [dif(i),puntero(i)]=min(sum([zeros(1,Lb); (vaux1.*vaux1)']));
end;
if men,fprintf('\titer.: %g\tdis.: %g\tStd: %g\n',iter,mean(dif),std(dif));end

while (iter<maxiter)&(cfe>umbral),

	iter=iter+1;
	difa=dif;

   for i=1:Lb,
      v=find(puntero==i);
      n=length(v);
      if (n>0),
         biblio(i,:)=sum([zeros(1,dim);tabla(v,:)])./n;
      else
         if men,fprintf('\t\tAVISO: celda %d iniciada aleatoriamente.\n',i);end
         biblio(i,:)=tabla(fix(rand*(Lt-1)+1),:);
      end;
   end;
   
   for i=1:Lt,
      vaux1=unos*tabla(i,:)-biblio;
      [dif(i),puntero(i)]=min(sum([zeros(1,Lb); (vaux1.*vaux1)']));
   end;
  
   % Criterio fin de iteracion.
	cfe=mean(difa)/mean(dif)-1;
   if men,fprintf('\titer.: %g,\tdis.: %g\tStd: %g\tCfe: %g\n',iter,mean(dif),std(dif),cfe);end
end;