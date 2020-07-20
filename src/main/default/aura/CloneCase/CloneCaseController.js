({
	doInit : function(component, event, helper) {		
		if (component.isValid()) {
			setTimeout(function(){ 
				var footer = document.getElementById('CloneCaseFooter');
		        var body = helper.closest(footer,'.modal-container');
		        body.append(footer);
		        footer.previousSibling.remove();		        
			}, 300);
        }     	
	},
	
	closePopup: function(component, event, helper) {
	  $A.get('e.force:closeQuickAction').fire();
	},    
	
	saveCloneCaseClick : function(component, event, helper) {
		var recordid = component.get("v.recordId");    	
    	component.set("v.loading", true);
    	var Subject = component.get("v.Subject");
    	if(Subject == undefined || Subject == '' || Subject == null)
    	{
    		Subject = false;
    	}
    	var Description = component.get("v.Description");
    	if(Description == undefined || Description == '' || Description == null)
    	{
    		Description = false;
    	}
    	var Device_Type = component.get("v.Device_Type");
    	if(Device_Type == undefined || Device_Type == '' || Device_Type == null)
    	{
    		Device_Type = false;
    	}
    	var Status = component.get("v.Status");
    	if(Status == undefined || Status == '' || Status == null)
    	{
    		Status = false;
    	}
    	var Category = component.get("v.Category");
    	if(Category == undefined || Category == '' || Category == null)
    	{
    		Category = false;
    	}
    	var MemberComment = component.get("v.MemberComment");
    	if(MemberComment == undefined || MemberComment == '' || MemberComment == null)
    	{
    		MemberComment = false;
    	}
    	var CaseComment = component.get("v.CaseComment");
    	if(CaseComment == undefined || CaseComment == '' || CaseComment == null)
    	{
    		CaseComment = false;
    	}
    	var Attachment = component.get("v.Attachment");
        if(Attachment == undefined || Attachment == '' || Attachment == null)
    	{
    		Attachment = false;
    	}
    	
        helper.cloneCase(component, recordid, Subject, Description, Device_Type, Status, Category,MemberComment,CaseComment,Attachment);
	}
})