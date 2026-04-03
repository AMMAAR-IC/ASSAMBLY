import java.util.*;

public class DigitArray {

    public static void main(String[] args){

        Random r=new Random();

        int[] arr=new int[10];

        for(int i=0;i<arr.length;i++){
            arr[i]=r.nextInt(10);
            System.out.print(arr[i]+" ");
        }
    }
}
