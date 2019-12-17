String[] masses;

//*************************
//*  Solve Day 1 Puzzles
//****************
PVector solveDay01() {
  masses = loadStrings("001a_module_mass.txt");
  PVector answer = new PVector();
  
  // Calculate answer for first puzzle 
  for (int i = 0 ; i < masses.length; i++) {
    answer.x += fuelRequired(int(masses[i]));
  }
  
  // Calculate answer for first puzzle recursively 
  for (int i = 0 ; i < masses.length; i++) {
    answer.y += fuelRequiredRec(int(masses[i]));
  }
  
  return answer;
}


//*************************
//*  Fuel calculator
//****************
int fuelRequired(int moduleMass) {
  return max(0, floor((moduleMass/3)) - 2);
}


//*************************
//*  Recursive fuel calculator
//****************
int fuelRequiredRec(int moduleMass) {
  int fuelMass = floor((moduleMass/3)) - 2;
  
  if(fuelMass > 0) {
    fuelMass += fuelRequiredRec(fuelMass);
  }
  
  return max(0, fuelMass);
}
