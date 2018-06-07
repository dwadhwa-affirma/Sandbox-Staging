trigger MCPINChange on MC_PIN_Change__c (after insert) {
    
    list<string> listString = new list<string>();  
    for(MC_PIN_Change__c item: trigger.New)
    {
    		listString.add(item.id);
    }
    MCPINChangeBatchClass obj = new MCPINChangeBatchClass();
    obj.MCPINChangeString = listString;
    Database.executeBatch(obj, 10);
}