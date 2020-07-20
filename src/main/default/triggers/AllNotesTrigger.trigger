trigger AllNotesTrigger on AllNotes__c (before insert, before update) {
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            myMethod(Trigger.new);
        }
        if(trigger.isUpdate){
            myMethod(Trigger.new);
        }
    }

    public void myMethod(List<AllNotes__c> ntsList){
    
    Map<Double,String> episysMap = new Map<Double,String>();
    Set<Double> episysSet = new Set<Double>();
    
    List<Episys_User__c> epiUsr = [Select Episys_ID__c, Episys_Name__c from Episys_User__c];
    
    for(Episys_User__c eu : epiUsr){
        episysMap.put(eu.Episys_ID__c, eu.Episys_Name__c);       
        episysSet.add(eu.Episys_ID__c);
    }
 
    for(AllNotes__c nts : Trigger.new){
        if(nts.Created_By_User__c != null){
           nts.Created_By_User_Text__c = episysMap.get(nts.Created_By_User__c);
        }
    }
  }
}