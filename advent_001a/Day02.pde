OPCPU cpu;

//*************************
//*  Solve Day 2 Puzzles
//****************
PVector solveDay02() {
 
  cpu = new OPCPU();
  PVector answer = new PVector(0, 0);
  
  // Puzzle #1
  cpu.loadCode("001b_intcode.txt");
  cpu.write(1, 12);
  cpu.write(2, 2);
  cpu.run();
  
  answer.x = cpu.read(0);
  
  // Puzzle #2
  answer.y = puzzle2Runner();
  
  return answer;
}

int puzzle2Runner() {
  int targetValue = 19690720;
  
  for(int i = 0; i <= 99; i++) {
    for(int j = 0; j <= 99; j++) {
      cpu.loadCode("001b_intcode.txt");
      cpu.write(1, i);
      cpu.write(2, j);
      cpu.run();
      
      if(cpu.read(0) == targetValue) {
        return 100 * i + j;
      }
    }
  }
  
  return 0;
}





class OPCPU {
  JSONArray opcode = new JSONArray();
  int pointer = 0;
  
  public void loadCode(String filename) {
    this.reset();
    this.opcode = loadJSONArray(filename);
  }
  
  public void reset() {
    this.opcode = new JSONArray();
    this.pointer = 0;
  }
  
  public int read(int position) {
    return this.opcode.getInt(position);
  }
  
  public void write(int position, int value) {
    this.opcode.setInt(position, value);
  }
  
  public void step(int steps) {
    
    for(int i = 0; i < steps; i++) {
      int currentCode = opcode.getInt(this.pointer);
      
      switch(currentCode) {
        case 1:
          this.opAdd();
        break;
        
        case 2:
          this.opMultiply();
        break;
        
        case 99:
        return;
      }
    }
  }
  
  public void run() {
    int currentCode = 0;
    
    while(currentCode != 99) {
      currentCode = opcode.getInt(this.pointer);
      
      switch(currentCode) {
        case 1:
          this.opAdd();
        break;
        
        case 2:
          this.opMultiply();
        break;
      }
    }
  }
  
  void opAdd() {

     // Which opcode positions hold the numbers we need to use in the operation
     int numSrc1 = opcode.getInt(this.pointer + 1);
     int numSrc2 = opcode.getInt(this.pointer + 2);
     int writeDest = opcode.getInt(this.pointer + 3);
     
     // Get the values in those positions
     int num1 = opcode.getInt(numSrc1);
     int num2 = opcode.getInt(numSrc2);
     
     // Write the answer into the opcodes at the correct position
     opcode.setInt(writeDest, num1 + num2);
     
     // Advance the pointer
     this.pointer = this.pointer + 4;
  }
  
  void opMultiply() {

    // Which opcode positions hold the numbers we need to use in the operation
     int numSrc1 = opcode.getInt(this.pointer + 1);
     int numSrc2 = opcode.getInt(this.pointer + 2);
     int writeDest = opcode.getInt(this.pointer + 3);
     
     // Get the values in those positions
     int num1 = opcode.getInt(numSrc1);
     int num2 = opcode.getInt(numSrc2);
     
     // Write the answer into the opcodes at the correct position
     opcode.setInt(writeDest, num1 * num2);
     
     // Advance the pointer
     this.pointer = this.pointer + 4;
  }
}
