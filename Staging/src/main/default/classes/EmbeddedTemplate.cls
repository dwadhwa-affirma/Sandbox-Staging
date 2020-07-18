public class EmbeddedTemplate {
public static String sendEmbeddedEnvelope(){
  // set source for the envelope 
  // query any id for a salesforce object which //will be set as a source
 id xprsid = [Select ID from Xpress_Refi__C limit 1].id;
   

// create an empty envelope
// use dfsle.EnvelopeService.getEmptyEnvelope input parameter new dfsle.Entity
    
    



// add embedded recipient to the envelope
//Use dfsle.Recipient.newEmbeddedSigner();
//This will add current user as the Embedded signer
    
    
    string st = 'text';
return st;
}
}