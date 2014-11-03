%Funci?n que codifica las firmas contenidas en vl, seg?n el m?todo de
%codificaci?n espeficicado por metodoCod
function codificarFirmas(metodoCod)
    load('vl.mat');
    [totalIndividuos,~] = size(vl);
    %Se recortan las firmas para que todas tengan el mismo tama?o, seg?n
    %cada individuo
    vl = recortar(vl);
    for i=1:totalIndividuos %para cada individuo i
        [totalMuestras,~] = size(vl{i});
        for j=1:totalMuestras %para cada muestra j del individuo i
            switch metodoCod
                case 'polares'
                    vl{i}{j} = coordenadasPolares(vl{i}{j});
                case 'angulos'
                    vl{i}{j} = angulos(vl{i}{j});
                case 'largos-anchos'
                    vl{i}{j} = largosYAnchos(vl{i}{j});
            end
        end
    end
    save('vl.mat', 'vl');
end