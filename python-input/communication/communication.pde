import processing.net.*; 
Client myClient;
Control[] controls = new Control[2];
String[] controlsInput = new String[2];

void setup() { 
  size(200, 200); 
  /* Connect to the local machine at port 5204
   *  (or whichever port you choose to run the
   *  server on).
   * This example will not run if you haven't
   *  previously started a server on this port.
   */
  myClient = new Client(this, "127.0.0.1", 5204); 
} 

void draw() {
  if (myClient.available() > 0) {
    background(0);
    controlsInput = split(myClient.readString(), ',');
    for (int i = 0; i < controlsInput.length; i++){
      controls[i] = new Control(controlsInput);
    }
  }
}
