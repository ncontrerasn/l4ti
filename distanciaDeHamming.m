function [H] = distanciaDeHamming(a, b)

 peso = 0;
 
  %calcular la distancia entre los bits de la primera posici�n
  if substr(a, 1, 1) != substr(b, 1, 1)
    peso = peso + 1;
  endif
  
  %calcular la distancia entre los bits de la segunda posici�n
  if substr(a, 2, 1) != substr(b, 2, 1)
    peso = peso + 1;
  endif
 
 H = peso;
 
endfunction