trigger MemberCommentTrigger on Member_Comment__c (before insert, before update) {

     
    if(Trigger.isBefore){
        
        for(Member_Comment__c mc: Trigger.new){ 
            string commString = mc.Member_Communication__c;         
            if(mc.Member_Communication__c != null && mc.Member_Communication__c.indexOf('/version/download/') != -1)
            {
                    String imgSubstr = '<img src="';
                    String[] strArray =commString.split('<img src="');
                    List<string> listContentIds = new List<string>();

                    
                    if(strArray.size() > 1)
                    {
                        for (integer i = 1; i < strArray.size(); i++) {
                            string imageString = strArray[i];
                            Integer indexofId = imageString.indexOf('/version/download/') ;
                            if(indexofId > -1)
                            {
                            Integer startIndexofId = (indexofId+18);
                            Integer nbCharacters1 = 15;             
                            startIndexofId = startIndexofId < 0 ? imageString.length() + startIndexofId : startIndexofId;
                            String contentVersionId = imageString.substring(startIndexofId,startIndexofId + nbCharacters1);
                            string[]  innerArray = imageString.split('">');
                            innerArray[0] = '{{' + contentVersionId + '}}';
                            strArray[i] = string.join(innerArray, '">');        
                            listContentIds.add(contentVersionId);
                            }
                        }
                    }
                    commString =    string.join(strArray,'<img src="');
                    List<ContentVersion> listContentVersion = [select id,PublishStatus,Title,VersionData,FirstPublishLocationId 
                                                         from ContentVersion where id in: listContentIds];
                    List<Attachment> listAttachments = new List<Attachment>();


                    for(ContentVersion itemContentVersion : listContentVersion)
                    {
                        case tempCase = [select id, Subject from case where Subject = 'This is a test Case to Upload Attachment.' and status ='In Process'];
                        Attachment oAttachment = new Attachment();
                        
                        oAttachment.parentId = tempCase.id;
                    
                        oAttachment.Body = itemContentVersion.VersionData;
                        oAttachment.Name = itemContentVersion.Title;
                        oAttachment.ContentType = 'image/png';
                        listAttachments.add(oAttachment);
                    }
                    insert listAttachments;
                    
                    for(Integer i = 0; i < listContentVersion.size(); i++)
                    {
                        //mapIds.put(listContentVersion[i], listAttachments[i]);
                        string URLAttachment = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file='+ listAttachments[i].id;
                        commString = commString.replace('{{' + ((string)listContentVersion[i].Id).substring(0,15) + '}}', URLAttachment );
                    }
                
                     mc.Member_Communication__c = commString;
                    
                    
            }
             
            /*if(mc.Member_Communication__c != null && mc.Member_Communication__c.indexOf('/version/download/') != -1)
            {
                system.debug('Member_Communication__c.indexOf===='+mc.Member_Communication__c.indexOf('/version/download/'));
                Integer index = mc.Member_Communication__c.indexOf('/version/download/') ;
                system.debug('Plus===='+(index+18)); 
                Integer startIndex = (index+18);
                Integer nbCharacters = 15;              
                startIndex = startIndex < 0 ? mc.Member_Communication__c.length() + startIndex : startIndex;
                String res = mc.Member_Communication__c.substring(startIndex,startIndex + nbCharacters);
                system.debug('Final ID====' + res); 
                
                List<ContentVersion> listContentVersion = [select id,PublishStatus,Title,VersionData,FirstPublishLocationId 
                    from ContentVersion where id =: res];
                
                system.debug(listContentVersion.size());
                system.debug('listContentVersion==='+listContentVersion);
                
                Attachment oAttachment = new Attachment();
                        oAttachment.parentId = '500W0000006oXg9IAE';
                
                        oAttachment.Body = listContentVersion[0].VersionData;
                        oAttachment.Name = listContentVersion[0].Title;
                        oAttachment.ContentType = 'image/png';
                insert oAttachment;
                                
                
            } */
            
        }
   }
   
    
}