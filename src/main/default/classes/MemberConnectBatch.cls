global class MemberConnectBatch implements Database.Batchable<SObject>, Database.Stateful{

    global boolean isweek = false;
    global integer Thisweekday = 0;
    global integer lastQuaterday = 0;
    global Date lastMonthday ;
    global List<Count_Member_Connect__c> countlstMonth = new List<Count_Member_Connect__c>();
     global List<Count_Member_Connect__c> countlstWeek = new List<Count_Member_Connect__c>();
     global List<Count_Member_Connect__c> countlstQurterly = new List<Count_Member_Connect__c>();
    global Iterable<SObject> start(Database.BatchableContext BC)
    {
        //Member_Connect_Report__c mc = Member_Connect_Report__c.getValues('Week');
		//integer day = Integer.valueOf(mc.Days__c);
        
        String Week = system.Now().format('EEEE');   
        system.debug('--Week--- '+Week);
        if(Week == 'Monday'){
           Thisweekday = 1; 
        }else if(week == 'Tuesday'){
             Thisweekday=2;
        } else if(week == 'Wednesday'){
             Thisweekday=3;
        } else if(week == 'Thursday'){
             Thisweekday=4;
        } else if(week == 'Friday'){
             Thisweekday=5;
        }else if(week == 'Saturday'){
             Thisweekday=6;
        }else if(week == 'Sunday'){
             Thisweekday=7;
        }
        system.debug('--lastweekday'+Thisweekday);
        delete [select id,name from Count_Member_Connect__c where (Is_week__C = true and date__c = THIS_WEEK) or (date__c = THIS_MONTH and IS_Month__c =true) or (date__c = THIS_QUARTER and Is_Quarter__c = true)];
       
        String query = 'select id, name, role_name__c, lastmodifieddate, createddate,lastmodifiedByid, createdByid, createdby.Name, LastModifiedby.Name,LastModifiedby.UserRole.Name'+ 
            ' from Needs_Assesment__c where CreatedDate = THIS_WEEK  or lastmodifieddate = THIS_WEEK or CreatedDate = THIS_MONTH or lastmodifieddate = THIS_MONTH or CreatedDate = THIS_QUARTER or lastmodifieddate = THIS_QUARTER';
        system.debug('--'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Needs_Assesment__c> scope)
    {
        //Weekly count member connect
        //List<Count_Member_Connect__c> countlst = new List<Count_Member_Connect__c>();
       
        Date weekday = System.today() - Thisweekday;
        for(Needs_Assesment__c Na : scope)
        {	boolean flag = false; 
            if(na.CreatedDate >= weekday){
               
                for(integer i = 0 ; i < countlstWeek.size(); i++){
                    if( na.CreatedById == countlstWeek[i].UserId__c){
                        countlstWeek[i].Total_Count__c+= 1; 
                        countlstWeek[i].Member_Connect_Name__c += na.id +',';
                        flag=true;
                        
                    }
                }
                if(!flag){                	
                    countlstWeek.add(new Count_Member_Connect__c(Branch_Name__c=na.role_name__c,Total_Count__c=1,User_Name__c=na.CreatedBy.name,
                                                             UserId__c=na.CreatedById,date__c = system.today()-Thisweekday+1,	is_Week__c = true,Member_Connect_Name__c=na.id+','	));
                    flag = true;
                }
            }
            if((na.CreatedById != na.LastModifiedById && na.LastModifiedDate >= weekday && flag) || (!flag && na.LastModifiedDate >= weekday)){
                boolean flag1 = false;
               for(integer i = 0 ; i < countlstWeek.size(); i++){
                    if( na.LastModifiedById == countlstWeek[i].UserId__c){
                        countlstWeek[i].Total_Count__c+= 1; 
                        countlstWeek[i].Member_Connect_Name__c += na.id +',';
                        flag1=true;
                    }
                }   
                if(!flag1){                	
                        countlstWeek.add(new Count_Member_Connect__c(Branch_Name__c=na.LastModifiedBy.UserRole.name,Total_Count__c=1,User_Name__c=na.LastModifiedBy.name,
                                                                 UserId__c=na.LastModifiedById,date__c = system.today()-Thisweekday+1,is_Week__c = true,Member_Connect_Name__c=na.id+','));
                    }
            }
             
        }
          
        //Monthly count member connect
       
        lastMonthday = Date.newInstance(system.today().year(),System.today().Month(),1);
        system.debug('-----------lastmonth-----'+lastMonthday);
        for(Needs_Assesment__c Na : scope)
        {	boolean flag = false; 
            if(na.createdDate >= lastMonthday){
                
                for(integer i = 0 ; i < countlstMonth.size(); i++){
                    if( na.CreatedById == countlstMonth[i].UserId__c){
                        countlstMonth[i].Total_Count__c+= 1; 
                        countlstMonth[i].Member_Connect_Name__c += na.id +',';
                        flag=true;
                    }
                }
                if(!flag){  
                     
                    countlstMonth.add(new Count_Member_Connect__c(Branch_Name__c=na.role_name__c,Total_Count__c=1,User_Name__c=na.CreatedBy.name,
                                                             UserId__c=na.CreatedById,date__c = lastMonthday,	is_MOnth__c = true,Member_Connect_Name__c=na.id+','));
                    flag = true;
                }
            }
            if((na.CreatedById != na.LastModifiedById && flag && na.LastModifiedDate >= lastMonthday) || (!flag && na.LastModifiedDate >= lastMonthday)){
                boolean flag1 = false;
               
               for(integer i = 0 ; i < countlstMonth.size(); i++){
                    if( na.LastModifiedById == countlstMonth[i].UserId__c){
                        countlstMonth[i].Total_Count__c+= 1; 
                        countlstMonth[i].Member_Connect_Name__c += na.id +',';
                        flag1=true;
                    }
                }   
                if(!flag1){    
                       
                        countlstMonth.add(new Count_Member_Connect__c(Branch_Name__c=na.LastModifiedBy.UserRole.name,Total_Count__c=1,User_Name__c=na.LastModifiedBy.name,
                                                                 UserId__c=na.LastModifiedById,date__c = lastMonthday,is_Month__c = true,Member_Connect_Name__c=na.id+','));
                    }
            }
             
        }
         
         //Qurterly count member connect
      
        Date lastQurterly;
        if(system.today().Month() <= 3 ){
            lastQurterly = Date.newInstance(system.today().year(),1,1);
        }else if(system.today().Month() >= 4 && system.today().Month() <= 6){
             lastQurterly = Date.newInstance(system.today().year(),4,1);
        }else if(system.today().Month() >= 7 && system.today().Month() <= 9){
             lastQurterly = Date.newInstance(system.today().year(),7,1);
        }else if(system.today().Month() >= 10 && system.today().Month() <= 12){
             lastQurterly = Date.newInstance(system.today().year(),10,1);
        }
        system.debug('-----------lastmonth-----'+lastMonthday);
        for(Needs_Assesment__c Na : scope)
        {	boolean flag = false; 
            if(na.createdDate >= lastQurterly){
                
                for(integer i = 0 ; i < countlstQurterly.size(); i++){
                    if( na.CreatedById == countlstQurterly[i].UserId__c){
                        countlstQurterly[i].Total_Count__c+= 1; 
                        countlstQurterly[i].Member_Connect_Name__c += na.id +',';
                        flag=true;
                    }
                }
                if(!flag){  
                     
                    countlstQurterly.add(new Count_Member_Connect__c(Branch_Name__c=na.role_name__c,Total_Count__c=1,User_Name__c=na.CreatedBy.name,
                                                             UserId__c=na.CreatedById,date__c = lastQurterly,	Is_Quarter__c  = true,Member_Connect_Name__c=na.id+','));
                    flag = true;
                }
            }
            if((na.CreatedById != na.LastModifiedById && flag && na.LastModifiedDate >= lastQurterly) || (!flag && na.LastModifiedDate >= lastQurterly)){
                boolean flag1 = false;
               
               for(integer i = 0 ; i < countlstQurterly.size(); i++){
                    if( na.LastModifiedById == countlstQurterly[i].UserId__c){
                        countlstQurterly[i].Total_Count__c+= 1; 
                         countlstQurterly[i].Member_Connect_Name__c += na.id +',';
                        flag1=true;
                    }
                }   
                if(!flag1){    
                       
                        countlstQurterly.add(new Count_Member_Connect__c(Branch_Name__c=na.LastModifiedBy.UserRole.name,Total_Count__c=1,User_Name__c=na.LastModifiedBy.name,
                                                                 UserId__c=na.LastModifiedById,date__c = lastQurterly,Is_Quarter__c  = true,Member_Connect_Name__c=na.id+','));
                    }
            }
             
        }
              
    }  
    global void finish(Database.BatchableContext BC)
    {
    	 try {
				 insert countlstWeek;
				 insert countlstmonth;
				 insert countlstQurterly;
				 system.debug('--finish---w-----'+countlstWeek.size());
				system.debug('--finish----m----'+countlstmonth.size());
				system.debug('--finish----q----'+countlstQurterly.size());
                Database.executeBatch(new MemberConnectLookupBatch(),200);

    	 }
    	 catch (exception e){} 
        
         
        
    }
}