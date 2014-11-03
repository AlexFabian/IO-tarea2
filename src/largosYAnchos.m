function firmaCodificada = largosYAnchos(firma)
    centroideX = mean(firma(:,1));
    centroideY = mean(firma(:,2));
    [largo,~] = size(firma);
    firmaCodificada = zeros(largo,2);
    for i=2:largo
        r2 = firma(i,1) - centroideX; %ancho del punto actual
        r1 = firma(i-1,1) - centroideX; %ancho del punto anterior
        h2 = firma(i,2) - centroideY; %largo del punto actual
        h1 = firma(i-1,2) - centroideY; %largo del punto anterior
        
        firmaCodificada(i,1) = r2/r1;
        firmaCodificada(i,2) = h2/h1;
    end
end