public class LeadWithCompanyController {

    @AuraEnabled(cacheable=true)
    public static List<Lead> fetchLeads(String lead) {
        String Company;
        Lead led = [SELECT Id,Name,email,phone,company FROM Lead Where Id=:lead];
        Company = led.Company;
        
        List<Lead> LeadList = [select id,firstname,lastname,name,phone,company,email from Lead where id !=:lead and company =:Company];
        return LeadList;
    }
}