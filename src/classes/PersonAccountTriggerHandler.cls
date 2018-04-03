public with sharing class PersonAccountTriggerHandler {
   // 
    public static void createCase(map<Id,Person_Account__c> newMap){
        list<Person_Account__c> paList = new list<Person_Account__c>();
        set<Id> personIds = new set<Id>();
        set<Id> accDetailIds = new set<Id>();
        map<Id,Account> personMap = new map<Id,Account>();
        map<Id,Account_Details__c> accDetailMap = new map<Id,Account_Details__c>();
        list<Case> caseList = new list<Case>();
      //  map<double,Id> userMap = new map<double,Id>();
        map<String,Id> userMap1 = new map<String,Id>();
        map<String,Id> userAliasMap = new map<String,Id>();
        
        for(Person_Account__c pa: newMap.values()){
            if(pa.Name_Type__c == 0){
              //CRM-1090 only add person whose open date is within 7 days
              if (pa.Open_Date__c != null && pa.Open_Date__c.daysBetween(date.today()) <= 7)
              {
                System.debug('adding person account with open date..' + pa.Open_Date__c);
                System.debug('adding person account with Account ID..' + pa.AccountID__c);
                  paList.add(pa); 
                  personIds.add(pa.PersonID__c);
                  accDetailIds.add(pa.Account_Number__c);
              }
              else
              {
                System.debug('Not adding person account with open date..' + pa.Open_Date__c);
                System.debug('Not adding person account with Account ID..' + pa.AccountID__c);
                  
              }                
            }
        }
        
        list<Account> personList = [SELECT Id,firstname, Lastname, PersonHomePhone, 
                                    PersonEmail, Residential_Street__pc, Residential_City__pc, 
                                    Residential_State__pc, Residential_Zipocde__pc FROM Account WHERE Id IN: personIds];
        Set<Id> perId = new Set<Id>();
        for(Account pl: personList){
            personMap.put(pl.Id, pl);
            perId.add(pl.Id);
        }
        
        list<Account_Details__c> accDetailList = [SELECT Id, Open_Date__c, Created_By_User__c, OnBoarded__c, Created_By_User_Text__c, Created_By_User_Alias__c FROM Account_Details__c WHERE Id IN: accDetailIds];
        for(Account_Details__c adl: accDetailList){
            accDetailMap.put(adl.Id, adl);
        }
        
        List<Contact> con = [Select Id, Name, AccountId from Contact where Contact.AccountId =:perId];
        Map<Id,Id> conMap = new Map<Id,Id>();
        for(Contact ct : con){
            conMap.put(ct.AccountId, ct.Id);
        }
 
       // Id queueGroupId = [SELECT Id FROM Group WHERE Type='Queue' AND Name= 'Operations-Memberships Queue'].Id;
        Id queueGroupId = [SELECT Id FROM Group WHERE Type='Queue' AND Name= 'eBranch Queue'].Id;
        
        //list<User> userList = [SELECT Id, Name, Alias, IsActive FROM User where IsActive = true];
        
        list<User> userList = [SELECT Id, Name, Alias, IsActive FROM User
                                where (Profile.Name !='Messaging center Customers') and (isActive = True)];

        
        
        for(User u: userList){
            userMap1.put(u.Name.toupperCase(), u.Id);
            userAliasMap.put(u.Alias, u.Id);
        } 
        
        list<User> userList1 = [SELECT Id, Name, Alias, IsActive FROM User where IsActive = false];
        Set<Id> uList = new Set<Id>();
        for(User u : userList1){
            uList.add(u.Id);
        } 

        for(Person_Account__c var: paList){
            
            if(accDetailMap.get(var.Account_Number__c).OnBoarded__c == true){
            Case c = new Case();
                c.RecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
                c.Primary_Category__c = 'Account Maintenance';
                c.Secondary_Category__c = 'OnBoarding';
                c.Tertiary_Category__c = 'None';
                c.Status = 'Open';
                c.Account_Number__c = var.Account_Number__c;
               // c.AccountId = personMap.get(var.PersonID__c).Id;
                c.AccountId = var.PersonID__c;
                if(c.ContactId == NULL){
                    c.ContactId = conMap.get(var.PersonID__c);
                }
                c.First_Name__c = personMap.get(var.PersonID__c).firstname;
                c.Last_Name__c = personMap.get(var.PersonID__c).lastname;
                c.Phone_Number__c = personMap.get(var.PersonID__c).PersonHomePhone;
                c.Email_Address__c = personMap.get(var.PersonID__c).PersonEmail;
                c.Street_Address_1__c = personMap.get(var.PersonID__c).Residential_Street__pc;
                c.City__c = personMap.get(var.PersonID__c).Residential_City__pc;
                c.State__c = personMap.get(var.PersonID__c).Residential_State__pc;
                c.Zip_Code__c = personMap.get(var.PersonID__c).Residential_Zipocde__pc;
                c.Membership_account_created_date__c = accDetailMap.get(var.Account_Number__c).OPEN_DATE__c;
                             
                system.debug('accdetailmap ..' + accDetailMap);
                system.debug('var.accounnumber ' + var.Account_Number__c);
                system.debug('check for user..' + userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c));
                
                if(userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c) != null){
                  system.debug('###Inside  assigning owner' + userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c));
               // if(userMap1.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Text__c) != null){
                    c.OwnerId = userAliasMap.get((accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c).toupperCase());
                }else if(userAliasMap.get(accDetailMap.get(var.Account_Number__c).Created_By_User_Alias__c) == null || accDetailMap.get(var.Account_Number__c).Created_By_User__c == NULL 
                   || uList != NULL){
                    system.debug('Inside assigning eBranch queue');
                    c.OwnerId = queueGroupId;
                }
            
            caseList.add(c);
        }            
        }
        
        try{
            insert caseList;
            System.debug('Case is:::'+caseList);
        }catch(Exception e){
            System.debug('An error was encountered :'+e);
        }
        for(Account_Details__c ad : accDetailList){
           ad.OnBoarded__c = false;
        }
        update accDetailList;
    }
}