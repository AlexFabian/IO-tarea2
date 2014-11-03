function firmaCodificada = angulos(firma)
    centroideX = mean(firma(:,1));
    centroideY = mean(firma(:,2));
    [largo,~] = size(firma);
    firmaCodificada = zeros(largo,2);
    x2 = centroideX;
    y2 = centroideY;
    
    for i=2:largo
        x1 = firma(i,1) - centroideX; %actual   
        y1 = firma(i,2) - centroideY; 
        m2 = (y2-y1)/(x2-x1);         %pendiente que va de centroide a un punto x
        
        x1 = firma(i-1,1) - centroideY; %anterior
        y1 = firma(i-1,2) - centroideY;
        m1 = (y2-y1)/(x2-x1);          %pendiente que va de centroide al punto anterior al punto x
                            
        tanB = (m2-m1)/(1+m1*m2);
        firmaCodificada(i,1) = atand(tanB); %abs(atand(tanB));
        
        x2 = firma(i,1) - centroideX;
        y2 = firma(i,2) - centroideY;
        m3 = (y2-y1)/(x2-x1);           %pendiente que va del punto x al punto anterior al punto x
        
        tanA = (m3-m2)/(1+m3*m2);
        firmaCodificada(i,2) = atand(tanA);% abs(atand(tanA));
        x2 = centroideX;
        y2 = centroideY;
    end
end