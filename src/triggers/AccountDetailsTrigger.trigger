trigger AccountDetailsTrigger on Account_Details__c (before insert, before update) {
 
    if(trigger.isBefore){
        if(trigger.isInsert){
            myMethod(Trigger.new);
            myMethod3(Trigger.new);
        }
        if(trigger.isUpdate){
            myMethod(Trigger.new);
            myMethod3(Trigger.new);
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

private boolean IsOtherThanEmailFieldUpdated()
{ 
        Account_Details__c gplObject = new Account_Details__c(); // This takes all available fields from the required object. 
        Schema.SObjectType objType = gplObject.getSObjectType(); 
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Account_Details__c.fields.getMap(); 
        
        for(Account_Details__c	 gpl : trigger.new)
        {
            Account_Details__c	 oldGPL = trigger.oldMap.get(gpl.Id);

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
}