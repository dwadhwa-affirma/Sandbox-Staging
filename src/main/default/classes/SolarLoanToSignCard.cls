public class SolarLoanToSignCard {
	
    public List<Solar_loans__c> solarloans{get;set;}
    private ApexPages.StandardSetController standardController;
    public boolean validation {get;set;}
    public boolean morethanone {get;set;}
    public boolean signed {get;set;}
    public boolean notready {get;set;}
    
    public static string Rurl;
	public static String EnvelopeId;
	public static Account Member;
	public static String EmailBody = 'In order for the Credit Union to ensure the solar loan details are accurate, please review and sign the Signature Card form.' +'\n\n' +'If changes are needed or you would like to provide additional payments, please update the form and sign.' +'\n\n' + 'If you have any questions, please contact us at 800-782-8782 ext. 5200.';
	public static String EmailSubject = 'Signature Card';    
	public static String accountID; 
	public static String userId; 
	public static String passWord;
	public static String integratorKey; 
	public static String replyTo;
	public static String templateID;
	public static String endPoint;
	public static String authorizationHeader;      
	public static String endPointURL;
	public static HttpRequest req = new HttpRequest();    
	public static String json;
	public static Http http = new Http();
	public static HTTPResponse res;
	public static String responseBody;
    public static String DocumentName;
	
	public static String endPointURL1;
	public static HttpRequest req1 = new HttpRequest();    
	public static String json1;
	public static Http http1 = new Http();
	public static HTTPResponse res1;
	
	public static String endPointURL2;
	public static HttpRequest req2 = new HttpRequest();    
	public static String json2;
	public static Http http2 = new Http();
	public static HTTPResponse res2;

	
	public static String endPointURL3;
	public static HttpRequest req3 = new HttpRequest();    
	public static String json3;
	public static Http http3 = new Http();
	public static HTTPResponse res3;
    
    public static String endPointURL4;
	public static HttpRequest req4 = new HttpRequest();    
	public static String json4;
	public static Http http4 = new Http();
	public static HTTPResponse res4;
    
    public static String endPointURL5;
	public static HttpRequest req5 = new HttpRequest();    
	public static String json5;
	public static Http http5 = new Http();
	public static HTTPResponse res5;
    public static String responseBody1;

    public static String endPointURL6;
	public static HttpRequest req6 = new HttpRequest();    
	public static String json6;
	public static Http http6 = new Http();
	public static HTTPResponse res6;
	
    public SolarLoanToSignCard(ApexPages.StandardSetController standardController){
        // Returns all selected records
        solarloans = (List<Solar_Loans__c>)standardController.getSelected();
        
        If(solarloans.size() == 0){
            validation = false;
        }
        else If(solarloans.size() > 1){
            validation = true;
            morethanone = false;
        }
        else if(solarloans.size() == 1){
        	List<Solar_Loans__c> SolarLoanToProcess = [select id,name,Name__c,Member_number__c,Current_Solar_Loan_Stage__c,
                                                       Count__c,Signed__c from Solar_loans__c where id in :solarloans];    
		  List<SolarLoan_Document__c> sd = [select id,Attachment_Id__c	,name,Solar_Loans__r.id,Solar_Loans__c from SolarLoan_Document__c where Solar_Loans__r.id in: SolarLoanToProcess and Document_Name__c LIKE '%Membership Application%' order by createddate desc LIMIT 1];
            
            System.debug('SolarLoan Doc: '+sd.size());
            system.debug(SolarLoanToProcess[0].Signed__c);
            
            system.debug('Number: '+SolarLoanToProcess[0].Member_number__c);
            system.debug('Name: '+SolarLoanToProcess[0].Name__c);
            system.debug('Docs: '+SolarLoanToProcess[0].Count__c);
            system.debug('Stage: '+SolarLoanToProcess[0].Current_Solar_Loan_Stage__c);
            
            if(SolarLoanToProcess[0].Signed__c == true){
                validation = true;
                morethanone = true;
                signed = false;    
            }
            else if(sd.size() == 0 || SolarLoanToProcess[0].Member_number__c == null || SolarLoanToProcess[0].Name__c == null || 
                    SolarLoanToProcess[0].Count__c == '0' || 
                    (SolarLoanToProcess[0].Current_Solar_Loan_Stage__c != 'Stage 2.5')){

                validation = true;
                morethanone = true;
                signed = true;
                notready = false;       
            }
            else{
                validation = true;
				morethanone = true;
            	signed = true;
            	notready = true;
            }            
        }    
        else{
			validation = true;
			morethanone = true;
            signed = true;
            notready = true;
        }
        
        this.standardController = standardController;
        system.debug('tttt'+solarloans);
        system.debug('validation'+validation);
        system.debug('morethanone'+morethanone);
    }
    
    
    //public static void SignCard(Set<ID> ids){   
    public PageReference ExecuteSignatureMethod(){
    	
        //----------------------------Start - DocuSign Templates from Custom setting---------------------------------//
        
        SetCustomFieldFalse();

        List<Solar_Loans__c> selectedsolar = (List<Solar_Loans__c>)standardController.getSelected();
        
        Set<Id> ids = new set<Id>();
        For(Solar_Loans__c sl : selectedsolar){
            ids.add(sl.id);
        }
        system.debug('ids: '+ids);
		
        return SolarLoanToSignCardHelper.ExecuteSignatureMethod(ids);   
    }

    @future(callout=true)
    public static void SetCustomFieldTrue(){

        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        String FieldId;

        templateID = DTSpectrum.TemplateId__c;
        replyTo = DTSpectrum.ReplyTo__c;
        accountID = DTSpectrum.AccountId__c;
        userId = DTSpectrum.Username__c;
        passWord = DTSpectrum.Password__c;
        integratorKey = DTSpectrum.IntegratorKey__c;
        endpoint = DTSpectrum.EndPoint__c;

        if(endpoint == 'www.docusign.net'){
            FieldId = '4845275';
        }
        else{
            FieldId = '145104';
        }

        authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

        //--------------------------------------------------------------Custom field-------------------------------------------------//

        endPointURL6 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/custom_fields/'+FieldId;
        req6.setEndpoint(endPointURL6); 
        req6.setMethod('PUT'); 
        req6.setTimeout(120000);
        req6.setHeader('X-DocuSign-Authentication', authorizationHeader); 
        req6.setHeader('Accept','application/json'); 
        req6.setHeader('Content-Type','application/json'); 
        
        json6 = '{"name": "Member Number",'+'"required":"true",'+'"show":"true"'+'}';
  
        req6.setBody(json6); 
        if(!Test.isRunningTest()){
            res6 = http6.send(req6);
            system.debug('DocuSign Response'+ res6.getBody());
        }

    }

    public static void SetCustomFieldFalse(){

        DocuSign_User_Details__c DTSpectrum = DocuSign_User_Details__c.getValues('Spectrum');
        String FieldId;

        templateID = DTSpectrum.TemplateId__c;
        replyTo = DTSpectrum.ReplyTo__c;
        accountID = DTSpectrum.AccountId__c;
        userId = DTSpectrum.Username__c;
        passWord = DTSpectrum.Password__c;
        integratorKey = DTSpectrum.IntegratorKey__c;
        endpoint = DTSpectrum.EndPoint__c;

        if(endpoint == 'www.docusign.net'){
            FieldId = '4845275';
        }
        else{
            FieldId = '145104';
        }

        authorizationHeader = '<DocuSignCredentials><Username>'+userId+'</Username><Password>'+Password+'</Password><IntegratorKey>'+integratorKey+'</IntegratorKey></DocuSignCredentials>';

        //--------------------------------------------------------------Update Custom field-------------------------------------------------//

        endPointURL6 = 'https://'+endpoint+'/restapi/v2.1/accounts/'+accountID+'/custom_fields/'+FieldId;
        req6.setEndpoint(endPointURL6); 
        req6.setMethod('PUT'); 
        req6.setTimeout(120000);
        req6.setHeader('X-DocuSign-Authentication', authorizationHeader); 
        req6.setHeader('Accept','application/json'); 
        req6.setHeader('Content-Type','application/json'); 
        
        json6 = '{"name": "Member Number",'+'"required":"false",'+'"show":"false"'+'}';
    
        req6.setBody(json6); 
        if(!Test.isRunningTest()){
            res6 = http6.send(req6);
            system.debug('DocuSign Response'+ res6.getBody());
        }

    }	
}