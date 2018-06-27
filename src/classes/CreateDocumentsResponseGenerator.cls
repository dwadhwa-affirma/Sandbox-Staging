@isTest
global class CreateDocumentsResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
      /*  System.assertEquals('http://implementlab.staging.wpengine.com/wp-json/wp-test/v2/createuser', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());*/
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('api/documents'))
        {
            res.setBody('<?xml version="1.0" encoding="UTF-8" ?> ' +
					'<root> ' +
					  '<OnBaseSignatureCard> ' +
					   ' <Brand>CFCU</Brand> ' +
					    '<DocumentName>Test</DocumentName> ' +
					    '<DocumentNumber>1223</DocumentNumber> ' +
					    '<DocumentType>1223</DocumentType> ' +
					    '<MemberId>1223</MemberId> ' +
					    '<MemberFirstName>1223</MemberFirstName> ' +
					    '<MemberLastName>1223</MemberLastName> ' +
					    '<PopDocUrl>1223</PopDocUrl> ' +
					    '<SortOrder>1223</SortOrder> ' +
					  '</OnBaseSignatureCard> ' +
					  '<OnBaseSignatureCard> ' +
					   '<Brand>CFCU</Brand> ' +
					    '<DocumentName>Test</DocumentName> ' +
					    '<DocumentNumber>1223</DocumentNumber> ' +
					    '<DocumentType>1223</DocumentType> ' +
					    '<MemberId>1223</MemberId> ' +
					    '<MemberFirstName>1223</MemberFirstName> ' +
					    '<MemberLastName>1223</MemberLastName> ' +
					    '<PopDocUrl>1223</PopDocUrl> ' +
					    '<SortOrder>1223</SortOrder> ' +
					  '</OnBaseSignatureCard> ' +
					'</root>');
			}
        
        res.setStatusCode(200);
        return res;
    }
}