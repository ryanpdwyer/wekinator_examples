
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JPanel;
import java.awt.BorderLayout;

void setup() {
  pixelDensity(displayDensity());
  size(600, 400);
  background(117, 47, 138);
  println(System.getProperty("java.version"));
  fill(255);
  PFont arial = createFont("Tahoma Bold", 32);
  textFont(arial);
  text("Welcome to FYS,", 20, 40);
  JTextField field  = new JTextField(20);
  JLabel label = new JLabel("Enter your name:");
  JPanel p = new JPanel(new BorderLayout(5, 2));
  p.add(label, BorderLayout.WEST);
  p.add(field);
  JOptionPane.showMessageDialog(null, p, "Input required", JOptionPane.PLAIN_MESSAGE, null);
  String in = field.getText();
  text(in+"!", 20, 80);
  String os = System.getProperty("os.name");
  String osVersion = System.getProperty("os.version");
  PFont tahoma = createFont("Tahoma", 24);
  textFont(tahoma);
  text("Computer information:", 20, 120);
  text("OS: "+os, 20, 150);
  text("Version: "+osVersion, 20, 180);
  text("User: "+System.getProperty("user.name"), 20, 210);
  text("Paste a screenshot of this screen into your Word doc.", 20, 380);
}
