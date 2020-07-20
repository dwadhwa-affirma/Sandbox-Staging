global with sharing class MemberConnectReportContoller {
    @AuraEnabled
    public static  List<MemberConnectReportContoller.CountName> getTotalCount()
    {
        List<MemberConnectReportContoller.CountName> lstcn = new List<MemberConnectReportContoller.CountName>();
        Map<string,integer> Mapcount = new Map<string,integer>();
        
        List<Needs_Assesment__c> lst =[select id, name , role_name__c , lastmodifiedById, createdbyId,createdby.Name , LastModifiedby.Name, Member__r.Name from Needs_Assesment__c where (CreatedDate = LAST_N_DAYS:30 or lastmodifieddate = LAST_N_DAYS:30  ) ];
        for(Needs_Assesment__c na : lst){
            boolean flag = false;
            for(CountName lstc : lstcn){
                if(na.createdby.Name == lstc.name){
                   lstc.count += 1;
                   flag = true;
                }
            }
            if(!flag){
                    MemberConnectReportContoller.CountName temp = new MemberConnectReportContoller.CountName();
                	temp.id = na.createdbyId;
                    temp.name =na.createdby.Name;
                    temp.count = 1;
                    lstcn.add(temp);
            }
           
            if(na.LastModifiedby.Name != na.createdby.Name){
                boolean flag2 = false;
                for(CountName lstc : lstcn){
                    if(na.LastModifiedby.Name == lstc.name){
                       lstc.count += 1;
                       flag2 = true;
                    }
                }
                if(!flag2){
                    MemberConnectReportContoller.CountName temp = new MemberConnectReportContoller.CountName();
                    temp.id=na.LastModifiedbyid;
                    temp.name =na.LastModifiedby.Name;
                    temp.count = 1;
                    lstcn.add(temp);
                }
            }        
       
        }
        system.debug('----'+lstcn);
        return lstcn;
    }
    public class CountName{
         @AuraEnabled
        public  string ID{get;set;}
        @AuraEnabled
        public string Name;
        @AuraEnabled
        public integer Count;
        
    }
}