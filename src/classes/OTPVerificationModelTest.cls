@isTest 
 public class OTPVerificationModelTest {
    public static testmethod void myUnitTest(){
     OTPVerificationModel p = new OTPVerificationModel();
     p.PhoneList_Options= new List<KeyValuePairModel>();
     p.EmailsList_Options= new List<KeyValuePairModel>();
     p.IsIneligible ='Yes';
     p.Brand ='Chevron';
    
   }
}