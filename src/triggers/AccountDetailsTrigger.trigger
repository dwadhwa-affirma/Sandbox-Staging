trigger AccountDetailsTrigger on Account_Details__c (before insert, before update) {
 
    if(trigger.isBefore){
        if(trigger.isInsert){
            myMethod(Trigger.new);
            myMethod3(Trigger.new);
        }
        if(trigger.isUpdate){
            myMethod(Trigger.new);
            myMethod3(Trigger.new);
            updateMemberBranchonMember(Trigger.new);
            updateMemberEpisysUseronMember(Trigger.new);
        }
    }
   
public void myMethod(List<Account_Details__c> accList){
    
    Map<Double,String> episysMap = new Map<Double,String>();
    Map<Double,String> aliasMap = new Map<Double,String>();
    Set<Double> episysSet = new Set<Double>();
    
    List<Episys_User__c> epiUsr = [Select Episys_ID__c, Episys_Name__c, Alias__c from Episys_User__c];
    
    for(Episys_User__c eu : epiUsr){
        episysMap.put(eu.Episys_ID__c, eu.Episys_Name__c); 
        aliasMap.put(eu.Episys_ID__c, eu.Alias__c);
        episysSet.add(eu.Episys_ID__c);
    }
 
    for(Account_Details__c acc : Trigger.new){
        if(acc.Created_By_User__c != null){
           acc.Created_By_User_Text__c = episysMap.get(acc.Created_By_User__c);
           acc.Created_By_User_Alias__c = aliasMap.get(acc.Created_By_User__c);
        }
    }
}


public void updateMemberBranchonMember(List<Account_Details__c> accList)
{
  
  List<string> ids = new List<string>();
  Map<Id,string> accountMemberBranch = new Map<Id,string>(); 
    for(Account_Details__c acc : accList)
    {
      boolean changeBranch = true;
      
      if(Trigger.isupdate)
      {
        Account_Details__c accOldDetails = Trigger.oldMap.get(acc.Id);  
        if(accOldDetails.Current_Branch1__c == acc.Current_Branch1__c)
        {
          changeBranch = false;
        }
      }
      
      if(changeBranch && acc.RecType__C == 'ACCT')
      {
        ids.add(acc.id);
        accountMemberBranch.put(acc.id,acc.Current_Branch1__c);
      }
    }
  
  List<Person_Account__C> listPA = [select id,Account_Number__c,PersonId__c from Person_Account__C where Account_Number__c in : ids];
  
  Map<string,string> listMemberBranch = new Map<string,string>();
  List<string> listMembers = new List<string>();
   
  for(Person_Account__C item : listPA)
  {
    listMembers.add(item.PersonId__c);
    
  }
  
  List<Person_Account__C> listAccMember = [select id,PersonId__c,Account_Number__c from Person_Account__C where PersonId__c in: listMembers and Account_Number__r.RecType__c = 'ACCT'];
  
  Set<string> memberFound = new Set<string>(); 
  
  for(Person_Account__C item : listAccMember)
  {
    if(!memberFound.contains(item.Id))
    {
      string branch = accountMemberBranch.get(item.Account_Number__c);
      memberFound.add(item.PersonId__c);
      listMemberBranch.put(item.PersonId__c, branch);
    }
    
  }
  
  List<Account> listMainAccount = [select id,Member_Branch__c from Account where Id in: memberFound];
  List<Valid_Branch__c> branchList = [select id,Name from Valid_Branch__c];
  Set<String> existingBranch = new Set<String>();
  
  for(Account acc: listMainAccount)
  {
    string memberBranch = listMemberBranch.get(acc.id);
    existingBranch.add(listMemberBranch.get(acc.id));
    
    for(Integer i=0;i<branchList.size();i++)
    {
      String branchName = branchList[i].Name;
      
      if (existingBranch.contains(branchName))
        {
            acc.Member_Branch__c = memberBranch;
        }
      }
  }
  
  update listMainAccount;
     
}

private boolean IsOtherThanEmailFieldUpdated()
{ 
        Account_Details__c gplObject = new Account_Details__c(); // This takes all available fields from the required object. 
        Schema.SObjectType objType = gplObject.getSObjectType(); 
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Account_Details__c.fields.getMap(); 
        
        for(Account_Details__c   gpl : trigger.new)
        {
            Account_Details__c   oldGPL = trigger.oldMap.get(gpl.Id);

            for (String str : mapFields.keyset()) 
            { 
                try 
                { 
                    if(gpl.get(str) != oldGPL.get(str) && str.toLowerCase() != 'secureemailaddress__c')
                    { 
                      System.Debug('Other than Email updated...' + str);
                        return true; 
                    } 
                } 
                catch (Exception e) 
                { 
                    System.Debug('Error: ' + e); 
                } 
            }
        }
        System.Debug('No Other field than Email updated...');
        
        return false;
}
    
public void myMethod3(List<Account_Details__c> accList){
         
     Map<String, String> wcMap = new Map<String, String>();
     
     if(trigger.IsUpdate && !IsOtherThanEmailFieldUpdated())
     {
       return;
     }
         
     List<WarningCodeMapping__c> wcList = [SELECT Warning_Code_Number__c, Warning_Code_Text__c FROM WarningCodeMapping__c];

        for(WarningCodeMapping__c wc : wcList){
            wcMap.put(wc.Warning_Code_Number__c, wc.Warning_Code_Text__c);
        }
        
        for(Account_Details__c acc : Trigger.new){
             if(acc.WARNING_01_CODE__c != null || acc.WARNING_01_CODE__c != '' || acc.WARNING_01_CODE__c != '000-NONE'){
                 acc.WARNING_01_CODE__c = wcMap.get(acc.WARNING_01_CODE__c);
             }
             if(acc.WARNING_02_CODE__c != null || acc.WARNING_02_CODE__c != '' || acc.WARNING_02_CODE__c != '000-NONE'){
                 acc.WARNING_02_CODE__c = wcMap.get(acc.WARNING_02_CODE__c);
             }
             if(acc.WARNING_03_CODE__c != null || acc.WARNING_03_CODE__c != '' || acc.WARNING_03_CODE__c != '000-NONE'){
                 acc.WARNING_03_CODE__c = wcMap.get(acc.WARNING_03_CODE__c);
             }
             if(acc.WARNING_04_CODE__c != null || acc.WARNING_04_CODE__c != '' || acc.WARNING_04_CODE__c != '000-NONE'){
                 acc.WARNING_04_CODE__c = wcMap.get(acc.WARNING_04_CODE__c);
             }
             if(acc.WARNING_05_CODE__c != null || acc.WARNING_05_CODE__c != '' || acc.WARNING_05_CODE__c != '000-NONE'){
                 acc.WARNING_05_CODE__c = wcMap.get(acc.WARNING_05_CODE__c);
             }
             if(acc.WARNING_06_CODE__c != null || acc.WARNING_06_CODE__c != '' || acc.WARNING_06_CODE__c != '000-NONE'){
                 acc.WARNING_06_CODE__c = wcMap.get(acc.WARNING_06_CODE__c);
             }
             if(acc.WARNING_07_CODE__c != null || acc.WARNING_07_CODE__c != '' || acc.WARNING_07_CODE__c != '000-NONE'){
                 acc.WARNING_07_CODE__c = wcMap.get(acc.WARNING_07_CODE__c);
             }
             if(acc.WARNING_08_CODE__c != null || acc.WARNING_08_CODE__c != '' || acc.WARNING_08_CODE__c != '000-NONE'){
                 acc.WARNING_08_CODE__c = wcMap.get(acc.WARNING_08_CODE__c);
             }
             if(acc.WARNING_09_CODE__c != null || acc.WARNING_09_CODE__c != '' || acc.WARNING_09_CODE__c != '000-NONE'){
                 acc.WARNING_09_CODE__c = wcMap.get(acc.WARNING_09_CODE__c);
             }
             if(acc.WARNING_10_CODE__c != null || acc.WARNING_10_CODE__c != '' || acc.WARNING_10_CODE__c != '000-NONE'){
                 acc.WARNING_10_CODE__c = wcMap.get(acc.WARNING_10_CODE__c);
             }
             if(acc.WARNING_11_CODE__c != null || acc.WARNING_11_CODE__c != '' || acc.WARNING_11_CODE__c != '000-NONE'){
                 acc.WARNING_11_CODE__c = wcMap.get(acc.WARNING_11_CODE__c);
             }
             if(acc.WARNING_12_CODE__c != null || acc.WARNING_12_CODE__c != '' || acc.WARNING_12_CODE__c != '000-NONE'){
                 acc.WARNING_12_CODE__c = wcMap.get(acc.WARNING_12_CODE__c);
             }
             if(acc.WARNING_13_CODE__c != null || acc.WARNING_13_CODE__c != '' || acc.WARNING_13_CODE__c != '000-NONE'){
                 acc.WARNING_13_CODE__c = wcMap.get(acc.WARNING_13_CODE__c);
             }
             if(acc.WARNING_14_CODE__c != null || acc.WARNING_14_CODE__c != '' || acc.WARNING_14_CODE__c != '000-NONE'){
                 acc.WARNING_14_CODE__c = wcMap.get(acc.WARNING_14_CODE__c);
             }
             if(acc.WARNING_15_CODE__c != null || acc.WARNING_15_CODE__c != '' || acc.WARNING_15_CODE__c != '000-NONE'){
                 acc.WARNING_15_CODE__c = wcMap.get(acc.WARNING_15_CODE__c);
             }
             if(acc.WARNING_16_CODE__c != null || acc.WARNING_16_CODE__c != '' || acc.WARNING_16_CODE__c != '000-NONE'){
                 acc.WARNING_16_CODE__c = wcMap.get(acc.WARNING_16_CODE__c);
             }
             if(acc.WARNING_17_CODE__c != null || acc.WARNING_17_CODE__c != '' || acc.WARNING_17_CODE__c != '000-NONE'){
                 acc.WARNING_17_CODE__c = wcMap.get(acc.WARNING_17_CODE__c);
             }
             if(acc.WARNING_18_CODE__c != null || acc.WARNING_18_CODE__c != '' || acc.WARNING_18_CODE__c != '000-NONE'){
                 acc.WARNING_18_CODE__c = wcMap.get(acc.WARNING_18_CODE__c);
             }
             if(acc.WARNING_19_CODE__c != null || acc.WARNING_19_CODE__c != '' || acc.WARNING_19_CODE__c != '000-NONE'){
                 acc.WARNING_19_CODE__c = wcMap.get(acc.WARNING_19_CODE__c);
             }
             if(acc.WARNING_20_CODE__c != null || acc.WARNING_20_CODE__c != '' || acc.WARNING_20_CODE__c != '000-NONE'){
                 acc.WARNING_20_CODE__c = wcMap.get(acc.WARNING_20_CODE__c);
             }
         }    
} 

public void updateMemberEpisysUseronMember(List<Account_Details__c> accList)
{
  
  List<string> ids = new List<string>();
  Map<Id,string> accountMemberEpisysUser = new Map<Id,string>(); 
    for(Account_Details__c acc : accList)
    {
      boolean changeEpisysUser = true;
      
      if(Trigger.isupdate)
      {
        Account_Details__c accOldDetails = Trigger.oldMap.get(acc.Id);  
        if(accOldDetails.Created_By_User_Alias__c == acc.Created_By_User_Alias__c)
        {
          changeEpisysUser = false;
        }
      }
      
      if(changeEpisysUser && acc.RecType__C == 'ACCT')
      {
        ids.add(acc.id);
        accountMemberEpisysUser.put(acc.id,acc.Created_By_User_Alias__c);
      }
    }
  
  List<Person_Account__C> listPA = [select id,Account_Number__c,PersonId__c from Person_Account__C where Account_Number__c in : ids];
  
  Map<string,string> listMemberEpisysUser = new Map<string,string>();
  List<string> listMembers = new List<string>();
   
  for(Person_Account__C item : listPA)
  {
    listMembers.add(item.PersonId__c);
    
  }
  
  List<Person_Account__C> listAccMember = [select id,PersonId__c,Account_Number__c from Person_Account__C where PersonId__c in: listMembers and Account_Number__r.RecType__c = 'ACCT'];
  
  Set<string> memberFound = new Set<string>(); 
  
  for(Person_Account__C item : listAccMember)
  {
    if(!memberFound.contains(item.Id))
    {
      string episysUser = accountMemberEpisysUser.get(item.Account_Number__c);
      memberFound.add(item.PersonId__c);
      listMemberEpisysUser.put(item.PersonId__c, episysUser);
    }
    
  }
  
  List<Account> listMainAccount = [select id,Created_By_Episys_User_Alias__c from Account where Id in: memberFound];
  List<Episys_User__c> episysUserList = [select id,Name, Alias__c from Episys_User__c];
  Set<String> existingUsers = new Set<String>();
  
  for(Account acc: listMainAccount)
  {
    string memberUser = listMemberEpisysUser.get(acc.id);
    existingUsers.add(listMemberEpisysUser.get(acc.id));
    
    for(Integer i=0;i<episysUserList.size();i++)
    {
      String userAlias = episysUserList[i].Alias__c;
      
      if (existingUsers.contains(userAlias))
        {
            acc.Created_By_Episys_User_Alias__c = memberUser;
        }
      }
  }
  
  update listMainAccount;
     
}
}