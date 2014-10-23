function puntos2 = encajar(firma)
    firm = matfile(firma);
    puntos = firm.Puntos;
    puntos(1,:) = puntos(1,:) - min(puntos(1,:)) + 1;
    puntos(2,:) = puntos(2,:) - min(puntos(2,:)) + 1;
    puntos2 = puntos'; %El HMM usa la transpuesta de los puntos
end