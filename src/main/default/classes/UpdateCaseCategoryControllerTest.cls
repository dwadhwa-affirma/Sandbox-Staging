@isTest
public class UpdateCaseCategoryControllerTest {
static testMethod void testMethod1(){
    list<Case> caselist = new List<Case>();
    		Case cs = new Case();
           cs.Brand__c = 'CFCU';
           cs.Primary_Category__c = 'Shared Branching';
    		cs.Secondary_Category__c ='Servicing'	;
    		cs.Tertiary_Category__c = 'Dispute';
        caselist.add(cs);
    	Case cs1 = new Case();
           cs1.Brand__c = 'CFCU';
           cs1.Primary_Category__c = '-None-';
    	caselist.add(cs1);
    	Case cs2 = new Case();
           cs2.Brand__c = 'CFCU';
           cs2.Primary_Category__c = '';
    	caselist.add(cs2);
    	Case cs3 = new Case();
           cs3.Brand__c = 'CFCU';
           cs3.Primary_Category__c = 'Shared Branching';
    		cs3.Secondary_Category__c ='-None-'	;	
    	caselist.add(cs3);
    	insert caselist;
   Map<string,object> casemap = UpdateCaseCategoriesController.getData(cs.id);
    Map<string,object> casemap1 = UpdateCaseCategoriesController.saveCategories(cs);
     Map<string,object> casemap2 = UpdateCaseCategoriesController.saveCategories(cs1);
      Map<string,object> casemap11 = UpdateCaseCategoriesController.saveCategories(cs2);
      Map<string,object> casemap12 = UpdateCaseCategoriesController.saveCategories(cs3);
    //Map<String, Map<String, List<String>>> casemap2 = UpdateCaseCategoriesController.getPicklistValues('Shared Branching');
    Map<String,List<String>> casemap3 =  UpdateCaseCategoriesController.getDependentOptionsImpl('case', 'Primary_Category__c', 'Secondary_Category__c');
    List<KeyValuePairModel> caselist3 = UpdateCaseCategoriesController.getscOptions('Shared Branching');
    List<KeyValuePairModel> caselist1 =  UpdateCaseCategoriesController.pcOptions();
    List<KeyValuePairModel> caselist2 =  UpdateCaseCategoriesController.gettcOptions('Servicing');
}
}