public class Control{
  String clr;
  int dots;
  String[] input;
  
  public Control(String _color, int _dots){
    this.clr = _color;
    this.dots = _dots;
  }
  
  public Control(String[] _input){
    this.input = _input;
    this.clr = input[0];
    this.dots = int(input[1]);
  }
}
