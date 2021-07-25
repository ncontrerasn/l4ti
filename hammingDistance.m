function [H] = hammingDistance(a,b)

 weight = 0;

 if substr(a,1,1)!=substr(b,1,1)
  weight = weight + 1;
 endif
 
 if substr(a,2,1)!=substr(b,2,1)
  weight = weight + 1;
 endif
 H = weight;
endfunction