/*--------------------------Batch Class to Update Members' HP/HV Data---------------------------------------*/
global class MemberHPVUpdateBatchJob implements Database.Batchable<SObject>{

    private Set<String> AccountIds;

    public MemberHPVUpdateBatchJob(Set<String> strParam){
        AccountIds = strParam;
    }

    global Iterable<SObject> start(Database.BatchableContext BC){
        String query = 'SELECT Id,Account_Number__c,Account_Number__r.RecType__c, Account_Number__r.Name, PersonID__c, Account_Number__r.High_Value_Flag__c, Account_Number__r.OPEN_DATE__c FROM Person_Account__c WHERE PersonID__c IN: AccountIds and TypeTranslate__c in (\'0001/Joint Member\',\'0000/Primary\')';
        System.debug('query='+query);
        System.debug('AccountIds='+AccountIds);
        return Database.getQueryLocator(query); 

    }
    global void execute(Database.BatchableContext BC, List<Person_Account__c> listPersonAccount)
    {
        System.debug(listPersonAccount.size());
        set<String> accountNumberSet = new set<String>();
		set<Id> accIdset = new set<Id>();
        set<String> acctypeSet = new set<String>();
        map<id, Integer> mapAccountHPCount = new map<id, Integer>();
        map<id, Integer> mapAccountHVCount = new map<id, Integer>();

        map<id, String> mapHPPeronAccountNo = new map<id, String>();
        map<id, String> mapHVPeronAccountNo = new map<id, String>();
        map<id, Date> mapOpenDate = new map<id, Date>();
        map<Id, Member_HP_HV__c> MapMemberIds = new map<Id, Member_HP_HV__c>();
        map<Id,Integer> MemberIdstoUpdateHV = new map<Id,Integer>();
        map<Id,Integer> MemberIdstoInsertHV = new map<Id,Integer>();
        map<Id,Integer> MemberIdstoUpdateHP = new map<Id,Integer>();
        map<Id,Integer> MemberIdstoInsertHP = new map<Id,Integer>();        
        List<Member_HP_HV__c> updateHVList = new List<Member_HP_HV__c>();
        List<Member_HP_HV__c> inserHVList = new List<Member_HP_HV__c>();
        List<Member_HP_HV__c> updateHPList = new List<Member_HP_HV__c>();
        List<Member_HP_HV__c> inserHPList = new List<Member_HP_HV__c>();
        
		for(Person_Account__c var: listPersonAccount){           	
            if(var.Account_Number__r.High_Value_Flag__c == 1 && mapHVPeronAccountNo.get(var.PersonID__c) != var.Account_Number__r.Name){
                if(mapAccountHVCount.containsKey(var.PersonID__c)){
                    Integer currentCount = mapAccountHVCount.get(var.PersonID__c);
                    mapAccountHVCount.remove(var.PersonID__c);
                    mapAccountHVCount.put(var.PersonID__c,currentCount+1);
                    mapHVPeronAccountNo.put(var.PersonID__c,var.Account_Number__r.Name);
                    if(mapOpenDate.get(var.PersonID__c) > var.Account_Number__r.OPEN_DATE__c){
                        mapOpenDate.remove(var.PersonID__c);
                        mapOpenDate.put(var.PersonID__c,var.Account_Number__r.OPEN_DATE__c);
                    }
                }
                else{
                    mapAccountHVCount.put(var.PersonID__c,1);   
                    mapHVPeronAccountNo.put(var.PersonID__c,var.Account_Number__r.Name);
                    mapOpenDate.put(var.PersonID__c, var.Account_Number__r.OPEN_DATE__c);              
                }
                accIdset.add(var.PersonID__c);
            } 
            if(var.Account_Number__r.High_Value_Flag__c == 2 && mapHPPeronAccountNo.get(var.PersonID__c) != var.Account_Number__r.Name){
                if(mapAccountHPCount.containsKey(var.PersonID__c)){
                    Integer currentCount = mapAccountHPCount.get(var.PersonID__c);
                    mapAccountHPCount.remove(var.PersonID__c);
                    mapAccountHPCount.put(var.PersonID__c,currentCount+1);
                    mapHPPeronAccountNo.put(var.PersonID__c,var.Account_Number__r.Name);
                    if(mapOpenDate.get(var.PersonID__c) > var.Account_Number__r.OPEN_DATE__c){
                        mapOpenDate.remove(var.PersonID__c);
                        mapOpenDate.put(var.PersonID__c,var.Account_Number__r.OPEN_DATE__c);
                    }
                }
                else{
                    mapAccountHPCount.put(var.PersonID__c,1);
                    mapHPPeronAccountNo.put(var.PersonID__c,var.Account_Number__r.Name);
                    mapOpenDate.put(var.PersonID__c, var.Account_Number__r.OPEN_DATE__c); 
                }
                accIdset.add(var.PersonID__c);
            }    	
		    
        }
        System.debug('mapAccountHPCount=='+mapAccountHPCount);
        System.debug('mapAccountHVCount=='+mapAccountHVCount);
       
        List<Member_HP_HV__c> HVPList = [SELECT id, Member__c, Total_HPV__c, Total_HV__c from Member_HP_HV__c WHERE Member__c in: accIdset];
        for(Member_HP_HV__c mhp: HVPList){
            MapMemberIds.put(mhp.Member__c,mhp);
        }
        System.debug('MapMemberIds=='+MapMemberIds);
        for (Id key : mapAccountHVCount.keySet()) {
            if(MapMemberIds.containsKey(key)){
                MemberIdstoUpdateHV.put((Id)MapMemberIds.get(key).get('Id'),mapAccountHVCount.get(key));
            }
            else{
                MemberIdstoInsertHV.put(key,mapAccountHVCount.get(key));
            }
        }


        System.debug('MemberIdstoUpdateHP=='+MemberIdstoUpdateHV);
        System.debug('MemberIdstoInsertHP=='+MemberIdstoInsertHV);

        updateHVList = [SELECT id,Member__c from Member_HP_HV__c where id in: MemberIdstoUpdateHV.keySet()];
        for(Member_HP_HV__c u: updateHVList){
            u.Total_HV__c = MemberIdstoUpdateHV.get(u.Id);
            u.Oldest_Account_Open_Date__c = mapOpenDate.get(u.Member__c);
        }
        System.debug('updateHVList=='+updateHVList);
        update updateHVList;

        for(Id key : MemberIdstoInsertHV.keySet()){
            Member_HP_HV__c temp = new Member_HP_HV__c();
            temp.Member__c = key;
            temp.Total_HV__c = MemberIdstoInsertHV.get(key);
            temp.Oldest_Account_Open_Date__c = mapOpenDate.get(key);
            inserHVList.add(temp);
        }
        insert inserHVList;

        List<Member_HP_HV__c> HVPList1 = [SELECT id, Member__c, Total_HPV__c, Total_HV__c from Member_HP_HV__c WHERE Member__c in: accIdset];
        map<Id, Member_HP_HV__c> MapMemberIds1 = new map<Id, Member_HP_HV__c>();
        for(Member_HP_HV__c mhp: HVPList1){
            MapMemberIds1.put(mhp.Member__c,mhp);
        }

        System.debug('MapMemberIds1=='+MapMemberIds1);

        for (Id key : mapAccountHPCount.keySet()) {
            if(MapMemberIds1.containsKey(key)){
                MemberIdstoUpdateHP.put((Id)MapMemberIds1.get(key).get('Id'),mapAccountHPCount.get(key));
            }
            else{
                MemberIdstoInsertHP.put(key,mapAccountHPCount.get(key));
            }
        }        
        System.debug('MemberIdstoUpdateHP=='+MemberIdstoUpdateHP);
        System.debug('MemberIdstoInsertHP=='+MemberIdstoInsertHP);        
        
        updateHPList = [SELECT id,Member__c from Member_HP_HV__c where id in: MemberIdstoUpdateHP.keySet()];
        System.debug('updateHPList=='+updateHPList);
        for(Member_HP_HV__c u: updateHPList){
            u.Total_HPV__c = MemberIdstoUpdateHP.get(u.Id);
            u.Oldest_Account_Open_Date__c = mapOpenDate.get(u.Member__c);
            System.debug('u.Total_HPV__c=='+u.Total_HPV__c);
        }
        update updateHPList;        

        for(Id key : MemberIdstoInsertHP.keySet()){
            Member_HP_HV__c temp = new Member_HP_HV__c();
            temp.Member__c = key;
            temp.Total_HPV__c = MemberIdstoInsertHP.get(key);
            temp.Oldest_Account_Open_Date__c = mapOpenDate.get(key);
            inserHPList.add(temp);
        }

        insert inserHPList;

    }

    global void finish(Database.BatchableContext BC){

    }
}