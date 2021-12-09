global with sharing class MemberCommunicationData {
    
    public static String notesAPI;
    
    public string BlobText {
        get {
            string tempurl= ApexPages.currentPage().getParameters().get('aburl');
            if(tempurl != null){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(tempurl);
                req.setTimeout(60000);
                req.setMethod('GET');
                req.setClientCertificateName('salesforce');
                HttpResponse res = h.send(req);
                if (res.getStatusCode() == 200) { 
                    system.debug('--res--'+res);
                    blob image = res.getBodyAsBlob();
                    system.debug('--image--'+image);
                    return EncodingUtil.Base64Encode(image);
                }
                else{
                    return null;
                }
            }
            return null;
        }
    }
    
    /*  @AuraEnabled
public static List<SNAIL_Setting__c> SNAILSetting() {
return [select Name,Hidden__c from SNAIL_Setting__c order by Order__c];
}*/
    
    @AuraEnabled
    public static Map<string, object> SNAILSetting() {
        
        Map<string, object> result = new Map<string, object>();
        List<SNAIL_Setting__c> settinglist = [select Name,Hidden__c from SNAIL_Setting__c order by Order__c];
        result.put('SnailSetting', settinglist);
        Boolean IsUserInGroup;
        Group grp = [SELECT DeveloperName,Email,Id,Name,RelatedId,Type FROM Group where DeveloperName ='OOW_Query' Limit 1];
        
        GroupMember[] gm  = [SELECT GroupId,Id,UserOrGroupId FROM GroupMember where GroupId =: grp.id and UserOrGroupId =: UserInfo.getUserId() ];
        
        if(gm.size() > 0)
        {
            IsUserInGroup = true;
        }
        else 
        {
            IsUserInGroup = false;
        }
        
        result.put('UserStatus', IsUserInGroup);
        
        
        return result;
    }
    
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetMemberCommData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';        
        List<Account_Details__c> recordid = [select id,Name,Brand__c from Account_Details__c where id =: recid limit 1]; 
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        list<string> lstrecid = new list<string>();
        
        if(recordid.size() > 0){ 
            system.debug('----------'+recordid);
            string strurl = SNAIL_Remote_Setting__c.getValues('BDIWebService').url__c;
            //string strurl = SNAIL_Remote_Setting__c.getValues('BDIProductionWebService').url__c;
            //https://sf.businessdatainc.com
            if(recordid[0].Brand__c == 'Spectrum'){
                //apiURL = strurl+'/Spectrum/rest/documents/'+recordid[0].name+'?admin=0';
                apiURL =  strurl + '/Spectrum/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
            }else{
                //apiURL = strurl+'/ChevronFCU/rest/documents/'+recordid[0].name+'?admin=0';
                if(strurl.contains('dev')){
                    apiURL =  strurl + '/ChevronFCU/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
                }
                else{
                    apiURL =  strurl + '/Chevron/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
                }
            }
            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setClientCertificateName('salesforce');
            String str=keyword+'%';
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) { 
                JSONParser parser = JSON.createParser(response.getBody());
                string temp;
                
                
                while (parser.nextToken() != null) {
                    
                    if(parser.getText() == 'desc') {
                        parser.nextToken();
                        
                        temp=parser.getText();
                    }
                    
                    if (parser.getText() == 'documents' && temp == 'Notices') {
                        parser.nextToken() ;
                        while (parser.nextToken() != null && parser.getText() !='exigent') {
                            
                            documents doc = (documents)parser.readValueAs(documents.class);
                            
                            if(doc != null){
                                doc.DataSource='BDI';
                                doc.Account=doc.Userid.leftPad(10,'0');
                                //doc.hyperlinkPDF='/apex/MemberCommunicationPDF?url='+doc.hyperlinkPDF;
                                //doc.dateDesc=temp;
                                //doc.documentDateText = doc.documentDate.format() + ' 00:00';
                                if(keyword == 'Date Range'){
                                    if( fromdate != null && todate == null && fromdate <= doc.documentDate  )
                                        results.add(doc);
                                    else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate &&fromdate < todate   )
                                        results.add(doc);
                                    
                                }
                                else{
                                    date d =system.today()-Integer.ValueOf(keyword);
                                    
                                    if( doc.documentDate >= d)
                                        results.add(doc);
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            else{
                return null; 
            }
        }
        
        else{
            
            for(Person_Account__c pa :[SELECT Id,Account_Number__c,Account_Number__r.Name,Account_Number__r.Brand__c FROM Person_Account__c where PersonID__c =: recid]){
                system.debug('------paccount------------'+PA);
                string strurl =SNAIL_Remote_Setting__c.getValues('BDIWebService').url__c;
                //string strProdurl = SNAIL_Remote_Setting__c.getValues('BDIProductionWebService').url__c;
                if(pa.Account_Number__r.Brand__c == 'Spectrum'){
                    //apiURL = strurl+'/Spectrum/rest/documents/'+pa.Account_Number__r.Name+'?admin=0';
                    apiURL =  strurl + '/Spectrum/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                }else{
                    //apiURL = strurl+'/ChevronFCU/rest/documents/'+pa.Account_Number__r.Name+'?admin=0';
                    if(strurl.contains('dev')){
                        apiURL =  strurl + '/ChevronFCU/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                    }
                    else{
                        apiURL =  strurl + '/Chevron/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                    }
                    
                }
                system.debug('----------apiurl--------'+apiURL);
                Http http = new Http(); 
                HttpRequest request = new HttpRequest();
                request.setEndpoint(apiURL);
                request.setMethod('GET');
                request.setClientCertificateName('salesforce');
                String str=keyword+'%';
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) { 
                    JSONParser parser = JSON.createParser(response.getBody());
                    string temp;
                    system.debug('---JSONParser---------------'+Parser);	
                    
                    while (parser.nextToken() != null) {
                        
                        if(parser.getText() == 'desc') {
                            parser.nextToken();
                            
                            temp=parser.getText();
                        }
                        
                        if (parser.getText() == 'documents'&& temp == 'Notices') {
                            parser.nextToken() ;
                            while (parser.nextToken() != null && parser.getText() !='exigent') {
                                
                                documents doc = (documents)parser.readValueAs(documents.class);
                                
                                if(doc != null){
                                    doc.DataSource='BDI';
                                    doc.Account=doc.Userid.leftPad(10,'0');
                                    //doc.documentDateText = doc.documentDate.format() + ' 00:00';
                                    string templink = doc.hyperlinkPDF;
                                    doc.hyperlinkPDF='/apex/MemberCommunicationPDF?aburl='+ EncodingUtil.urlEncode(templink, 'UTF-8');
                                    
                                    if(keyword == 'Date Range'){
                                        if( fromdate != null && todate == null && fromdate <= doc.documentDate  )
                                            
                                            results.add(doc);
                                        else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate &&fromdate < todate   )
                                            results.add(doc);
                                        
                                    }
                                    else{
                                        date d =system.today()-Integer.ValueOf(keyword);
                                        
                                        if( doc.documentDate >= d)
                                            results.add(doc);
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
                else{
                    return null; 
                }
            }
        }
        return results;
        //return new List<MemberCommunicationData.ToDoEnt>(); //'[{id: 1,userId: 3,title:"Education",completed: false},{id: 2,userId: 4,title: "Electronics",completed: true}]';
    }
    /*   @AuraEnabled
public static List<MemberCommunicationData.documents> GetAllMemberCommData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
{   

List<String> lstSource = source;//source.split(',');
String apiURL='';        
Account_Details__c recordid = [select id,Name,Brand__c from Account_Details__c where id =: recid limit 1];  
List<Person_Account__c> lstpa =[SELECT Id,PersonID__r.Name, TypeTranslate__c FROM Person_Account__c where Account_Number__c =: recid and TypeTranslate__c like '0000/Primary'];      
system.debug('----------'+recordid);
List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
if(recordid.Brand__c == 'Spectrum'){
apiURL = 'https://dev2ssl.businessdatainc.com/Spectrum/rest/documents/'+recordid.name+'?admin=0';
}else{
apiURL = 'https://dev2ssl.businessdatainc.com/ChevronFCU/rest/documents/'+recordid.name+'?admin=0';
}
Http http = new Http(); 
HttpRequest request = new HttpRequest();
request.setEndpoint(apiURL);
request.setMethod('GET');
request.setClientCertificateName('salesforce');
String str=keyword+'%';
HttpResponse response = http.send(request);
if (response.getStatusCode() == 200) { 
JSONParser parser = JSON.createParser(response.getBody());
string temp;


while (parser.nextToken() != null) {

if(parser.getText() == 'desc') {
parser.nextToken();

temp=parser.getText();
}

if (parser.getText() == 'documents') {
parser.nextToken() ;
while (parser.nextToken() != null && parser.getText() !='exigent') {

documents doc = (documents)parser.readValueAs(documents.class);

if(doc != null){
doc.DataSource='BDI';
doc.Account='00000'+doc.Userid;
doc.dateDesc=temp;
if(lstpa != null){
doc.userID = lstpa[0].PersonID__r.Name;	

}
if(keyword == null){
if( fromdate != null && todate == null && fromdate <= doc.documentDate  )
results.add(doc);
else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate &&fromdate < todate   )
results.add(doc);
else if(fromdate == null && todate == null  )
results.add(doc);
}
else{
if( fromdate != null && todate == null && fromdate <= doc.documentDate && doc.dateDesc.contains(keyword))
results.add(doc);
else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate && fromdate < todate && doc.dateDesc.contains(keyword) )
results.add(doc);
else if(fromdate == null && todate == null  && doc.dateDesc.contains(keyword))
results.add(doc);
}
}

}
}
}
}
else{
return null; 
}

return results;
//return new List<MemberCommunicationData.ToDoEnt>(); //'[{id: 1,userId: 3,title:"Education",completed: false},{id: 2,userId: 4,title: "Electronics",completed: true}]';
}*/
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetBDICommData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        String apiURL='';        
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        list<string> lstrecid = new list<string>();
        for(Person_Account__c pa :[SELECT Id,Account_Number__c,Account_Number__r.Name,Account_Number__r.Brand__c FROM Person_Account__c where PersonID__c =: recid]){
            system.debug('------paccount------------'+PA);
            if(pa.Account_Number__r.Brand__c == 'Spectrum'){
                apiURL = 'https://dev2ssl.businessdatainc.com/Spectrum/rest/documents/'+pa.Account_Number__r.Name+'?admin=0';
            }else{
                apiURL = 'https://dev2ssl.businessdatainc.com/ChevronFCU/rest/documents/'+pa.Account_Number__r.Name+'?admin=0';
            }
            system.debug('----------apiurl--------'+apiURL);
            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiURL);
            request.setMethod('GET');
            request.setClientCertificateName('salesforce');
            String str=keyword+'%';
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) { 
                JSONParser parser = JSON.createParser(response.getBody());
                string temp;
                system.debug('---JSONParser---------------'+Parser);	
                
                while (parser.nextToken() != null) {
                    
                    if(parser.getText() == 'desc') {
                        parser.nextToken();
                        
                        temp=parser.getText();
                    }
                    
                    if (parser.getText() == 'documents') {
                        parser.nextToken() ;
                        while (parser.nextToken() != null && parser.getText() !='exigent') {
                            
                            documents doc = (documents)parser.readValueAs(documents.class);
                            
                            if(doc != null){
                                doc.DataSource='BDI';
                                doc.Account=doc.Userid.leftPad(10,'0');
                                //doc.dateDesc=temp;
                                if(keyword == 'Date Range'){
                                    if( fromdate != null && todate == null && fromdate <= doc.documentDate  )
                                        results.add(doc);
                                    else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate &&fromdate < todate   )
                                        results.add(doc);
                                    
                                }
                                else{
                                    date d =system.today()-Integer.ValueOf(keyword);
                                    
                                    if( doc.documentDate >= d)
                                        results.add(doc);
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            else{
                return null; 
            }
        }
        return results;
        //return new List<MemberCommunicationData.ToDoEnt>(); //'[{id: 1,userId: 3,title:"Education",completed: false},{id: 2,userId: 4,title: "Electronics",completed: true}]';
    }

    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetBDIestatements(List<string> source,Date fromdate,Date todate,string recid,string keyword){
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';        
        List<Account_Details__c> recordid = [select id,Name,Brand__c from Account_Details__c where id =: recid limit 1]; 
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        Boolean isDup;
        list<string> lstrecid = new list<string>();
        
        if(recordid.size() > 0){ 
            system.debug('----------'+recordid);
            string strurl = SNAIL_Remote_Setting__c.getValues('BDIWebService').url__c;
           // string strurl = SNAIL_Remote_Setting__c.getValues('BDIProductionWebService').url__c;
            if(recordid[0].Brand__c == 'Spectrum'){
                apiURL = strurl+'/Spectrum/rest/documents/'+recordid[0].name+'?admin=0';
            }else{
                if(strurl.contains('dev')){
                    apiURL = strurl+'/ChevronFCU/rest/documents/'+recordid[0].name+'?admin=0';
                }
                else{
                     apiURL = strurl+'/Chevron/rest/documents/'+recordid[0].name+'?admin=0';
                }
            }

            if(recordid[0].Brand__c == 'Spectrum'){
                //apiURL = 'https://sf.businessdatainc.com/Spectrum/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
                apiURL =  strurl + '/Spectrum/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
            }
            else{
                //apiURL = 'https://sf.businessdatainc.com/ChevronFCU/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
                if(strurl.contains('dev')){
                    apiURL =  strurl + '/ChevronFCU/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
                }
                else{
                    apiURL =  strurl + '/Chevron/rest/documents/'+recordid[0].name+'?admin=0&typeID=acctID';
                }
                
            }

            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setClientCertificateName('salesforce');
            String str=keyword+'%';
            String responseBody;
            if(!Test.isRunningTest()){ 
                HttpResponse response = http.send(request);
                responseBody = response.getBody();
            }
            else{
                responseBody = '[{"Monthly Statement":{"desc":"Monthly Statement","documents":[{"Userid":"147163","MDUserID":"147163","acctID":"147163","dateDesc":"Aug 31, 2021","documentDate":"2021-08-31","exigent":false,"hyperlinkPDF":"www.google.com"}]}}]';
            }

            if(responseBody != null) { 
                JSONParser parser = JSON.createParser(responseBody);
                string temp;
                
                
                while (parser.nextToken() != null) {
                    
                    if(parser.getText() == 'desc') {
                        parser.nextToken();
                        
                        temp=parser.getText();
                    }
                    
                    if (parser.getText() == 'documents' && temp != 'Notices') {
                        parser.nextToken() ;
                        while (parser.nextToken() != null && parser.getText() !='exigent') {
                            
                            documents doc = (documents)parser.readValueAs(documents.class);
                            
                            if(doc != null){
                                doc.DataSource='BDI';
                                doc.Account=doc.Userid.leftPad(10,'0');
                                //doc.hyperlinkPDF='/apex/MemberCommunicationPDF?url='+doc.hyperlinkPDF;
                                //doc.dateDesc=temp;
                                //doc.documentDateText = doc.documentDate.format() + ' 00:00';
                                if(keyword == 'Date Range'){
                                    if( fromdate != null && todate == null && fromdate <= doc.documentDate  )
                                        results.add(doc);
                                    else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate &&fromdate < todate   )
                                        results.add(doc);
                                    
                                }
                                else{
                                    date d =system.today()-Integer.ValueOf(keyword);
                                    
                                    if( doc.documentDate >= d)
                                        results.add(doc);
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
            else{
                return null; 
            }
        }
        else{
            
            for(Person_Account__c pa :[SELECT Id,Account_Number__c,Account_Number__r.Name,Account_Number__r.Brand__c FROM Person_Account__c where PersonID__c =: recid]){
                system.debug('------paccount------------'+PA);
                string strurl =SNAIL_Remote_Setting__c.getValues('BDIWebService').url__c;
               // string strurl = SNAIL_Remote_Setting__c.getValues('BDIProductionWebService').url__c;
                if(pa.Account_Number__r.Brand__c == 'Spectrum'){
                    //apiURL = 'https://sf.businessdatainc.com/Spectrum/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                    apiURL =  strurl + '/Spectrum/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                }
                else{
                    //apiURL = 'https://sf.businessdatainc.com/ChevronFCU/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                    if(strurl.contains('dev')){
                        apiURL =  strurl + '/ChevronFCU/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                    }
                    else{
                        apiURL =  strurl + '/Chevron/rest/documents/'+pa.Account_Number__r.Name+'?admin=0&typeID=acctID';
                    }
                    
                }

                system.debug('----------apiurl--------'+apiURL);
                Http http = new Http(); 
                HttpRequest request = new HttpRequest();
                request.setEndpoint(apiURL);
                request.setMethod('GET');
                request.setClientCertificateName('salesforce');
                String str=keyword+'%';
                String responseBody;
                if(!Test.isRunningTest()){ 
                    HttpResponse response = http.send(request);
                    responseBody = response.getBody();
                }
                else{
                    responseBody = '[{"Monthly Statement":{"desc":"Monthly Statement","documents":[{"Userid":"147163","MDUserID":"147163","acctID":"147163","dateDesc":"Aug 31, 2021","documentDate":"2021-08-31","exigent":false,"hyperlinkPDF":"www.google.com"}]}}]';
                }

                system.debug(responseBody);
                if(responseBody != null) { 
                    JSONParser parser = JSON.createParser(responseBody);
                    string temp;
                    system.debug('---JSONParser---------------'+Parser);	
                    
                    while (parser.nextToken() != null) {
                        
                        if(parser.getText() == 'desc') {
                     
                            parser.nextToken();
                            temp=parser.getText();
                        }
                        
                        if (parser.getText() == 'documents' && temp != 'Notices'){
							system.debug('Documents');
                            parser.nextToken() ;
                            while (parser.nextToken() != null && parser.getText() !='exigent') {
                                
                                documents doc = (documents)parser.readValueAs(documents.class);
                                if(doc != null){
                                    doc.DataSource= temp;
                                    doc.Account=doc.Userid.leftPad(10,'0');
                                    //doc.documentDateText = doc.documentDate.format() + ' 00:00';
                                    string templink = doc.hyperlinkPDF;
                                    
                                    doc.hyperlinkPDF='/apex/MemberCommunicationPDF?aburl='+ EncodingUtil.urlEncode(templink, 'UTF-8');
                                    
                                    if(keyword == 'Date Range'){
                                        if( fromdate != null && todate == null && fromdate <= doc.documentDate  )
                                            
                                            results.add(doc);
                                        else if(fromdate != null && todate != null  && fromdate <= doc.documentDate && todate >= doc.documentDate &&fromdate < todate   ){
                                            if(results.size() > 0){
                                                for(MemberCommunicationData.documents md : results){
                                                   
                                                    if(md.Account != doc.Account || md.documentDate != doc.documentDate){
                                                        isDup = false;                                                        
                                                    }
                                                    if(md.Account == doc.Account && md.documentDate == doc.documentDate){
                                                        isDup = true;                                                        
                                                    }
                                                    
                                                }
                                                if(isDup == false){
                                                    results.add(doc);
                                                }
                                            }
                                            else{
                                                results.add(doc);
                                            }

                                            
                                        }
                                        
                                    }
                                    else{
                                        date d =system.today()-Integer.ValueOf(keyword);
                                        
                                        if(doc.documentDate >= d){
                                        
                                            if(results.size() > 0){
                                                for(MemberCommunicationData.documents md : results){
                                                    
                                                    system.debug('md.Account: '+md.Account);
                                                    system.debug('doc.Account: '+doc.Account);
                                                    system.debug('md.documentDate: '+md.documentDate);
                                                    system.debug('doc.documentDate: '+doc.documentDate);

                                                    if(md.Account != doc.Account || md.documentDate != doc.documentDate){
                                                        isDup = false;                                                        
                                                    }
                                                    if(md.Account == doc.Account && md.documentDate == doc.documentDate){
                                                        isDup = true;
                                                        break;                                                        
                                                    }
                                                }
                                                system.debug('isDup: '+isDup);
                                                if(isDup == false){
                                                    results.add(doc);
                                                }
                                            }
                                            else{
                                                results.add(doc);
                                            }

                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
                else{
                    system.debug('Else');
                    return null; 
                }
            }
        }
        return results;
    }

    @AuraEnabled  
    public static List<String> processSelectedEstatements(List<documents> doclist, string recordId){  
        
        system.debug('recordId: '+recordId);
        system.debug('Docs: '+doclist);
        
        String Firstname, Lastname;
        List<String> acids = new List<String>();
        Set<String> memberNumberList = new Set<String>();
        List<Attachment> attachmentsToCreate = new List<Attachment>();
        List<Attachment> attachmentsToCreate2 = new List<Attachment>();
        List<Case> caseToCreate = new List<Case>();
        Map<String,Person_Account__c> pmap = new Map<String,Person_Account__c>();        
        Map<String,user> userMap = new Map<String,user>();
        Map<String, Case> mapCase = new Map<String, Case>();
        List<Member_Comment__c> mcToCreate = new List<Member_Comment__c>();

        RecordType recTpe = [Select Id, Name from RecordType where Name='Portal' Limit 1];
        Account acc = [select id,name from Account where id =:recordId];
        
        List<string> Names=acc.name.split(' ');
        if(Names.size() == 2){
            firstname = Names[0]+ '%';
            lastname= '%'+Names[1] + '%';
        }
        else if(Names.size() >= 3){
            firstname = Names[0]+ '%';
            lastname= '%'+Names[Names.size()-1] +'%';
        }

        System.debug('Firstname: '+Firstname);
        System.debug('LastName: '+LastName);

        User u = [select id,firstname,lastname from user where profile.name = 'Messaging center Customers' and 
                                                firstname like: Firstname and lastname like: LastName limit 1]; 

        for(documents d : doclist){ 
            memberNumberList.add(d.Account);            
        }
        System.debug('memberNumberList: '+memberNumberList);

        For(Person_Account__c p1 : [select id,account_number__c,PersonID__c,PersonID__r.firstname,
                                    PersonID__r.LastName, Account_number__r.name from Person_Account__c
                                    where account_number__r.name In :memberNumberList and TypeTranslate__c='0000/Primary']){
            pmap.put(p1.Account_number__r.name, p1);

            /*for(User u : [select id,firstname,lastname from user where profile.name = 'Messaging center Customers' and 
                            firstname like: p1.PersonID__r.firstname and lastname like: p1.PersonID__r.LastName order by lastmodifieddate desc limit 1]){
                                
                userMap.put(p1.Account_number__r.name,u);
            }*/
        }

        system.debug('pmap: '+pmap);
        //system.debug('userMap: '+userMap);
        
        //--------------------------------------------Create Attachment ------------------------------------//

        for(documents d : doclist){ 
           
            system.debug('Link2: '+d.hyperlinkPDF);
            Blob body;
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res;
            PageReference ref = new PageReference(d.hyperlinkPDF);
            string tempurl= ref.getParameters().get('aburl');
            
            system.debug('tempurl:'+tempurl);
            if(tempurl != null){
               
                req.setEndpoint(tempurl);
                req.setTimeout(60000);
                req.setMethod('GET');
                req.setClientCertificateName('salesforce');
                if(!Test.isRunningTest()){
                    res = h.send(req);
                    
                    if (res.getBody() != null) {                     
                        body = res.getBodyAsBlob();                                       
                    } 
                }
                else{
                    body = Blob.valueOf('Test');
                }
                               
            }
           
            Attachment attach = new Attachment(); 
            attach.Name = d.dateDesc + '.pdf'; 
            attach.Body = body;
            attach.IsPrivate = false;
            attach.ParentId = recordId;
            attach.CreatedByID = u.id;
            attach.Description = d.Account;
            attachmentsToCreate.add(attach);
                
        }

        if(attachmentsToCreate.size() > 0){
            insert attachmentsToCreate;
        }

        

        //--------------------------------------------Create Case -----------------------------------------//

        /*for(String s : memberNumberList){

            Case ca = new Case();
            ca.Subject = 'eStatement Request';
            //ca.Description = ;
            ca.Account_Number__c = pmap.get(s).account_number__c;
            ca.AccountID = pmap.get(s).PersonID__c;
            ca.Primary_Category__c = 'Account Servicing';
            ca.Origin = 'Portal';
            ca.Status = 'Open';
            //ca.IsMarkRead__c = true; 
            ca.RecordTypeId = recTpe.id;
            ca.CreatedByID =  u.id;    
            caseToCreate.add(ca);
        }

        if(caseToCreate.size() > 0){
            insert caseToCreate;
        }

        For(Case c : [select id,Account_Number__r.name,Account_Number__c from case where id in :caseToCreate]){
            mapCase.put(c.Account_Number__r.name,c);
        }

        system.debug('mapCase: '+mapCase);

        //--------------------------------------------Clone Attachments and deleting previous ones-------------------------------//

        system.debug('attachmentsToCreate: '+attachmentsToCreate);

        For(Attachment a : attachmentsToCreate){
           
            Attachment a1 = new Attachment();
            a1.Name = a.name;
            a1.Body = a.body;
            a1.IsPrivate = false;
            a1.ParentId = mapCase.get(a.Description).id;
            a1.CreatedByID = u.id;
            a1.Description = a.Description;
            
            attachmentsToCreate2.add(a1);
        }

        if(attachmentsToCreate2.size() > 0){
            insert attachmentsToCreate2;
        }
        
        if(attachmentsToCreate.size() > 0){
            delete attachmentsToCreate;
        }

        For(Case c: [select id,Account_Number__r.name,AccountID,Account_Number__c from case where id in :caseToCreate]){

            system.debug(pmap.get(c.Account_Number__r.name).PersonID__c);
            system.debug(c.AccountId);

            if(recordId != c.AccountID){
                Member_Comment__c mb = new Member_Comment__c();
                mb.Member_Communication__c = 'eStatements';
                mb.Case__c = c.id;
                mcToCreate.add(mb);
            }
        }

        if(mcToCreate.size()>0){
            insert mcToCreate;
        }*/
        
        List<String> URLlist = new List<String>();

        for(Attachment attach : attachmentsToCreate){            
            String url = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file=' + attach.Id;
            URLlist.add(url);           
        }        

        system.debug('URLlist: '+URLlist);
        
        return URLlist;
    }


    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetSalesforceData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';
        
        List<Account_Details__c> recordid = [select id,Name from Account_Details__c where id =: recid limit 1];
        
        system.debug('----------'+recordid);
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        String str='%'+keyword+'%';
        
        List<Authenticated_Log__c> al = new List<Authenticated_Log__c>();
        if( fromdate != null && todate == null && keyword == 'Date Range')
            al = [select id,name,createdDate,Brand__c from Authenticated_Log__c where   createdDate  >= :fromdate ];
        else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
            al = [select id,name,createdDate,Brand__c from Authenticated_Log__c where  createdDate  >= :fromdate and createdDate  <= :todate];
        else if(fromdate == null && todate == null && keyword == null)
            al = [select id,name,createdDate,Brand__c from Authenticated_Log__c];
        else if( keyword != 'Date Range'){
            Date d = System.today() - Integer.ValueOf(keyword);
            al = [select id,name,createdDate,Brand__c from Authenticated_Log__c where createdDate >= :d];
        }
        for(Authenticated_Log__c ld : al ){
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.id= ld.id;               
            doc.dateDesc=ld.name;
            doc.documentDate=Date.valueOf(ld.createdDate);
            //doc.documentDateText = doc.documentDate.format() + ' 00:00';
            doc.userID =ld.Brand__c;
            doc.DataSource='Salesforce';
            results.add(doc);
        }
        
        system.debug('--------'+results.size());
        return results;
    }
    
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetOOWData(Date fromdate,Date todate,string keyword, string recid)
    {
        system.debug('recid###'+ recid);   
        system.debug('fromdate##' + fromdate);
        system.debug('todate##' + todate);
        //  string strfromdate =  string.valueof(fromdate).replace(' ','T') +  '.000+0000';
        //  string strtodate = string.valueof(todate).replace(' ','T') +  '.000+0000';
        //    system.debug('fromdate##' + strfromdate);
        //   system.debug('todate##' + strtodate);
        
        RecordType rec = [select Id,Name,SobjectType from RecordType where Name ='OOW Execution Log' and SobjectType='Authenticated_Log__c'];
        Id CurrentUserId = UserInfo.getUserId();
        
        //--------------------------------------------------------------------------------------------------------//
        set<String> accList = new set<String>();
        set<string> typeList = new set<string>();
        
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);	
        }
        
        list<Person_Account__c> paList = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                          FROM Person_Account__c where PersonID__c =:recid and TypeTranslate__c IN:typeList and Account_Number__r.RecType__c IN('ACCT', 'SHAR') order by  Account_Number__r.RecType__c asc];
        
        for(Person_Account__c p : paList){
            accList.add(p.Account_Number__r.Name);	
        }
        
        //--------------------------------------------------------------------------------------------------------//
        
        /*Person_Account__c p = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
FROM Person_Account__c where PersonID__c =:recid and Account_Number__r.RecType__c IN('ACCT', 'SHAR') order by  Account_Number__r.RecType__c asc  limit 1];
string AccountNumber = p.Account_Number__r.Name; */
        
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        String str='%'+keyword+'%';
        
        List<Authenticated_Log__c> al = new List<Authenticated_Log__c>();
        if( fromdate != null && todate == null && keyword == 'Date Range')
            al = [select id,name,Member_Name__c , RecordTypeId, CreatedById,CreatedDate,Created_Date_PST__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c from Authenticated_Log__c
                  where   createdDate  >= :fromdate and RecordTypeId = :rec.Id and OOW_Member_Number__c IN:accList order by CreatedDate desc ];
        else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
            al = [select id,name, Member_Name__c , RecordTypeId, CreatedById,CreatedDate,Created_Date_PST__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c from Authenticated_Log__c
                  where  ( createdDate  >= :fromdate and createdDate  <= :todate) and  RecordTypeId = :rec.Id and OOW_Member_Number__c IN:accList order by CreatedDate desc ];
        else if(fromdate == null && todate == null && keyword == null)
            al = [select id,name, Member_Name__c , RecordTypeId, CreatedById,CreatedDate,Created_Date_PST__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c from Authenticated_Log__c
                  where RecordTypeId = :rec.Id and OOW_Member_Number__c IN:accList order by CreatedDate desc	];
        else if( keyword != 'Date Range'){
            Date d = System.today() - Integer.ValueOf(keyword);
            al = [select id,name, Member_Name__c , RecordTypeId, CreatedById,CreatedDate,Created_Date_PST__c,OOW_Member_Number__c,OOW_Notes__c,OOW_Reason__c,OOW_Status__c from Authenticated_Log__c
                  where createdDate >= :d and RecordTypeId = :rec.Id and OOW_Member_Number__c IN:accList order by CreatedDate desc] ;
        }
        string baseUrl;
        String prefix = URL.getSalesforceBaseURL().toExternalForm().replace('https://', '').split('\\.')[0];
        prefix = prefix.removeEnd('--c');
        baseUrl = 'https://' + prefix.toLowerCase() + '.lightning.force.com';
        system.debug('https://' + prefix.toLowerCase() + '.lightning.force.com');
        string notes;
        for(Authenticated_Log__c ld : al ){
            system.debug(ld);
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.id= ld.id; 
            if(ld.OOW_Notes__c != null) notes = ld.OOW_Notes__c;
            else notes ='';
            if(ld.OOW_Reason__c !=null)
            {
                doc.dateDesc=ld.OOW_Reason__c + '/' + '('+ ld.OOW_Status__c.capitalize()+ ')' + ' /' + notes ;
            }
            else
            {
                doc.dateDesc=ld.OOW_Reason__c;
            }
            doc.documentDate=Date.valueOf(ld.Created_Date_PST__c);
            //doc.documentDateText = doc.documentDate.format() + ' 00:00';
            doc.Account = ld.OOW_Member_Number__c;
            doc.userID =ld.CreatedById;
            doc.DataSource='OOW';
            doc.hyperlinkPDF = baseUrl + '/lightning/r/Authenticated_Log__c/'  + ld.id + '/view';
            doc.MemberName = ld.Member_Name__c;
            //https://chevronfcu--staging2.lightning.force.com/lightning/r/Authenticated_Log__c/a0S3F000001IfdGUAS/view
            results.add(doc);
        }
        
        system.debug('--------'+results.size());
        return results;
    }
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetMCPingChangeData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';
        set<String> accList = new set<String>();
        set<string> typeList = new set<string>();
        
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);	
        }
        
        list<Person_Account__c> paList = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                          FROM Person_Account__c where PersonID__c =:recid and TypeTranslate__c IN:typeList and Account_Number__r.RecType__c IN('ACCT', 'SHAR') order by  Account_Number__r.RecType__c asc];
        
        for(Person_Account__c p : paList){
            accList.add(p.Account_Number__r.Name);	
        }
        
        system.debug('accList'+accList);
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        String str='%'+keyword+'%';
        
        List<MC_PIN_Change__c> mpc = new List<MC_PIN_Change__c>();
        if( fromdate != null && todate == null && keyword == 'Date Range')
            mpc = [select id,name,Member_Number__c,createdDate from MC_PIN_Change__c where   createdDate  >= :fromdate and Member_Number__c IN:accList ];
        else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
            mpc = [select id,name,Member_Number__c,createdDate from MC_PIN_Change__c where  createdDate  >= :fromdate and createdDate  <= :todate and Member_Number__c IN:accList];
        else if(fromdate == null && todate == null && keyword == null)
            mpc = [select id,name,Member_Number__c,createdDate from MC_PIN_Change__c where Member_Number__c IN:accList];
        else if( keyword != 'Date Range'){
            Date d = System.today() - Integer.ValueOf(keyword);
            mpc = [select id,name,Member_Number__c,createdDate from MC_PIN_Change__c where createdDate >= :d and Member_Number__c IN:accList];
        }
        for(MC_PIN_Change__c mp : mpc ){
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.id= mp.id;               
            doc.dateDesc= 'MC PIN Change - '+mp.name;
            doc.documentDate=Date.valueOf(mp.createdDate);
            //doc.documentDateText = doc.documentDate.format() + ' 00:00';
            //doc.userID =ld.Brand__c;
            doc.DataSource='Salesforce';
            doc.Account= mp.Member_Number__c;
            results.add(doc);
        }
        
        system.debug('--------'+results.size());
        return results;
    }
    
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetMCLimitChangeData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';
        set<String> accList = new set<String>();
        set<string> typeList = new set<string>();
        
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);	
        }
        
        list<Person_Account__c> paList = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                          FROM Person_Account__c where PersonID__c =:recid and TypeTranslate__c IN:typeList and Account_Number__r.RecType__c IN('ACCT', 'SHAR') order by  Account_Number__r.RecType__c asc];
        
        for(Person_Account__c p : paList){
            accList.add(p.Account_Number__r.Name);	
        }
        
        system.debug('accList'+accList);
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        String str='%'+keyword+'%';
        
        List<MC_Limit_Change__c> mlc = new List<MC_Limit_Change__c>();
        if( fromdate != null && todate == null && keyword == 'Date Range')
            mlc = [select id,name,Member_Number__c,createdDate from MC_Limit_Change__c where  createdDate >= :fromdate and Member_Number__c IN:accList ];
        else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
            mlc = [select id,name,Member_Number__c,createdDate from MC_Limit_Change__c where  createdDate  >= :fromdate and createdDate  <= :todate and Member_Number__c IN:accList];
        else if(fromdate == null && todate == null && keyword == null)
            mlc = [select id,name,Member_Number__c,createdDate from MC_Limit_Change__c where Member_Number__c IN:accList];
        else if( keyword != 'Date Range'){
            Date d = System.today() - Integer.ValueOf(keyword);
            mlc = [select id,name,Member_Number__c,createdDate from MC_Limit_Change__c where createdDate >= :d and Member_Number__c IN:accList];
        }
        for(MC_Limit_Change__c ml : mlc ){
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.id= ml.id;               
            doc.dateDesc= 'MC Limit Change - '+ml.name;
            doc.documentDate=Date.valueOf(ml.createdDate);
            //doc.documentDateText = doc.documentDate.format() + ' 00:00';
            //doc.userID =ld.Brand__c;
            doc.DataSource='Salesforce';
            doc.Account= ml.Member_Number__c;
            results.add(doc);
        }
        
        system.debug('--------'+results.size());
        return results;
    }
    
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetWiresData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';
        set<String> accList = new set<String>();
        set<string> typeList = new set<string>();
        
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);	
        }
        
        list<Person_Account__c> paList = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                          FROM Person_Account__c where PersonID__c =:recid and TypeTranslate__c IN:typeList and Account_Number__r.RecType__c IN('ACCT', 'SHAR') order by  Account_Number__r.RecType__c asc];
        
        for(Person_Account__c p : paList){
            accList.add(p.Account_Number__r.Name);	
        }
        
        system.debug('accList'+accList);
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        String str='%'+keyword+'%';
        
        List<WIRES_Transaction__c> wires = new List<WIRES_Transaction__c>();
        if( fromdate != null && todate == null && keyword == 'Date Range')
            wires = [select id,name,FromAccount__c,createdDate,Source__c,Member_Name__c,Case__c from WIRES_Transaction__c where  createdDate >= :fromdate and FromAccount__c IN:accList ];
        else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
            wires = [select id,name,FromAccount__c,createdDate,Source__c,Member_Name__c,Case__c from WIRES_Transaction__c where  createdDate  >= :fromdate and createdDate  <= :todate and FromAccount__c IN:accList];
        else if(fromdate == null && todate == null && keyword == null)
            wires = [select id,name,FromAccount__c,createdDate,Source__c,Member_Name__c,Case__c from WIRES_Transaction__c where FromAccount__c IN:accList];
        else if( keyword != 'Date Range'){
            Date d = System.today() - Integer.ValueOf(keyword);
            wires = [select id,name,FromAccount__c,createdDate,Source__c,Member_Name__c,Case__c from WIRES_Transaction__c where createdDate >= :d and FromAccount__c IN:accList];
        }
        for(WIRES_Transaction__c ml : wires ){
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.id= ml.id;               
            doc.dateDesc= ml.name;
            doc.documentDate=Date.valueOf(ml.createdDate);
            //doc.documentDateText = doc.documentDate.format() + ' 00:00';
            //doc.userID =ld.Brand__c;
            doc.DataSource=ml.Source__c;
            doc.Account= ml.FromAccount__c;
            doc.MemberName=ml.Member_Name__c;
            doc.hyperlinkPDF=URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/r/WIRES_Transaction__c/'+ml.id+'/view';
            if(ml.Case__c!=null){
                doc.caseLinkLabel='Case';
                doc.caseLink=URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/r/Case/'+ml.Case__c+'/view';
            }
            results.add(doc);
        }
        
        system.debug('--------'+results.size());
        return results;
    }
    
    @AuraEnabled
    public static List<MemberCommunicationData.documents> GetNotesData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';
        set<String> accList = new set<String>();
        set<string> typeList = new set<string>();
        List<Object> lstNotes=new List<Object>();
        
        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);  
        }
        
        Person_Account__c paPrimary = [SELECT Id, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, 
                                       Account_Number__r.Name,PersonID__r.PersonID__c,PersonID__r.Name
                                       FROM Person_Account__c 
                                       where PersonID__c =:recid and TypeTranslate__c like '%Primary%' 
                                       order by  Account_Number__r.RecType__c asc LIMIT 1];
        
        string SSN;
        if (paPrimary != null){
            SSN = paPrimary.PersonID__r.PersonID__c.substring(1);
            System.debug('SSN:'+SSN);
        }
        
        MARS_To_Episys_API_Details__c api = MARS_To_Episys_API_Details__c.getValues('ProductionURL');
        if(api.URL__c != null){
            notesAPI = api.URL__c;
            System.debug('notesAPI:'+notesAPI);
        }
        
        httpRequest requestparam = new httpRequest();
        requestparam.setEndpoint(notesAPI + '/MARS/GetNotes?ssn=' + SSN);
        requestparam.setMethod('GET');
        
        try{
            http httpParam = new http();
            HttpResponse response;
            String responseBody1;
            String strStatus, strBody;
            if (!Test.isRunningTest()){
                response = httpParam.send(requestparam);
                strStatus = response.getStatus();
                strBody = response.getBody();
            } else{
                strBody = '[{"Code":"0","EnterDate":"2010-12-20","ExpirationDate":"","Id":"","IdType":"3","Locator":"136","RecordChangeDate":"2010-12-20","Text":"Card Limit Increase Unblocked","AccountNumber":"0000000123","EntryId":1}]';
            }
            
            System.debug('strStatustracking ....' + strStatus);
            System.debug('strBodytracking ....' + strBody);
            
            if (strBody != ''){
                lstNotes = (List<Object>)JSON.deserializeUntyped(strBody);
                
                
                System.debug('Service response is ....' + lstNotes);
            }
        }catch (System.CalloutException e){
            system.debug('Exception');
        }
        
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        List<object> notes = new List<object>();
        
        for(Object note : lstNotes ){
            map<string, object> localNote = (map<string, object>)note;
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.Id= (string)localNote.get('id');               
            doc.dateDesc= (string)localNote.get('Text');
            doc.documentDate=localNote.get('EnterDate')!=null ? date.valueOf(localNote.get('EnterDate').toString()): null;
            doc.DataSource='Symitar';
            doc.Account= (string)localNote.get('AccountNumber');
            doc.MemberName=paPrimary.PersonID__r.Name;
            
            boolean isFound=false;
            if( fromdate != null && todate == null && keyword == 'Date Range')
                isFound=doc.documentDate>= fromdate;
            else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
                isFound=doc.documentDate>= fromdate && doc.documentDate<=todate;
            else if(fromdate == null && todate == null && keyword == null)
                isFound=true;
            else if( keyword != 'Date Range'){
                Date d = System.today() - Integer.ValueOf(keyword);
                isFound=doc.documentDate >= d ;
                
            }
            
            if(isFound==true){
              results.add(doc);
            }
        }
        
        
        system.debug('--------'+results.size());
        return results;
    }

    /*@AuraEnabled
    public static List<MemberCommunicationData.documents> GetWiresEDSData(List<string> source,Date fromdate,Date todate,string recid,string keyword)
    {   
        
        List<String> lstSource = source;//source.split(',');
        String apiURL='';
        set<String> accList = new set<String>();
        set<string> typeList = new set<string>();
        Map<String,String> memberName = new Map<String,String>();
        Map<String,String> memberNameAcc = new Map<String,String>();
        string Firstname, Lastname;

        for(Member360_TypeTranslate__c t : Member360_TypeTranslate__c.getAll().values()){
            typeList.add(t.name);	
        }
        
        list<Person_Account__c> paList = [SELECT Id,PersonId__r.Email_raw__c,PersonId__r.SSN_TIN_Encrypted__pc,PersonId__r.Name, Account_Number__c,  PersonID__c, Account_Number__r.RecType__c, TypeTranslate__c, Account_Number__r.Name
                                          FROM Person_Account__c where PersonID__c =:recid and TypeTranslate__c IN:typeList and Account_Number__r.RecType__c IN('ACCT', 'SHAR') order by  Account_Number__r.RecType__c asc];
        
        for(Person_Account__c p : paList){
            accList.add(p.Account_Number__r.Name);	
            memberName.put(p.PersonId__r.Email_raw__c,p.PersonId__r.Name);            
        }
        
        system.debug('memberName: '+memberName);    
     
        system.debug('accList'+accList);
        List<MemberCommunicationData.documents> results=new List<MemberCommunicationData.documents>();
        String str='%'+keyword+'%';        
		        
        
        List<EDS_Member_Alerts__c> eds = new List<EDS_Member_Alerts__c>();
        if( fromdate != null && todate == null && keyword == 'Date Range')
            eds = [select id,name,Email__c,Odskey__c,Event_ID__c,Account_Number__c,createdDate from EDS_Member_Alerts__c where  createdDate >= :fromdate and Account_Number__c IN:accList ];
        else if(fromdate != null && todate != null  && fromdate < todate && keyword == 'Date Range')
            eds = [select id,name,Email__c,Odskey__c,Event_ID__c,Account_Number__c,createdDate from EDS_Member_Alerts__c where  createdDate  >= :fromdate and createdDate  <= :todate and Account_Number__c IN:accList];
        else if(fromdate == null && todate == null && keyword == null)
            eds = [select id,name,Email__c,Odskey__c,Event_ID__c,Account_Number__c,createdDate from EDS_Member_Alerts__c where Account_Number__c IN:accList];
        else if( keyword != 'Date Range'){
            Date d = System.today() - Integer.ValueOf(keyword);
            eds = [select id,name,Email__c,Odskey__c,Event_ID__c,Account_Number__c,createdDate from EDS_Member_Alerts__c where createdDate >= :d and Account_Number__c IN:accList];
        }
        for(EDS_Member_Alerts__c ml : eds ){
            MemberCommunicationData.documents doc = new MemberCommunicationData.documents();
            doc.id= ml.id;               
            doc.dateDesc= 'Wires Tranaction - ' + ml.Event_ID__c;
            doc.documentDate=Date.valueOf(ml.createdDate);
            //doc.documentDateText = doc.documentDate.format() + ' 00:00';
            //doc.userID =ld.Brand__c;
            doc.DataSource= 'EDS';
            doc.Account = ml.Account_Number__c;
            if(ml.Email__c != null){
                doc.MemberName = memberName.get(ml.Email__c);
            }
            doc.hyperlinkPDF=URL.getSalesforceBaseUrl().toExternalForm()+ '/lightning/r/EDS_Member_Alerts__c/'+ml.id+'/view';
            
            results.add(doc);
        }
        
        system.debug('--------'+results.size());
        return results;
    }*/
    
    @AuraEnabled
	public static String isValidRelationship(string MemberNumber, string SSN){
		
        String IsValid;
        ACH_To_Episys_API_Details__c api = ACH_To_Episys_API_Details__c.getValues('ProductionURL');
        String loanAPI;
        
		if (api.URL__c != null){
			loanAPI = api.URL__c;
		}

		httpRequest requestparam = new httpRequest();
		requestparam.setEndpoint(loanAPI +'/MemberAuthorization/IsValidMemberRelationShip');// + AccountNumber +'&FullNameStringList=' + primaryName +'&FullName=' + SSN);
		requestparam.setMethod('POST');
		requestparam.setHeader('Content-Type', 'application/json');
		requestparam.setHeader('Accept', 'application/json');
		requestparam.setHeader('Content-Length', '162100');
		string jsonData = '{"MemberNumber":' + '\"' + MemberNumber + '\","SSN":' + '\"' + SSN + '\"}';
		requestparam.setBody(jsonData);
		system.debug('jsonData==' + jsonData);
		Http httpParam = new Http();

		requestparam.setTimeout(60000);
		HttpResponse response;
		String responseBody1;
		String strStatus, strBody;
		if (!Test.isRunningTest()){
			response = httpParam.send(requestparam);
			responseBody1 = response.getBody();
			System.debug('Response Body::' + response.getBody());
			strStatus = response.getStatus();
			strBody = response.getBody();
		} else{
		    responseBody1 = '{"IsValid":"true"}';
		}
        if(responseBody1 != '' && responseBody1 != null){        
            Map<String,Object> results = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody1);
            if(results != null){                     
                for(String key : results.keySet()){                   			
                    if(key == 'IsValid'){
                        IsValid = String.valueOf(results.get(key));
                        
                    }
                }
                system.debug('IsValid: '+IsValid);           
            }
        }
        
        return IsValid;
	}
    
    public class CommentsEnt
    {
        public  Integer postId{get;set;}
        public  Integer id{get;set;}
        public  String name{get;set;}
    }
    
    public class PhotosEnt
    {
        public  Integer albumId{get;set;}
        public  Integer id{get;set;}
        public  String url{get;set;}
    }
    
    public  class ToDoEnt
    {
        @AuraEnabled    
        public  Integer userId{get;set;}
        @AuraEnabled
        public  Integer id{get;set;}
        @AuraEnabled
        public  String title{get;set;}
        
        
        
        public ToDoEnt(CommentsEnt objCommentEnt)
        {
            this.userId =objCommentEnt.postId;
            this.id =objCommentEnt.id;
            this.title =objCommentEnt.name;
        }
        
        public ToDoEnt(PhotosEnt objPhotosEnt)
        {
            this.userId =objPhotosEnt.albumId;
            this.id =objPhotosEnt.id;
            this.title =objPhotosEnt.url;
        }
        
    }
    
    public List<documents> lstdoc;
    public class documents{
        @AuraEnabled
        public  string id{get;set;}
        @AuraEnabled
        public string dateDesc{get;set;}
        
        @AuraEnabled
        public  Date documentDate{get;set;}
        @AuraEnabled
        public  string documentDateText{get;set;}
        @AuraEnabled
        public  string DataSource{get;set;}
        @AuraEnabled
        public string hyperlinkPDF{get;set;}
        @AuraEnabled
        public string subCategoryDesc{get;set;} 
        @AuraEnabled
        public string userID{get;set;}
        @AuraEnabled
        public string Account{get;set;}
        @AuraEnabled
        public string MemberName{get;set;}
        @AuraEnabled
        public string caseLink{get;set;}
        @AuraEnabled
        public string caseLinkLabel{get;set;}
        
    }
    
    
}