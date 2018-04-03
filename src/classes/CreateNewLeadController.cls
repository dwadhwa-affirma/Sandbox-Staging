public class CreateNewLeadController
{
    public string AccountID {get;set;}
    public string MemberAccountID {get;set;}
    
    public string EstimateAmount {get;set;}
    public string LoanAmount {get;set;}
   
    public Lead leadObject {get;set;}
    public string OwnerName {get;set;}
    public string OwnerID {get;set;}
    public string accountName {get;set;}
    public list<SelectOption> ProductTypeList {get;set;}
    public string productTypeClass {get;set;}
    public string brandClass {get;set;}
    public decimal SelectedEpisysUserId {get;set;}
    
    string uid= UserInfo.getUserId();
    public string branchOption { get;set; }
    public list<SelectOption> BranchOptionList{get;set;}
    
     public CreateNewLeadController(ApexPages.StandardController controller){

        AccountID = System.currentPageReference().getParameters().get('accountid');               
        
        /*List<Account> accounts = [SElect owner.alias from Account where ID =: AccountID]  ;
        String Alias=''; 
        if (accounts.size() > 0 )
        {
            Alias = accounts[0].owner.alias;
            
        }
        List<user> usrs = [Select id from user where alias =: Alias];
        if (usrs.size() > 0)
        {
            uid = usrs[0].id;
        }*/
          system.debug('AccountID --- from page ' + accountid);
         
         
         
         User usr = [Select id, name, alias from User where id=:uid];
       List<Episys_User__c> eusr = [SELECT id,
                      alias__c,
                      Assigned_Branch__c from Episys_User__c where alias__c=:usr.alias]; 
         
       
        Schema.DescribeFieldResult statusFieldDescription = Lead.Product_Type__c.getDescribe();
        
        productTypeClass = '';
        brandClass = '';
        list<SelectOption> op = new list<SelectOption>();
        op.add(new SelectOption('-None-','-None-'));
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            op.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        ProductTypeList = op;        

        if(AccountID == null)
        {
         
         ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Account not found');
            return;
        }
               
        List<Account> acclist = [Select Id,Name,Alternate_Email__pc,Owner.Name,Owner.ID,Suffix,FirstName,MiddleName,
        LastName,PersonEmail,Residential_City__pc,Residential_Country_Code__pc,Residential_Country__pc,Residential_Extra_Address__pc,
        Residential_State__pc,Residential_Street__pc,Residential_Zipocde__pc,PersonMobilePhone, Home_Phone__pc, Phone  from Account where Id =: AccountID limit 1];
        Account acc = acclist[0];
        if(acc == null)
        {
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Account');
            ApexPages.addMessage(msgs );
            return;

        }
        leadObject = new Lead();
        leadObject.Person__c = AccountID;
        leadObject.FirstName = acc.FirstName;
        leadObject.LastName = acc.LastName;
        leadObject.MiddleName = acc.MiddleName;
        leadObject.Suffix = acc.Suffix;
        leadObject.Home_Phone__c = acc.Home_Phone__pc;
        leadObject.Street_Address_1__c = acc.Residential_Street__pc;
        //OwnerName =  acc.Owner.Name;
        OwnerName = userinfo.getFirstName() + ' ' + userinfo.getLastName();
        OwnerID = acc.Owner.ID;        
        leadObject.Street_Address_2__c = acc.Residential_Extra_Address__pc;
        leadObject.Country__c = acc.Residential_Country_Code__pc;
        leadObject.State__c = acc.Residential_State__pc;
        leadObject.City__c = acc.Residential_City__pc;
                leadObject.Zip_Code__c = acc.Residential_Zipocde__pc;
         if(MemberAccountID!=NULL){
          leadObject.Member_Branch__c = currentBranch(MemberAccountID); }    
                  BranchOptionList = itemsList();  
          leadObject.Estimate_Value__c = EstimateAmount;
          leadObject.Loan_Amount__c = LoanAmount;    
    }
     //member branch code 
        public ID currentBranch(String memID){           
        List<Account_Details__c> mem_acc = [select id, Current_Branch1__c from Account_Details__c where id=:memID]; 
        if(mem_acc != null){
          return mem_acc[0].id;
         }
        else return '';
        } 
         
    
    
    
    
    public List<SelectOption> ItemsList(){
        User usr = [Select id, name, alias from User where id=:uid];
       List<Episys_User__c> eusr = [SELECT id,
                      alias__c,
                      Assigned_Branch__c,Episys_ID__c, Branch_Name__c,Default__c from Episys_User__c where alias__c=:usr.alias order by Default__c]; 
        
         List<SelectOption> options = new List<SelectOption>();
         /*if(eusr.size()>0){
         BranchOption = eusr[0].Branch_Name__c;
                leadObject.Episys_User_ID__c =  eusr[0].Episys_ID__c;
                } */
         for(Episys_User__c eu : eusr ){
            if(eu.Default__c||(eusr.size()==1))
            {
                BranchOption = eu.Branch_Name__c;
                leadObject.Episys_User_ID__c =  eu.Episys_ID__c;
            }
            
            if(!eu.Default__c&&(eusr.size()!=1))
            {
                BranchOption = eu.Branch_Name__c;
                leadObject.Episys_User_ID__c =  eu.Episys_ID__c;
            }
            options.add(new SelectOption(eu.Branch_Name__c, eu.Branch_Name__c));
         }
                   
        return options;
         }
         
    
    
    public PageReference Save()
    {
        brandClass = '';
        productTypeClass = '';
        if(String.isBlank(leadObject.Product_Type__c) || leadObject.Product_Type__c == '--None--'){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product Type: You must enter a value');
            ApexPages.addMessage(msgs);
            productTypeClass = 'error';
            return null;
       }
       if(String.isBlank(leadObject.Brand__c) || leadObject.Brand__c == '--None--'){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR, 'Brand: You must enter a value');
            ApexPages.addMessage(msgs);
            brandClass = 'error';
            return null;
       }
       system.debug('---SelectedEpisysUserId--'+SelectedEpisysUserId);
       //if(SelectedEpisysUserId != null){
        
        
       //}
       productTypeClass = '';
       
       //leadObject.OwnerID = OwnerID;
       Database.DMLOptions dmo=new Database.DMLOptions();
       dmo.assignmentRuleHeader.useDefaultRule= true;

       leadobject.setOptions(dmo);
        
        if(!string.isBlank(MemberAccountID)){
            
         leadObject.Member_Account__c = MemberAccountID;
              
        }
        if(SelectedEpisysUserId != null){
            leadObject.Episys_User_ID__c = SelectedEpisysUserId;
        }     
        /*system.debug('---leadObject--- Ownership ---' + leadObject.Ownership__c);   
       if(leadObject.Ownership__c == 'Assign' || leadObject.Ownership__c == 'Keep'){            
            leadObject.Keep__c = true;
       }*/
       
        
         insert leadObject;
         system.debug('---leadObject--'+leadObject.Episys_User_ID__c);
         system.debug('---leadObject--'+leadObject.id);
         //lead leadlst
         PageReference pageRef = new PageReference('/' + leadObject.id);
            pageRef.setRedirect(true);
            return pageRef;
       
       
        
    }
    
    
    public void SetEpsisUserID()
    {
        
         User usr = [Select id, name, alias from User where id=:uid];
         List<Episys_User__c> eusr = [SELECT id,alias__c, Assigned_Branch__c, Branch_Name__c,Default__c,Episys_Name__c,Episys_ID__c from Episys_User__c where alias__c=:usr.alias order by Default__c]; 
        system.debug('Branch_Name__c----' + eusr + '---');
         for(Episys_User__c eu : eusr ){
            if(BranchOption.trim() ==  eu.Branch_Name__c.trim())
            {
              leadObject.Episys_User_ID__c =  eu.Episys_ID__c;
              SelectedEpisysUserId = eu.Episys_ID__c;
            }
         }
         
         

             
             
    }
        
        

}