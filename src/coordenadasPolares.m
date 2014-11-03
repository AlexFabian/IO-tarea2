function firmaCodificada = coordenadasPolares(firma)
    centroideX = mean(firma(:,1));
    centroideY = mean(firma(:,2));
    [largo,~] = size(firma);
    firmaCodificada = zeros(largo,2);
    
    for i = 2: largo
        x2 = centroideX;
        y2 = centroideY;
        x1 = firma(i,1) - centroideX; %actual   
        y1 = firma(i,2) - centroideY; 
        m2 = (y2-y1)/(x2-x1);         %pendiente que va de centroide a un punto x
        
        x1 = firma(i-1,1) - centroideY; %anterior
        y1 = firma(i-1,2) - centroideY;
        m1 = (y2-y1)/(x2-x1);          %pendiente que va de centroide al punto anterior al punto x
                            
        tanB = (m2-m1)/(1+m1*m2);
        firmaCodificada(i,1) = atand(tanB); %abs(atand(tanB));
        
        
        r2 = firma(i,2) - centroideY;
        r1 = firma(i-1,2) - centroideY;
        
        firmaCodificada(i,2) = r2/r1;
    end
 
end
