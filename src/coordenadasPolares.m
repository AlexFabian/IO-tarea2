function firmaCodificada = coordenadasPolares(firma)

    centroideX = mean(firma(:,1));
    centroideY = mean(firma(:,2));
    [largo,~] = size(firma);
    firmaCodificada = zeros(largo,2);
    firmaCodificada(1,1) = firma(1,1); %el primer punto no se codifica
    firmaCodificada(1,2) = firma(1,2);
    
    for i = 2: largo
        r2 = firma(i,1) - centroideX; %actual
        r1 = firma(i-1,1) - centroideX; %anterior
        h2 = firma(i,2) - centroideY;
        h1 = firma(i-1,2) - centroideY;
        
        tempA = r2/r1;
        tempB = h2/h1;
        
        %[Theta, r]
        [firmaCodificada(i,1), firmaCodificada(i,2)] = cart2pol(tempA, tempB);
 
    end
 
end
