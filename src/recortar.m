function vl2 = recortar()
    load('vl.mat');
    [totalIndividuos,~] = size(vl);
    v = zeros(24,2); 
    vl2 = vl;
    for i=1:totalIndividuos
        for j=1:24 
            v(j,:) = size(vl{i}{j});
        end
        minimo = min(v(:,1));
        
        for j=1:24
            firma = vl{i}{j};
            [tamanoFirma,~] = size(firma);

            if(tamanoFirma~=minimo)
                cantidadPuntos = tamanoFirma-minimo;
                puntoRecorte = floor(tamanoFirma/cantidadPuntos);
                puntosRecortados = 0;
                for k=tamanoFirma:-puntoRecorte:1
                    if puntosRecortados < cantidadPuntos
                        firma(k,:) = [];
                        puntosRecortados = puntosRecortados+1;
                    end
                end
            end

            vl2{i}{j} = firma;
        end
        %fprintf('el min del individuo %i es %i\n',i,minimo);
    end
end