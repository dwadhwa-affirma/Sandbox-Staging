public class eSignatureContoller {
	 @AuraEnabled
    public static void saveSignature(String signatureBody, string wiresId){
       Attachment a = new Attachment();
        a.ParentId = wiresId; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'Signature Capture.png';
        insert a;
    }
}