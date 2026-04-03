public class LowercaseCount {

    public static void main(String[] args){

        String s="JavaProgramming";

        int count=0;

        for(char c:s.toCharArray())
            if(Character.isLowerCase(c))
                count++;

        System.out.println(count);
    }
}
