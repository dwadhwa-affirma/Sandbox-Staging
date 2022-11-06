@IsTest
public with sharing class CreateContactControllerTest {
   
  @testSetup
  static void setupTestData(){
    Account acc = DataFactoryTestClass.createAccount(true, 'MARIA', 'BANDA','test@test.com','test1@test.com');    
  }
  static testMethod void test_FetchAccData(){      
      Account acc1 = DataFactoryTestClass.createAccount(true, 'MARIA1', 'BANDA1','test1@test.com','test2@test.com');
      CreateContactController.FetchAccData(acc1.id);
  }
  static testMethod void test_getCountriesandstate(){
         Map<string,string> countrymap = CreateContactController.getCountries();
         Map<string,string> statemap = CreateContactController.getStates();
  }
  
}