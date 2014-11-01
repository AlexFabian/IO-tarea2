function vl2 = main()
    load('vl.mat');
    [totalIndividuos,~] = size(vl);
    vl2 = recortar();
    for i=1:totalIndividuos
        [totalMuestras,~] = size(vl{i});
        for j=1:totalMuestras
            %vl2{i}{j} = largosYAnchos(vl{i}{j});
            vl2{i}{j} = coordenadasPolares(vl{i}{j});
            %vl2{i}{j} = angulos(vl{i}{j});
        end
    end
end