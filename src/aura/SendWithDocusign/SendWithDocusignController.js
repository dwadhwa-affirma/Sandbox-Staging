({
	  doInit: function (component, event, helper) {   
          var recordid = component.get("v.recordId");
          $A.get('e.force:closeQuickAction').fire();
          window.location.href = ("/apex/dsfs__DocuSign_CreateEnvelope?Lightning=1&DSEID=0&NW=1&SourceID=" + recordid);
          
      }
})