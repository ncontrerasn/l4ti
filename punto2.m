%palabra que se va a decodificar               
entrada = input("Palabra para decodificar: "); % "11 00 00 01 11"

%transiciones
%estado actual, símbolo leído, estado al que pasa, salida (línea punteada es 1)
transiciones = {"00", 0, "00", "00";
                "00", 1, "10", "11";  
                "10", 0, "01", "01";  
                "10", 1, "11", "10";  
                "01", 0, "00", "11";  
                "01", 1, "10", "00";  
                "11", 0, "01", "10";  
                "11", 1, "11", "01"};

%estados disponibles (al inicio solo está el estado inicial)
estadosDisponibles = {"00"}; 

%matriz que guarda los pesos de los pasos de tiempo con todas las transiciones 
%[peso t1 - t2 - transición 1, peso t1 - t2 - transición 2, ..., peso t1 - t2 - transición 8;
%...
%peso t5 - t6 - transición 1, ..., peso t5 - t6 - transición 8]
pesosDeIteraciones = [3, 3, 3, 3, 3, 3, 3, 3;
                      3, 3, 3, 3, 3, 3, 3, 3;
                      3, 3, 3, 3, 3, 3, 3, 3;
                      3, 3, 3, 3, 3, 3, 3, 3;
                      3, 3, 3, 3, 3, 3, 3, 3];
                    
                    
%palabra separada en grupos de a 2
codigo = strsplit(entrada, " ");
                    
%ciclo para iterar entre las transiciones (de t1 a t2, ..., hasta t5 a t6) y obtener los pesos de cada transición
for i = 1 : 5
  
  %iterar sobre los estados disponibles
  for k = 1 : columns(estadosDisponibles)
    
    %iterar sobre las 8 transiciones
    for j = 1 : 8
      
      %si el estado actual de la transción es uno de la lista de estados disponibles (actualmente se está en él)
      if transiciones{j, 1} == estadosDisponibles{k}
        
        %calcular el peso de la matriz de pesos entre la primera posición de la palabra ingresada y la salida del código
        pesosDeIteraciones(i, j) = distanciaDeHamming(codigo{i}, transiciones{j, 4});
        
        %bandera para saber si se agregan estados a la lista de estados disponibles
        check = 0;
        
        %recorrer la lista de estados disponibles para añadir los estados destino a los disponibles
        for l = 1 : columns(estadosDisponibles)
          
         %si el estado de la lista de estados disponibles es igual que el estado al que pasa con la transión
         if strcmp(estadosDisponibles{l}, transiciones{j, 3})
           
           %activar la bandera para no agregar ese estado a los disponibles
          check = 1;
         end
        endfor
        
        %si la bandera no se activó (ningún estado disponible es al que se podría llegar mediante esta transición), agregar ese estado de llegada a los estados disponibles
        if check == 0
          estadosDisponibles{columns(estadosDisponibles) + 1} = transiciones{j, 3};
        end
      end
    endfor
  endfor
endfor

%se inicializan las rutas y los camnios en 0
rutas = {"0", "0", "0", "0"};
caminos = {"0", "0", "0", "0"};

%peso acumulado de las rutas sobrevivientes
pesoActual = [0, 0, 0, 0]; 

%pesos para comparar en cada iteracion del algoritmo de Viterbi
%tiene la misma estructura que una fila de la matriz de pesos de las iteraciones (las 2 primeras posiciones son del estado a, las 2 siguientes del b, ...)
pesos = [0, 0, 0, 0, 0, 0, 0, 0];

%iterar sobre la matriz de pesos de las iteraciones y el vector de pesos actuales para calcular el vector de pesos
for i = 1 : 5
 for j = 1 : 8
  pesos(j) = pesoActual(ceil(j / 2)) + pesosDeIteraciones(i, j);
 endfor
 
 %compara los pesos de las dos rutas para elegir la mejor
 for j = 1 : 4
  %si el peso de la primera opción es mejor, tomar este camino
  if pesos(j) < pesos(j + 4)
    
   %peso del mejor camino
   pesoActual(j) = pesos(j);
   
   %estados de los caminos
   rutas{j, i} = ceil(j / 2);
   
   %transiciones para lograr los caminos
   caminos{j, i} = j;
  else
   pesoActual(j) = pesos(j + 4);
   rutas{j, i} = ceil((j + 4) / 2);
   caminos{j, i} = j + 4;
  end
 endfor
endfor

%inicializar arreglo para la ruta actual
rutaActual = [0, 0, 0, 0, 0, 0];

%inicializar arreglo para el código de salida
codigo = {"00", "00", "00", "00", "00"};

%nicializar arreglo para d
d = [0, 0, 0, 0, 0];

%comenzar a llenar el vector de la ruta actual con el camino que tiene menor peso
rutaActual(6) = min(pesoActual);

%llenar el vector de d y el del código de salida con ayuda de los vectores ruta actual, rutas y caminos
for i = 1 : 5
  rutaActual(6 - i) = rutas{rutaActual(7 - i), 6 - i};
  codigo{6 - i} = transiciones{caminos{rutaActual(7 - i), 6 - i}, 4};
  d(6 - i) = transiciones{caminos{rutaActual(7 - i), 6 - i}, 2};
endfor

%mostrar r, c y d
r = strsplit(entrada, " ");

salidaR = "";
salidaC = "";
salidaD = "";

for i = 1 : 5
  salidaR = strcat(salidaR, char(r{1, i}), {" "});
  salidaC = strcat(salidaC, char(codigo{1, i}), {" "});
endfor

printf("r: %s \n", salidaR{1, 1});
printf("c: %s \n", salidaC{1, 1});
printf("d: ");

for i = 1 : 5
  printf("%d  ", d(i));
endfor

printf("\n");