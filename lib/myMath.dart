import 'dart:math';

num pow(num x, int exponent){
  num result = 1;
  for(int i = 1; i < exponent; i++){
    result *= x;
  }
  return result;
}