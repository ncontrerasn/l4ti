#(n, k)
k = 3;
n = 6;

#definir P
P = [1, 1, 1; 
     0, 1, 1; 
     1, 1, 0]';

#matriz identidad
I = eye(k);

#matriz generadora
G = [I,(P')];

#matriz de chequeo de paridad y su trrespuesta
I = eye(n - k);
H = [P, I];
Ht = H';

#calcular todas las posibles palabras
printf("Palabras del código: \n");

#número de palabras posibles
numeroPalabras = 2 ^ k;

#variable para almacenar las palabras
palabras = [];
res = [];

for i = 0 : numeroPalabras - 1
  #pasar a binario el numero i correspondiente a d_i
  b = (de2bi(i, k, "left-msb"));
  
  #multiplicar con la matriz generadora
  res = b * G;
  
  #pasar a binario los resultados
  for i = 1 : length(res)
    res(i) = mod(res(i), 2); 
  endfor
  palabras = [palabras; res];
endfor

#mostrar las palabras
disp(palabras);

#pedir opción
disp("1. Codificar");
disp("2. Decodificar");
menu = input('Opción: ');  

switch menu
  #codificar
  case 1
    #pedir la palabra
    entrada = input("Ingrese la palabra de la forma [d_1, d_2, d_3]: ");
    
    #representación decimal de la palabra. El reultado es el índice de la fila de la matriz de palabras
    decim = entrada(1) * 4 + entrada(2) * 2 + entrada(3) * 1 + 1;
    
    #mostrar la codificación
    disp('La palabra codificada es: ');
    disp(palabras(decim, :));
    
  #decodificar
  case 2
    #pedir la palabra
    entrada = input("Ingrese la palabra de la forma [d_1, d_2, d_3, c_1, c_2, c_3]: ");
    
    #calcular s
    s = entrada * Ht;
    
    #pasar a binario 
    for i = 1 : length(s)
      s(i) = mod(s(i), 2);
    endfor
    
    #imprimir el código inicial (cambiará si se encuentra y corrige algún error)
    printf("El código inicial es:");
    disp(entrada);
    
    #inicializar una variable síndrome en cero
    sindrome = 0;
    
    #se recorren los elementos de Ht
    for i = 1 : n
      #se revisa si s y Ht en alguna fila son iguales; si lo son se marca sindrome = i
      if isequal(s, Ht(i, :))
        sindrome = i;
      endif
    endfor
    #si síndrome es mayor a 0 hay un error en uno de los bits
    #se cambia el valor del bit en la posición en la que s es igual a la fila de Ht
    if sindrome > 0
      #si la entrada en la posición del valor de síndrome es 0, lo cambia a 1
      if entrada(sindrome) == 0
        entrada(sindrome) = 1;
        
      #si no, la cambia a 0
      else
        entrada(sindrome) = 0;
      end
    end
    #se imprime el código final
    printf("El código final es:");
    disp(entrada);
otherwise
    #en el caso que el usuario no ingrese un valor válido del menú
    disp('Opcion inválida');
end