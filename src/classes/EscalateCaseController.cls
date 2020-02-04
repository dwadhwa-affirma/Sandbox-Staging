public class EscalateCaseController {
    public static void checkAndEscalate(List<Case> allCases){
       // Case cs = [select id,Stage__c,lastModifiedDate from Case where id ='5003F0000062TWb'];
       BusinessHours businessHours = [SELECT Id, Name, IsActive, IsDefault, SundayStartTime, SundayEndTime, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime, TimeZoneSidKey, SystemModstamp, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, LastViewedDate FROM BusinessHours 
                                       WHERE IsDefault = true limit 1];
        Map<String,Integer> SLAStageMap = new Map<String,Integer>(); 
        List<Create_SLA__c> csla = Create_SLA__c.getall().values();
        List<Case> allCasesToUpdate =  new List<Case>();
        Set<String> statuses = new Set<String>();
        for(Create_SLA__c cslas : csla){
            statuses.add(cslas.Status__c);
            SLAStageMap.put(cslas.Status__c,Integer.ValueOf(cslas.Hours__c));
        }
        for(Case cs : allCases){
            Long hours = SLAStageMap.get(cs.Status); 
            DateTime dt;
            if(cs.lastModifiedDate != null){
            	dt = cs.lastModifiedDate.addHours(0);
            }
            else{
                dt = System.now().addHours(0);
            }
            system.debug('hours' + hours);
            system.debug('businessHours.Id' + businessHours.Id);
            system.debug('dt' + dt);
            if(hours != null){
                cs.Escalates_At__c = System.BusinessHours.addGMT(businessHours.Id,dt, 1000 * 60 * 60 * hours);
            }
        }
    }
}