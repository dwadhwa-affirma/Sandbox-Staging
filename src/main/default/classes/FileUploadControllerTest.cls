@isTest
public class FileUploadControllerTest {

    static testmethod void testmethod1() {
        
        Case cs = new Case();
        cs.Brand__c = 'Spectrum';
        insert cs;
      
        Attachment a = new Attachment();
        a.ParentId = cs.id;
        a.name = '#16 -Share Certificate Account';
        a.Body = Blob.valueOf('Some Text');
        a.ContentType = 'application/pdf';
        insert a;
        
        FileUploadController.saveChunk(cs.id, a.name, '5555',a.ContentType, '');       
        FileUploadController.saveTheFile(cs.id, a.name, '5555',a.ContentType);  
        FileUploadController.saveChunk(cs.id, a.name, '5555',a.ContentType, a.id); 
        
    }
}