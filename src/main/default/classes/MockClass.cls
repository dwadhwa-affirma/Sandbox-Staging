@isTest
global class MockClass implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<ArrayOfOnBaseSignatureCard xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.datacontract.org/2004/07/RealTimeApi.Contracts.Domain"><OnBaseSignatureCard><Brand>BC01</Brand><DocumentName>Signature Cards for VINCENT CAVALIERI  - 18249 12/02/2010</DocumentName><DocumentNumber>12186294</DocumentNumber><DocumentType>Signature Card</DocumentType><MemberFirstName>VINCENT</MemberFirstName><MemberId>18249</MemberId><MemberLastName>CAVALIERI</MemberLastName><PopDocUrl>http://brsconbasedev1/HylandWebServer/docpop/DocPop.aspx?clienttype=html&amp;docid=12186294</PopDocUrl><SortOrder>0</SortOrder><Ssn>111302557</Ssn></OnBaseSignatureCard><OnBaseSignatureCard><Brand>BC01</Brand><DocumentName>Signature Cards for VINCENT CAVALIERI  - 18249 01/16/2002</DocumentName><DocumentNumber>736365</DocumentNumber><DocumentType>Signature Card</DocumentType><MemberFirstName>VINCENT</MemberFirstName><MemberId>18249</MemberId><MemberLastName>CAVALIERI</MemberLastName><PopDocUrl>http://brsconbasedev1/HylandWebServer/docpop/DocPop.aspx?clienttype=html&amp;docid=736365</PopDocUrl><SortOrder>0</SortOrder><Ssn>111302557</Ssn></OnBaseSignatureCard></ArrayOfOnBaseSignatureCard>');
        res.setStatusCode(200);
        return res;
    }
}