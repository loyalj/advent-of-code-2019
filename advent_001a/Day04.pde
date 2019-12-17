/*
facts about the password:

    It is a six-digit number.
    The value is within the range given in your puzzle input.
    Two adjacent digits are the same (like 22 in 122345).
    Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

Other than the range rule, the following are true:

    111111 meets these criteria (double 11, never decreases).
    223450 does not meet these criteria (decreasing pair of digits 50).
    123789 does not meet these criteria (no double).

How many different passwords within the range given in your puzzle input meet these criteria?

Range:
147981-691423
*/



PVector solveDay04() {
  //int rangeStart = 147981;
  int rangeStart = 147981;
  //int rangeEnd = rangeStart + 200;
  int rangeEnd = 691423;
  
  int validPasswordsA = 0;
  int validPasswordsB = 0;
  
  for(int i = rangeStart; i <= rangeEnd; i++) {
    boolean adjCheck = checkAdjacentDigits(i);
    boolean incCheck = checkIncreasingDigits(i);
    boolean pairCheck = checkPairendipity(i);
    
    // Puzzle A Counter
    if((adjCheck == true)  && (incCheck == true)) {
      validPasswordsA++;
    }
    
    // Puzzle B Counter
    if((adjCheck == true)  && (incCheck == true) && (pairCheck == true)) {
      validPasswordsB++;
    }
  }
  
  PVector answer = new PVector(validPasswordsA, validPasswordsB);
  return answer;
}


boolean checkIncreasingDigits(int value) {
  String digits = str(value);
  
  for(int i = 1; i < digits.length(); i++) {
    int firstDigit = int(digits.substring(i - 1, i));
    int secondDigit = int(digits.substring(i, i + 1));
    
    if(secondDigit < firstDigit) {
      return false;
    }
  }
  
  return true; 
}

boolean checkAdjacentDigits(int value) {
  String digits = str(value);
  
  for(int i = 1; i < digits.length(); i++) {
    int firstDigit = int(digits.substring(i - 1, i));
    int secondDigit = int(digits.substring(i, i + 1));
    
    if(secondDigit == firstDigit) {
      return true;
    }
  }

  return false; 
}



boolean checkPairendipity(int value) {
  String digits = str(value);
  int sameLength = 1;
  IntList sameRuns = new IntList();
  
  
  for(int i = 1; i < digits.length(); i++) {
    
    int firstDigit = int(digits.substring(i - 1, i));
    int secondDigit = int(digits.substring(i, i + 1));
    
    // If the number we are checking is the same as the last number, increment our length counter
    if(secondDigit == firstDigit) {
      sameLength++;
    }
    else {
      // When a number is different than the previous number, store how long the previous digit ran for, then reset the counter
      sameRuns.append(sameLength);
      sameLength = 1;
    }
  }
  
  // Capture the last runLength
  sameRuns.append(sameLength);

  // Check all of the run lengths to ensure the values are even.
  // If they are even we know that the numbers were paired.
  // If they are odd, we can return a false, since at least one run had an unpaired number
  for(int i = 0; i < sameRuns.size(); i++) {
    if(sameRuns.get(i) == 2) {
      return true;
    }
  }
  
  return false; 
}
