@isTest 
 public class OTPVerificationModelTest {
    public static testmethod void myUnitTest(){
     OTPVerificationModel p = new OTPVerificationModel();
     p.PhoneList_Options= new List<KeyValuePairModelWithBit>();
     p.EmailsList_Options= new List<KeyValuePairModelWithBit>();
     p.IsIneligible ='Yes';
     p.Brand ='Chevron';
    
   }
}