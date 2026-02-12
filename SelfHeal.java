import java.io.*;

public class SelfHeal {
    public static void main(String[] args) throws Exception {
        Process p = Runtime.getRuntime().exec("pgrep nginx");
        if(p.getInputStream().read() == -1){
            System.out.println("nginx down -> restarting...");
            Runtime.getRuntime().exec("sudo systemctl restart nginx");
        } else {
            System.out.println("nginx running");
        }
    }
}
