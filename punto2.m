%clc;
availableStates = {"00"}; 
transitions = {"00",0,"00","00";
               "00",1,"10","11";  
               "10",0,"01","01";  
               "10",1,"11","10";  
               "01",0,"00","11";  
               "01",1,"10","00";  
               "11",0,"01","10";  
               "11",1,"11","01"};
in = input("Ingrese el codigo: "); % "11,00,00,01,11"
codigo = strsplit(in, ",");

iterationWeights = [99,99,99,99,99,99,99,99;
                    99,99,99,99,99,99,99,99;
                    99,99,99,99,99,99,99,99;
                    99,99,99,99,99,99,99,99;
                    99,99,99,99,99,99,99,99];
%[pesot1-transicion1, pesot1-transicion2, ...,  pesot1-transicion8;
%...
%pesot5-transicion1, ..., pesot5-transicion8]

%ciclo para iterar entre las transiciones (de t1 a t2, hasta t5 a t6) y obtener los pesos de cada transicion
for i=1:5
  for k=1:columns(availableStates)
    for j=1:8
      %si es una transicion posible desde los estados disponibles calcula el peso de Hamming y lo asigna a la matriz de pesos
      if transitions{j,1}== availableStates{k}
        iterationWeights(i,j) = hammingDistance(codigo{i},transitions{j,4});
        check = 0;
        %añade los estados destino a los disponibles si no se encontraban ahi previamente
        for l=1:columns(availableStates)
         transitions{j,3};   
         availableStates{l};
         if strcmp(availableStates{l},transitions{j,3})
          check = check +1;
         end
        endfor
        if check == 0
         availableStates{columns(availableStates)+1}= transitions{j,3};
        end 
      end
    endfor
  endfor
  %iterationWeights  
endfor

rutas = {"0","0","0","0"};
caminos = {"0","0","0","0"};
pesoActual = [0,0,0,0]; %peso acumulado para la ruta que lleva a cada estado
pesos = [0,0,0,0,0,0,0,0]; %peso a comparar en cada iteracion de viterbi
for i=1:5
 for j=1:8
  pesos(j)=pesoActual(ceil(j/2))+iterationWeights(i,j);
 endfor
 %pesos
 %compara los pesos de las rutas que llegan a cada estado y guarda el menor en el acumulado
 for j=1:4
  if pesos(j)<pesos(j+4)
   pesoActual(j)=pesos(j);
   rutas{j,i}=ceil(j/2);   
   caminos{j,i} = j;
  else
   pesoActual(j)=pesos(j+4);
   rutas{j,i}=ceil((j+4)/2);   
   caminos{j,i} = j+4;
  end
  %if pesoActual(j)>50
   %pesoActual(j)=0;
  %end
 endfor
 pesoActual
endfor
%rutas
rutaActual = [0,0,0,0,0,0];
[minim,rutaActual(6)] = min(pesoActual);
%minim
%rutaActual
codigo = {"00","00","00","00","00"};
d = [0,0,0,0,0];
for i=1:5
  rutaActual(6-i)=rutas{rutaActual(7-i),6-i};
  codigo{6-i}=transitions{caminos{rutaActual(7-i),6-i},4};
  d(6-i)=transitions{caminos{rutaActual(7-i),6-i},2};
endfor
%mostLikelyPath = rutaActual
%codigo

r = strsplit(in, ",");

disp("r (r):"), disp(r)
disp("c (c):"), disp(codigo)
disp("Codigo decodificado (d):"), disp(d)