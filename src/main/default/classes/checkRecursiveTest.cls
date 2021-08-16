@IsTest
public class checkRecursiveTest {
    @IsTest public static void checkRecursiveTest1(){
    
       checkRecursive.runOnce();
    }
    @IsTest public static void checkRecursiveTest2(){
    
       checkRecursive.run=false;
       checkRecursive.runOnce();
    }
}