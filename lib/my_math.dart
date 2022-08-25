num pow(num x, int exponent) {
  num result = 1;
  for (int i = 1; i < exponent; i++) {
    result *= x;
  }
  return result;
}

num abs(num x) {
  if (x < 0)
    return x * (-1);
  else
    return x;
}
