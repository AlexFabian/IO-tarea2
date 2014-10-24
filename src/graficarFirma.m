function graficarFirma(vl, ind,muestra)
    plot(vl{ind}{muestra}(:,1), vl{ind}{muestra}(:,2));
    set(gca,'xaxislocation','top','yaxislocation','left','ydir','reverse')
end