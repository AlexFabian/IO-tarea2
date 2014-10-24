
% Obtiene el archivo vl requerido por el HMM
% vl{i}{j} = muestra j del individuo i
function vl = obtenerVl(directorio)
    vl = {cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);cell(24,1);};
    vl = obtenerVlRecursivo(directorio, 0, 0, vl);
end

% directorio: directorio actual de la b?squeda
% ind: n?mero de individuo
% firm: n?mero de muestra
function vl2 = obtenerVlRecursivo(directorio, ind, firm, vl2)
    files = dir(directorio);
    for file = files'
        archivo = strcat(directorio,'/',file.name);
        if(not(strcmp(file.name,'.')) && not(strcmp(file.name,'..'))) %directorios actual y pap?
            %Si es un directorio busca recursivamente
            if(file.isdir)
                ind = ind + 1;
                vl2 = obtenerVlRecursivo(archivo, ind, firm, vl2);
            else
                [~,~,ext] = fileparts(archivo);
                %Se verifica que sea un archivo .mat
                if(strcmp(ext,'.mat'))
                    firm = firm + 1;
                    if firm ==25
                        firm = 1;
                    end
                    vl2{ind}{firm} = encajar(archivo);
                end
            end
        end
    end
end


