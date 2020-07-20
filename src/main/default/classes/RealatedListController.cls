public class RealatedListController{
public string mid {get;set;}
ApexPages.StandardController con;
public string thisid {get;set;}
public List<Attachment> AttachmentLst {get;set;}

    public RealatedListController(ApexPages.StandardController controller) {
        con = controller;
        Member_Comment__c m = (Member_Comment__c)con.getrecord();
        mid = m.id;
        
        
        if(mid != Null){
            AttachmentLst = new List<Attachment>();
            AttachmentLst = [select id,Name,LastModifiedDate,CreatedById,CreatedBy.Name,ParentID  from Attachment where ParentID =:mid];    
            system.debug('this is the list--'+AttachmentLst);
        }

    }
    public void deleteAttachment(){
    
    system.debug('thisid--'+thisid );
        if(thisid != Null){
        Attachment at = [Select id from Attachment  where id =:thisid limit 1];
            if(at != null){
                delete at;
                //PageReference pageRef = new PageReference('/' +);
                //nextPage.setRedirect(true);
                //return nextPage ;
            }
           
        }
    AttachmentLst = [select id,Name,LastModifiedDate,CreatedById,CreatedBy.Name,ParentID  from Attachment where ParentID =:mid]; 
        //return null;
    }


    
}