import java.io.File;

public class ChangeExt {

    public static void main(String[] args){

        for(File f:new File(".").listFiles()){
            if(f.getName().endsWith(".txt")){
                String name=f.getName().replace(".txt",".bak");
                f.renameTo(new File(name));
            }
        }
    }
}
