function vl2 = main()
    load('vl.mat');
    [totalIndividuos,~] = size(vl);
    vl2 = vl;
    for i=1:totalIndividuos
        [totalMuestras,~] = size(vl{i});
        for j=1:totalMuestras
            vl2{i}{j} = largosYAnchos(vl{i}{j});
        end
    end
end