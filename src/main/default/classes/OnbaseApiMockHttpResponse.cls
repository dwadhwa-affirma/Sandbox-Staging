@isTest
global class OnbaseApiMockHttpResponse implements HttpCalloutMock {
    
    // Implement HttpResponse methos
    global HttpResponse respond(HTTPRequest request){
        
       System.assertEquals('POST', request.getMethod());
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.SetHeader('Content-Type', 'application/json');
        response.setBody('{"DocumentName_c" : "W-8 and W9 Forms for ESTHER EMEFIELE  - 59985 4/17/2019"}');
              
        response.setStatusCode(200);
        return response;
    }

}