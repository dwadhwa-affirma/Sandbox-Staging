global  class DisplayCaseController {
        
        public String typeparam {get;set;}
        public string SortBy {get;set;}
        public string SortDirection{get;set;}
        public Id caseid {get;set;}
        //public static Id membercaseid {get;set;}
        public  static List<Message> afterSort = new List<Message>();
        public static integer mini = 0;

        //public string primaryCategory{get; set;}
        public string ImgName {get;set;}
        public string MemberType {get;set;}
        public string UserName {get;set;}
        public string Stylesheet{get;set;}
        public string CopyRights{get;set;}
        public string Brand_Help {get;set;}
         public string Extension {get;set;}
         public string SD {get;set;}
         public string Responsivecss {get;set;}
         public static string latestCommmentBySupportidd {get;set;}
         
         
         
        // constructor
        public DisplayCaseController() 
        {
            
            
        }
    

     public PageReference  PageLoad()
        {
            
                /* common code starts */
        CFCUAccount userAccount = new CFCUAccount();
        List <SecureEmailSetting__c> ses = SecureEmailSetting__c.getall().values();
        Extension = ses[0].List_of_Allowed_Extensions__c;
        userAccount.personAccount = new Person_Account__c();
        string LoggedinUser = UserInfo.getUserId();
        List<User> u1 = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        userAccount.CurrentUser = u1[0];
        userAccount.fedid = u1[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u1[0].ContactId];
             
        if (c.size()>0)
         {
            userAccount.userBusinessContact = c[0];
         }
            
        userAccount.fedid =  userAccount.Get10DigitFid(userAccount.fedid);
        List<Person_Account__c> personaccounts =  [SELECT Account_Number__c,Id,Name, PersonID__c FROM Person_Account__c Where Name_Type__c = 0 and Account_Number__r.Name =:userAccount.fedid];
            
            
         if(personaccounts.size()>0)
         {
             userAccount.personAccount = personaccounts[0];
             userAccount.AccountId = userAccount.personaccount.PersonID__c;
             userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
         }
            
        List <Account_Details__c> ad = [Select Brand__c FROM Account_Details__c Where ID = :userAccount.AccountNumber];
        if(ad.size()>0)
        {
            userAccount.Brand = ad[0].Brand__c;
        }
                
        System.Debug('UserAccount:-' + userAccount);
        
        
        
        /* common code ends */
            
            UserName = userAccount.CurrentUser.Name;        
            caseid = ApexPages.CurrentPage().getparameters().get('id');
            typeparam = ApexPages.CurrentPage().getparameters().get('Type');
            SortBy = ApexPages.CurrentPage().getparameters().get('SB');
            SD = ApexPages.CurrentPage().getparameters().get('SD');
            
            if(userAccount.Brand == 'Chevron')
            {
                ImgName ='logoorig.png';
                Stylesheet= 'message1.css';
                CopyRights ='Chevron Federal Credit Union. All Rights Reserved';
                MemberType = 'CFCU Member Support';
                Brand_Help = ses[0].Chevron_KB__c;
                Responsivecss ='Responsive_Chevron.css';
            }
            else
            {
                ImgName = 'spectrum_logo.jpg';
                Stylesheet= 'message1_spectrum.css';
                CopyRights ='Spectrum Credit Union. All Rights Reserved';
                MemberType = 'Spectrum Member Support';
                Brand_Help = ses[0].Spectrum_KB__c;
                Responsivecss ='Responsive_Spectrum.css';
            }
            
            if(SortBy == 'Primary_Category__c')
            {SortBy = 'Category';}
            SortDirection = ApexPages.CurrentPage().getparameters().get('SD');
           
            return null;
            
        }
        
@TestVisible private static string Get10DigitFid(string fedid)
{
            Integer  l = fedid.length();
            
            if (l <10)
            {
                Integer  zerotoadd = 10-l;
                string prepend='';
                for (Integer  i=0; i<zerotoadd; i++)
                {
                    prepend = '0' + prepend;
                    
                }
                
                fedid = prepend + fedid;
            }
            
            return fedid;
}
        
@TestVisible private static List<Message> GetAllMessagesforUser(string TypeOfView, string SortBy, string SortDirection, id currentCaseId)
    {

                /* common code starts */
        
        CFCUAccount userAccount = new CFCUAccount();
        
        userAccount.personAccount = new Person_Account__c();
        string LoggedinUser = UserInfo.getUserId();
        List<User> u1 = [SELECT Name, ContactId, FederationIdentifier from User Where ID=:LoggedinUser];
        userAccount.CurrentUser = u1[0];
        userAccount.fedid = u1[0].FederationIdentifier;
        List<contact> c = [SELECT AccountId, FirstName, MiddleName, LastName FROM Contact WHERE Id =:u1[0].ContactId];
             
        if (c.size()>0)
         {
            userAccount.userBusinessContact = c[0];
         }
            
        userAccount.fedid =  userAccount.Get10DigitFid(userAccount.fedid);
        List<Person_Account__c> personaccounts =  [SELECT Account_Number__c,Id,Name, PersonID__c FROM Person_Account__c Where Name_Type__c = 0 and Account_Number__r.Name =:userAccount.fedid];
            
            
         if(personaccounts.size()>0)
         {
             userAccount.personAccount = personaccounts[0];
             userAccount.AccountId = userAccount.personaccount.PersonID__c;
             userAccount.AccountNumber = userAccount.personaccount.Account_Number__c;
         }
            
        List <Account_Details__c> ad = [Select Brand__c FROM Account_Details__c Where ID = :userAccount.AccountNumber];
        if(ad.size()>0)
        {
            userAccount.Brand = ad[0].Brand__c;
        }
                
        System.Debug('UserAccount:-' + userAccount);
        /* common code ends */

        DateTime date18months = DateTime.now().addMonths(-18);
        DateTime date5Years = DateTime.now().AddMonths(-60);
            integer i =0;
            Case[] caseIds = null;
            List<Case> cases = null;
            List<Member_Comment__c> comments = null;
            List<Member_Comment__c> commentdate = null;
            List<Member_Comment__c> CommentsbySupport = null;
            List<Case> casesCreatedBySupport = null;
            List<Id> parentcaseId = new List<Id>();
            string  LatestCommentbySupport = null;
            
               caseIds = [SELECT Id from Case where Account_Number__r.Name =:userAccount.fedid and CreatedDate > LAST_N_MONTHS:18];
               commentdate =[Select CreatedDate from Member_Comment__c where  Case__c IN :caseIds order by CreatedDate limit 1 ];   
        
            if (TypeOfView == 'Messages')
            {                       
                casesCreatedBySupport =[SELECT Id, Days_after_closed_date__c,CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
                        createdbyId from Case where Account_Number__r.Name =:userAccount.fedid 
                        and ((createdbyId !=: LoggedinUser and MemberCommentCount__c > 0) or (createdbyId =: LoggedInUser))
                        and IsMarkDeleted__c = false and IsMarkSaved__c = false  and CreatedDate >= :date18months];
                        
            for( i =0 ; i < casesCreatedBySupport.size(); i ++)
            {
                parentcaseId.Add(casesCreatedBySupport[i].Id);
            }
            CommentsbySupport = [SELECT Case__r.Id, CreatedDate,Id, Member_Communication__c, Name, IsRead__c FROM Member_Comment__c Where CreatedById !=:LoggedinUser and case__r.Account_Number__r.Name =:userAccount.fedid order by CreatedDate desc];
            
            if(CommentsbySupport.size()>0)
            {
                
                for(i=0; i < CommentsbySupport.size(); i ++)
                {
                    parentcaseId.Add(CommentsbySupport[i].Case__r.Id);
                }
            }
            cases = [SELECT Id, Days_after_closed_date__c,CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,IsMarkRead__c,contactid,
                        createdbyId from Case where Id IN:parentcaseId and IsMarkDeleted__c = false and IsMarkSaved__c = false and CreatedDate >= :date18months];
                
            comments =[SELECT Case__r.Id, CreatedDate,Id, Member_Communication__c, Name,CreatedById, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc];

        }
            if(TypeOfView == 'DeletedMessages')
            {
                cases =[SELECT Id,Days_after_closed_date__c, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,CreatedById,IsMarkRead__c from Case 
                            where IsMarkDeleted__c = true and IsMarkSaved__c = false and Account_Number__r.Name =:userAccount.fedid and CreatedDate > :date18months
                            and ((MemberCommentCount__c > 0 and createdbyId !=: LoggedinUser) or ( createdbyId =: LoggedinUser))];
                if(cases.size() > 0)
                {                           
                    for( i =0 ; i < cases.size(); i ++)
                    {
                        parentcaseId.Add(cases[i].Id);
                    }
                    comments =[SELECT Case__r.Id, CreatedDate,Id, Member_Communication__c, Name,CreatedById, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc ];       
                  //    comments = [Select CommentBody, ParentId, CreatedDate,CreatedById from CaseComment where  parentId IN :parentcaseId ];  
                }           
            }
            
           if(TypeOfView == 'SavedMessages')
            {
                cases =[SELECT Id, Days_after_closed_date__c,CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,CreatedById,IsMarkRead__c from Case
                         where IsMarkSaved__c = true and Account_Number__r.Name =:userAccount.fedid and  IsMarkDeleted__c= false  and CreatedDate > :date5Years
                         and ((MemberCommentCount__c > 0 and createdbyId !=: LoggedinUser) or ( createdbyId =: LoggedinUser))];
                for( i =0 ; i < cases.size(); i ++)
                {
                    
                    parentcaseId.Add(cases[i].Id);
                }   
                
                comments =[SELECT Case__r.Id, CreatedDate,Id, Member_Communication__c, Name,CreatedById, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc ];   
             //     comments = [Select CommentBody, ParentId, CreatedDate,CreatedById from CaseComment where  parentId IN :parentcaseId ];              
            }
            if(TypeOfView == 'SentMessages')
            {
                cases =[SELECT Id,Days_after_closed_date__c, CaseNumber,Primary_Category__c,Description,Priority,Status,Subject,CreatedDate,CreatedById,IsMarkRead__c from Case 
                            where Account_Number__r.Name =:userAccount.fedid  and IsMarkSaved__c = false and createdbyId =:LoggedinUser and IsMarkDeleted__c= false];
                for(i =0 ; i < cases.size(); i ++)
                {
                    parentcaseId.Add(cases[i].Id);
                }
                comments =[SELECT Case__r.Id, CreatedDate,Id, Member_Communication__c, Name,CreatedById, IsRead__c FROM Member_Comment__c Where Case__r.Id IN : parentcaseId and draft__c != true order by CreatedDate desc ];       
              //    comments = [Select CommentBody, ParentId, CreatedDate,CreatedById from CaseComment where  parentId IN :parentcaseId ];              
            }
            string shortdesc ='';
            List<Message> messages = new List<Message>();
            List<Attachment> attachments;
            if(cases.size()>0)
             {
                // 3/31 only show attachments added by member
                if(Test.isRunningTest()){
                    attachments = [Select Id,Name,BodyLength, ParentId from Attachment Where ParentId in :parentcaseId];
                }
                else{
                     attachments  = [Select Id,Name,BodyLength, ParentId from Attachment Where ParentId in :parentcaseId and  createdby.Profile.UserLicense.LicenseDefinitionKey !='SFDC'];
                
                System.debug('attachments=' + attachments);
                }
                for( i =0 ; i< cases.size(); i++ )
                {
                    List<FileList> filelists = new List<FileList>();
                    Message message = new Message();
                    
                    message.casenumber = cases[i].CaseNumber; 
                    message.Days_after_closed_date = (Integer)cases[i].Days_after_closed_date__c;
                
                    message.PrimaryCategory = cases[i].Primary_Category__c;
                    message.Description = cases[i].Description;
                    system.debug('cases[i].CaseNumber' + cases[i].CaseNumber);
                    
                    if(cases[i].Description != null && cases[i].Description!='')
                    {
                        message.Description = cases[i].Description;
                        message.ShortDescription = cases[i].Description;
                    }
                    else
                    {
                        message.Description ='';
                        message.ShortDescription='';
                    }
                //  message.ShortDescription = cases[i].Description;
                    
                    message.Priority = cases[i].Priority;
                    message.Status = cases[i].Status;
                    if(cases[i].Subject != null && cases[i].Subject!='')
                    {
                        message.Subject = cases[i].Subject;
                    }
                    else
                    {
                        message.Subject ='';
                    }
                    
                    message.CreatedDate = cases[i].CreatedDate;
                    message.CaseCreatedDate=cases[i].CreatedDate;
                                       
                    message.Id = cases[i].Id;
                    
                    integer z = 0;
                    for (z = 0; z < comments.size(); z++)
                    {
                        if (cases[i].Id == comments[z].Case__c)
                        {   
                            System.Debug('cases[i].Id' + cases[i].Id );
                            System.Debug('comments[j].Case__c' + comments[z].Case__c );             
                            //message.Description = comments[j].Member_Comment__c;
                            message.CreatedDate = comments[z].CreatedDate;
                            message.ExpiresDate = comments[z].CreatedDate.addMonths(18);
                            if (comments[z].IsRead__c == false)
                            {
                                message.IsMarkRead  = false;            
                            }
                            break;
                        }
                    }
                    
                    message.CreatedById = cases[i].CreatedById;
                    
                    if (currentcaseid == cases[i].Id)
                    {
                       message.LatestCommentBySupport = LoadLatestCommentBySupport(cases[i].Id);
                       string latestCommmentBySupportid= GetLatestCommentBySupportId(cases[i].Id);
                       system.debug('latestid...' + latestCommmentBySupportid);
                       message.LatestCommentfiles = GetLatestSupportAttachment(latestCommmentBySupportid);
                       //latestCommmentBySupportidd = latestCommmentBySupportid;
                    }
                    else
                    {
                        message.LatestCommentBySupport = '';
                    
                    }
                    if(message.LatestCommentBySupport== null || message.LatestCommentBySupport == '')
                    {
                        message.LatestCommentBySupport = message.Description;
                        message.ShowCaseBelow = false;
                    }
                    else
                    {
                        message.ShowCaseBelow = true;
                    }
                    integer j = 0;
                    if (attachments != null)
                    {
                        for(j=0; j< attachments.size(); j++ )
                        {
                            if (cases[i].Id == attachments[j].parentId)
                            {
                                FileList fl = new FileList();
                                fl.filename = attachments[j].Name;
                                fl.downloadurl = 'servlet/servlet.FileDownload?file=' + attachments[j].id ;
                                string ext = '';
                                try
                                { 
                                    ext = attachments[j].Name.split('\\.')[1];
                                }
                                catch (Exception ex)
                                {
                                
                                }
                                ext = ext.toLowerCase();
			                    if(ext == 'doc' || ext == 'docx'){
			                    	ext = 'word';
			                    }
			                    else if(ext == 'xls' || ext == 'xlsx'){
			                    	ext = 'excel';
			                    }
			                    else if(ext == 'ppt' || ext == 'ppts'){
			                    	ext = 'powerpoint';
			                    }
			                     else if(ext == 'jpg' || ext == 'jpeg' || ext == 'png'|| ext == 'bmp'){
			                    	ext = 'jpg';
			                    }
			                    else if(ext == 'one'){
			                    	ext = 'onenote';
			                    }
			                    
			                   
                                fl.fileicon = ext;
                                string displaysize;
                                    
                                if(attachments[j].BodyLength < 1000)
                                {
                                    displaySize = attachments[j].BodyLength + ' Bytes';
                                    //displaySize = attachments[j].BodyLength + 'KB';
                                    System.debug('displaySize1=='+ displaySize);
                                }                               
                                else if(attachments[j].BodyLength > 1000 && attachments[j].BodyLength < 1000000)
                                {
                                    displaySize = Math.floor(attachments[j].BodyLength/1000) + ' KB';
                                    //displaySize = attachments[j].BodyLength + 'KB';
                                    System.debug('displaySize1=='+ displaySize);
                                }
                                else
                                {
                                    displaySize  = Math.round((attachments[j].BodyLength / 1000000)*10)/10 + ' MB';
                                    //displaySize  = (attachments[j].BodyLength)/100 + 'MB';
                                     System.debug('displaySize2=='+ displaySize);
                                }
                                
                                    fl.filesize = displaySize;
                                     System.debug('fl.filesize=='+ fl.filesize);
                                    filelists.add(fl);
                            }
                        }
                    }
                    message.files = filelists;
                
                    messages.Add(message);
                }
                
            }
            
            if(messages.size() > 0)
            {       
                List<Message> sortdata = DisplayCaseController.SortMessages(messages, SortBy, SortDirection);
                return sortdata;
            }
            else
            {
                return messages;
            }
            
            
            
            
    }
    global static List<FileList> GetLatestSupportAttachment(string messageid)
    {
    	List<attachment> attachments = [Select Id,Name,BodyLength, ParentId from Attachment Where ParentId  =: messageId];
    	List<FileList> filelists = new List<FileList>();
    	FileList fl = new FileList();
    	integer j =0 ;
    	system.debug('att ...' + attachments.size()); 
    	         if (attachments != null)
                    {
                        for( j=0; j< attachments.size(); j++ ) 
                        {
                        	system.debug('compare...' + messageid + '...' + attachments[j].id);
                            if (messageid == attachments[j].parentId)
                            
                            {
                                
                                fl.filename = attachments[j].Name;
                                fl.downloadurl = 'servlet/servlet.FileDownload?file=' + attachments[j].id ;
                                string ext = '';
                                try
                                { 
                                    ext = attachments[j].Name.split('\\.')[1];
                                }
                                catch (Exception ex)
                                {
                                
                                }
                                ext = ext.toLowerCase();
			                    if(ext == 'doc' || ext == 'docx'){
			                    	ext = 'word';
			                    }
			                    else if(ext == 'xls' || ext == 'xlsx'){
			                    	ext = 'excel';
			                    }
			                    else if(ext == 'ppt' || ext == 'ppts'){
			                    	ext = 'powerpoint';
			                    }
			                     else if(ext == 'jpg' || ext == 'jpeg' || ext == 'png'|| ext == 'bmp'){
			                    	ext = 'jpg';
			                    }
			                    else if(ext == 'one'){
			                    	ext = 'onenote';
			                    }
			                    
			                   
                                fl.fileicon = ext;
                                string displaysize;
                                    
                                if(attachments[j].BodyLength < 1000)
                                {
                                    displaySize = attachments[j].BodyLength + ' Bytes';
                                    //displaySize = attachments[j].BodyLength + 'KB';
                                    System.debug('displaySize1=='+ displaySize);
                                }                               
                                else if(attachments[j].BodyLength > 1000 && attachments[j].BodyLength < 1000000)
                                {
                                    displaySize = Math.floor(attachments[j].BodyLength/1000) + ' KB';
                                    //displaySize = attachments[j].BodyLength + 'KB';
                                    System.debug('displaySize1=='+ displaySize);
                                }
                                else
                                {
                                    displaySize  = Math.round((attachments[j].BodyLength / 1000000)*10)/10 + ' MB';
                                    //displaySize  = (attachments[j].BodyLength)/100 + 'MB';
                                     System.debug('displaySize2=='+ displaySize);
                                }
                                
                                    fl.filesize = displaySize;
                                     System.debug('fl.filesize=='+ fl.filesize);
                                    filelists.add(fl);
                            }
                        }
                    }
                    
    	return filelists;
    }
        @RemoteAction
    global static List<Member_Comment__c> GetCaseComment(string caseid)
    {
        List<Member_Comment__c> casecommentdata = [SELECT Case__r.Id,ID, Member_Communication__c, CreatedById,CreatedDate FROM Member_Comment__c Where Case__r.Id =: caseid and draft__c != true order by CreatedDate Desc];
        system.debug('casecommentdata=======' + casecommentdata);
        return  casecommentdata;
        
    }
    
        @RemoteAction
         global static String LoadLatestCommentBySupport(string caseid)
         {
            string LatestcommentBySupport = null;
            string LoggedinUserID = UserInfo.getUserId();
            List<Member_Comment__c> casecommentdata = [SELECT Case__r.Id,ID, Member_Communication__c, CreatedById,CreatedDate FROM Member_Comment__c Where Case__r.Id =: caseid and draft__c != true and  CreatedById !=: LoggedinUserID order by CreatedDate Desc  Limit 1];
            if(casecommentdata.Size()> 0)
            {
                LatestcommentBySupport = casecommentdata[0].Member_Communication__c;
                System.debug(LatestcommentBySupport);
            	latestCommmentBySupportidd = casecommentData[0].id;    
                
            }
            return  LatestcommentBySupport;
        
        }
        
        
         global static String GetLatestCommentBySupportId(string caseId)
         {
            string LoggedinUserID = UserInfo.getUserId();
            string MessageId = '';
            List<Member_Comment__c> casecommentdata = [SELECT Case__r.Id,ID, Member_Communication__c, CreatedById,CreatedDate FROM Member_Comment__c Where Case__r.Id =: caseid and draft__c != true and  CreatedById !=: LoggedinUserID order by CreatedDate Desc  Limit 1];
            if(casecommentdata.Size()> 0)
            {
                MessageId = casecommentdata[0].Id;
            }
            
        	return MessageId;
        }
    
    @RemoteAction
    global static Message LoadCase(string TypeOfView, string SortBy, string SortDirection, string id)
    {
        Message m = null; 
        integer i = 0;
        List<Message> sortdata =  GetAllMessagesforUser(TypeOfView, SortBy,SortDirection, id);
        System.Debug(sortdata);
        if (sortdata.size() > 0)
            {
                if (id == null || id == '')
                {
                    id = sortdata[0].Id;
                }
                for(i =0 ; i< sortdata.Size(); i ++)
                {   
                    System.Debug(i);
                    System.Debug(id);   
                    if(id == (string)sortdata[i].Id)
                    {   
                        m = sortdata[i];
                            
                        break;
                    }
                }
            }
            System.Debug(i);    
            if((i == sortdata.Size()-1) || (sortdata.Size()==1) )
            {
                m.shownext = false;
            }
            else
            {
                system.debug(m);
                m.shownext = true;
            }
            system.debug('91');
            if(sortdata.Size()==1 || i ==0)
            {
                m.showprev = false;
            }
            else
            {
                m.showprev = true;
            }
            system.debug('92');
            
            m = setModelView(m, sortdata, i, TypeOfView);
            
            System.Debug(m);    
            return m;
        
    }
    @RemoteAction
    global static MemberMessageView LoadMemberComments(string id)
    {
        integer i;
        integer j;
        List<Member_Comment__c> comments =  GetCaseComment(id);
    
        
        Set<Id> membercommentId = new Set<Id>();
        List<MemberComment> membercommentlist = new List<MemberComment>();
            
        if(comments != null || !(comments.isEmpty()))
        {
            for(Member_Comment__c c : comments)
            {
                membercommentId.add(c.Id);
            }
            
            
            List<Attachment> attachments = [Select Id,Name,BodyLength, ParentId from Attachment Where ParentId in :membercommentId];
            
            
            for( i =0 ;i < comments.size(); i++)
            {
            	system.debug('comments.size()========'+ comments.size());
                List<FileList> filelists = new List<FileList>();
                MemberComment mc = new MemberComment();
                mc.CreatedById  = comments[i].CreatedById;
                mc.CreatedDate = comments[i].CreatedDate;
                if(comments[i].Member_Communication__c != null || comments[i].Member_Communication__c != '' || !String.isEmpty(comments[i].Member_Communication__c))
                {
                	//string shortdesc ='';
                	//shortdesc = comments[i].Member_Communication__c;
                	
                    //mc.ShortComment = comments[i].Member_Comment__c.abbreviate(150);
                    mc.ShortComment = comments[i].Member_Communication__c;
                  //	mc.ShortComment = shortdesc.abbreviate(150);
                    mc.FullComment = comments[i].Member_Communication__c;
                }
                else
                {
                    mc.ShortComment ='';
                    mc.FullComment = '';
                }
                if (attachments != null)
                {
                    for(j=0; j< attachments.size(); j++ )
                    {
                        if (comments[i].Id == attachments[j].parentId)
                        {
                            FileList fl = new FileList();
                            fl.filename = attachments[j].Name;
                            fl.downloadurl = 'servlet/servlet.FileDownload?file=' + attachments[j].id ;
                            string ext = attachments[j].Name.split('\\.')[1];
                            ext = ext.toLowerCase();
			                    if(ext == 'doc' || ext == 'docx'){
			                    	ext = 'word';
			                    }
			                    else if(ext == 'xls' || ext == 'xlsx'){
			                    	ext = 'excel';
			                    }
			                    else if(ext == 'ppt' || ext == 'ppts'){
			                    	ext = 'powerpoint';
			                    }
			                     else if(ext == 'jpg' || ext == 'jpeg' || ext == 'png'|| ext == 'bmp'){
			                    	ext = 'jpg';
			                    }
			                    else if(ext == 'one'){
			                    	ext = 'onenote';
			                    }
                            fl.fileicon = ext;
                            string displaysize;
                            
                            if(attachments[j].BodyLength < 1000)
                            {
                                displaySize = attachments[j].BodyLength + ' Bytes';
                                System.debug('displaySize1=='+ displaySize);
                            }                               
                            else if(attachments[j].BodyLength > 1000 && attachments[j].BodyLength < 1000000)
                            {
                                displaySize = Math.floor(attachments[j].BodyLength/1000) + ' KB';
                                System.debug('displaySize1=='+ displaySize);
                            }
                            else
                            {
                                displaySize  = Math.round((attachments[j].BodyLength / 1000000)*10)/10 + ' MB';
                                 System.debug('displaySize2=='+ displaySize);
                            }
                            
                            /*if(attachments[j].BodyLength < 100)
                            {
                                displaySize = attachments[j].BodyLength + 'KB';
                                System.debug('displaySize1=='+ displaySize);
                            }
                            else
                            {
                                displaySize  = (attachments[j].BodyLength)/100 + 'MB';
                                 System.debug('displaySize2=='+ displaySize);
                            }*/
                            
                                fl.filesize = displaySize;
                                 System.debug('fl.filesize=='+ fl.filesize);
                                filelists.add(fl);
                        }
                    }
                }
                mc.files = filelists;
                
                membercommentlist.add(mc);
                system.debug('mc===========' + mc);
                 system.debug('membercommentlist===========' + mc);
            }
            
        }
        MemberMessageView mv = new MemberMessageView();
        system.debug('membercommentlistoutside===========' + membercommentlist);
        mv.membermessage = membercommentlist;
        System.Debug('MessageView====' + mv);
        return mv;
    }
    
     @RemoteAction
    global static Message LoadNextCase(string TypeOfView, string SortBy, string SortDirection, string id)
    {
            Message m = null;
            integer i = 0; 
            
            List<Message> sortdata =  GetAllMessagesforUser(TypeOfView, SortBy,SortDirection, id);
            system.debug(sortdata);
            if (sortdata.size() > 0)
            {
             if (id == null || id == '')
                {
                    id = sortdata[0].Id;
                }
                for(i =0 ; i< sortdata.Size(); i ++)
                {   
                    
                    if(id == (string)sortdata[i].Id)
                    {   
                        if(sortdata.size() < 2)
                        {
                            m.shownext = false;
                            m.showprev = false;
                            m = sortdata[i];
                        }
                        else if(sortdata.size() >=2 )
                        {
                            if(i==0)
                            {
                                System.Debug('i==' + i);
                                System.Debug('i==' + i + 'SortData=' + sortdata[i+1] );
                                
                                m = sortdata[i+1];
                                m.shownext = true;
                                m.showprev = true;
                                System.Debug('m===' + m );
                                
                                System.Debug('i==' + i + 'SortData=' + sortdata[i+1] );
                            }
                            if(i == 1 && sortdata.size()==2 )
                            {
                                m = sortdata[i];
                                m.shownext = false;
                                m.showprev = true;
                                System.Debug('i==' + i + 'SortData=' + sortdata[i] );
                                
                            }
                             if(i >= 1 && sortdata.size() > 2 )
                            {
                                
                                System.Debug('i>1===' + i);
                                if(i== sortdata.size()-1)
                                {
                                    m = sortdata[i];
                                 
                                    m.shownext = false;
                                    m.showprev = true;
                                }
                                else if (i== sortdata.size() - 2)
                                {
                                    m = sortdata[i+1];
                                    m.shownext = false;
                                    m.showprev = true;        
                                }
                                else
                                {
                                    m = sortdata[i+1];
                                    System.debug('heh-' + m);
                                    m.shownext = true;
                                    m.showprev = true;
                                }
                                System.Debug('sortdata.size()=' + sortdata.size());
                            }
                        }
                        break;
                    }
                }
            }
            System.Debug('I==' + i);
            m = setModelView(m, sortdata,i, TypeOfView);
            System.Debug('M====' + m);
            return m;
    }
     @RemoteAction
    global static Message LoadPreviousCase(string TypeOfView, string SortBy, string SortDirection, string id)
    {       
            Message m = null;
            integer i = 0; 
            List<Message> sortdata =  GetAllMessagesforUser(TypeOfView, SortBy,SortDirection, id);
            if (sortdata.size() > 0)
            {
                
                if (id == null || id == '')
                {
                    
                    id = sortdata[0].Id;
                    
                }
                
                for(i =0 ; i< sortdata.Size(); i ++)
                {   
                    Message message = new Message();
                    if(id == (string)sortdata[i].Id)
                    {
                        if(sortdata.size() == 1)
                        {
                            m.shownext = false;
                            m.showprev = false;
                            m = sortdata[i];
                        }
                        else
                        {
                            if(i==0)
                            {
                                System.Debug('i==' + i);
                                System.Debug('i==' + i + 'SortData=' + sortdata[i] );
                                
                                m = sortdata[i];
                                m.shownext = true;
                                m.showprev = false;
                                System.Debug('m===' + m );
                                
                                System.Debug('i==' + i + 'SortData=' + sortdata[i] );
                            }
                            else if (i == 1)
                            {
                                m = sortdata[i-1];
                                m.shownext = true;
                                m.showprev = false;
                                System.Debug('i==' + i + 'SortData=' + sortdata[i-1] );
                                
                            }
                            else if(i == sortdata.size() -1)
                            {
                                
                                m = sortdata[i-1];
                                m.shownext = true;
                                m.showprev = true;
                                System.Debug('i==' + i + 'SortData=' + sortdata[i-1] );
                                
                            }
                            else
                            {
                                System.Debug('i>1===' + i);
                                m = sortdata[i-1];
                                m.shownext = true;
                                m.showprev = true;
                            }
                        }
                        break;
                    }
                    
                }
            }
            
            
            m = setModelView(m, sortdata,i, TypeOfView);
            
            return m;
    }
    private static Message setModelView(Message m, List<Message> sortdata, integer i, string TypeOfView)
    {
            if(TypeOfView=='Messages')
            {
                m.BackToView = 'Back to Inbox';
                m.SaveLink ='Save Message';
                m.DeleteLink ='Delete';
                
            }
            else if(TypeOfView=='DeletedMessages')
            {   
                m.BackToView = 'Back to Deleted';
                m.SaveLink ='Save Message';
                m.DeleteLink ='';
                
            }
            
            else if(TypeOfView=='SavedMessages')
            { 
                m.BackToView = 'Back to Saved';
                m.SaveLink ='';
                m.DeleteLink ='Delete';
                
            }
            else 
            {                   
                m.BackToView = 'Back to Sent';
                m.SaveLink ='Save Message';
                m.DeleteLink ='Delete';
            }
            
            List<Case> casedata =[SELECT ID,Days_after_closed_date__c,CaseNumber,Category__c,Primary_Category__c,Description,Priority,Status,Subject,IsMarkDeleted__c,IsMarkSaved__c from Case where Id = : m.Id ];
            m.IsMarkDeleted = casedata[0].IsMarkDeleted__c;
            m.IsMarkSaved = casedata[0].IsMarkSaved__c;
            
            if(m.IsMarkDeleted == true && ((TypeOfView=='Messages') || (TypeOfView =='SavedMessages')|| (TypeOfView =='SentMessages')  ))
            {
                m.DeleteLink ='Deleted';
            }
            else if(m.IsMarkDeleted == true && TypeOfView=='DeletedMessages')
            {
                m.DeleteLink ='';
            }
            else
            {
                m.DeleteLink='Delete';
            }
            
            if(m.IsMarkSaved == true && ((TypeOfView=='Messages') || (TypeOfView =='DeletedMessages')|| (TypeOfView =='SentMessages')  ))
            {
                m.SaveLink ='Saved';
            }
            else if(m.IsMarkSaved == true && TypeOfView=='SavedMessages')
            {
                m.SaveLink ='';
            }
            else 
            {
                m.SaveLink ='Save Message';
            }
            
            return m;
    }
    private static List<Message> SortMessages(Message[] messages, string SortBy, string SortDirection )
    {
        if( messages.size() > 0)
        {
            integer targetsize = messages.size();
            System.Debug (targetsize + '-' + afterSort.size());
              while(afterSort.size() != targetsize)
                {
                      System.Debug (messages.size() + '-' + afterSort.size());
                      DisplayCaseController.findMinDateValue(SortBy,SortDirection,messages);
                      
                }
           return  afterSort;       
        }
        else
        {
            return messages;
        }
          
        
    }
      private static void findMinDateValue(string SB, string SD,Message[] messages )
      {
        
            List<string> cat = new List<string>();
            if(SD == 'Desc' && SB == 'CreatedDate')
            {
                 datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); 
                
                 for (integer i = 0; i != messages.size() ; i ++)
                 {
                    if(messages[i].CreatedDate > dt)
                        { 
                                dt = messages[i].CreatedDate;
                                mini = i;
                          }
                 }
            }
            else if(SD == 'Asc' && SB == 'CreatedDate')
            {
                datetime dt = Datetime.newInstance(2999, 12, 31, 00, 00, 00);
                
                for (integer i = 0; i != messages.size() ; i ++){
                          if(messages[i].CreatedDate < dt)
                          { 
                         
                                dt = messages[i].CreatedDate;
                                mini = i;
                          }
                    }
                
            }
            else if(SD == 'Desc' && SB == 'Category')
            {
                
                String dt ='a';
                for (integer i = 0; i != messages.size() ; i ++)
                 {
                    if(messages[i].PrimaryCategory > dt)
                        { 
                                dt = messages[i].PrimaryCategory;
                                mini = i;
                        }
                 }
            }
            else
            {
                String dt ='z';
                for (integer i = 0; i != messages.size() ; i ++)
                 {
                    if(messages[i].PrimaryCategory < dt)
                        { 
                                dt = messages[i].PrimaryCategory;
                                mini = i;
                        }
                 } 
                 
                            
            }
                        
            system.debug(messages);
            system.debug(mini);
            afterSort.add(messages[mini]);
            
            messages.remove(mini);
        
        
      }
    
    @RemoteAction   
    global static Id ButtonReply_Click(string id, string comment, string DeviceType )
        {
            Case c = [Select AccountId, CreatedBy.Email from Case where Id =: id];
            System.Debug(c);
            Account a = [select PersonEmail from account where id =: c.AccountId];
            Id membercaseid;
            Member_Comment__c membercomment = new Member_Comment__c();
            membercomment.Member_Communication__c = comment;
            membercomment.Case__c = id;
            membercomment.IsRead__c = true;
            membercomment.Device_Type__c = DeviceType;
            membercomment.draft__c = false;
            if (a.PersonEmail != null)
            {
                membercomment.Member_Email__c = a.PersonEmail;
            }
            membercomment.Case_Creator_Email__c = c.CreatedBy.Email;
            
                insert membercomment;
            
 
            comment ='';
            membercaseid = membercomment.Id;
            System.debug('membercaseid===' + membercaseid);
            return membercaseid;
            
        }   
    
    @RemoteAction
    global static void ButtonSave_Click(string caseid)
    {
        
        List<Case> cdata = [SELECT ID,IsMarkSaved__c from case where Id =:caseid];
        if(cdata.size()> 0)
        {
            for(Case cas:cdata)
            {
                cas.IsMarkSaved__c = true;
                cas.IsMarkDeleted__c = false;
                update cas;
            }
        }
        
    }
    @RemoteAction
    global static void ButtonDelete_Click(string caseid)
    {       
        List<Case> cdata = [SELECT ID,IsMarkDeleted__c from case where Id =:caseid];
        for(Case cas:cdata)
        {
            cas.IsMarkDeleted__c = true;
            cas.IsMarkSaved__c = false;
            update cas;
        }
        
                    
    }
    
    
    @RemoteAction
   
    
    global static List<Attachment> GetAttachment(string membercommentid)
    {
        List<Attachment> attachments = [Select Id,Name,BodyLength from Attachment Where ParentId =:membercommentid];
        return attachments;
        
    
    }  
    
     @RemoteAction
    global static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue)
    {
        /*
        parentId: The sfdc object Id this file will be attached to
        attachmentId: The record of the current Attachment file being processed
        fileName: Name of the attachment
        contentTye: Content Type of the file being attached
        base64BlobValue: Base64 encoded string of the file piece currently processing
        */
               
        //If recordId is blank this is the first part of a multi piece upload
        if(attachmentId == '' || attachmentId == null){
            Attachment att = new Attachment(
                ParentId = parentId,
                Body = EncodingUtil.Base64Decode(base64BlobValue),
                Name = fileName,
                ContentType = contentType
              //  BodyLength = size
            );
            insert att;
            
            //Return the new attachment Id
            return att.Id;
            
        }else{
            for(Attachment atm : [select Id, Body from Attachment where Id = :attachmentId]){
                //Take the body of the current attachment, convert to base64 string, append base64 value sent from page, then convert back to binary for the body
                update new Attachment(Id = attachmentId, Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
            }
            
            //Return the Id of the attachment we are currently processing
            return attachmentId;
        }
    }
    
}