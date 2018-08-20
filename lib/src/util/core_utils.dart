String toSignedString(int x) {
  if (x < 0) {
    return x.toString();
  } else {
    return '+${x}';
  }
}

bool isWholeNumber(int numerator, int denominator) {
  return numerator % denominator == 0;
}
