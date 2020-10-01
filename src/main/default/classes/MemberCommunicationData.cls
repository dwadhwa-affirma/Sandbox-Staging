global with sharing class MemberCommunicationData {
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
            if(recordid[0].Brand__c == 'Spectrum'){
                apiURL = strurl+'/Spectrum/rest/documents/'+recordid[0].name+'?admin=0';
            }else{
                apiURL = strurl+'/ChevronFCU/rest/documents/'+recordid[0].name+'?admin=0';
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
                    
                    if (parser.getText() == 'documents') {
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
                if(pa.Account_Number__r.Brand__c == 'Spectrum'){
                    apiURL = strurl+'/Spectrum/rest/documents/'+pa.Account_Number__r.Name+'?admin=0';
                }else{
                    apiURL = strurl+'/ChevronFCU/rest/documents/'+pa.Account_Number__r.Name+'?admin=0';
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
        
    }
    
    
}