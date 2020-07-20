@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
    // Create a fake response (first mock is access_token, second mock is client id)
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('[{},{"Notices": {"desc": "Notices","documents": [ {"dateDesc": "Transaction Limit Notice as of February 20, 2019","documentDate": "2019-02-20", "exigent": false, "hyperlinkHTML": "null&admin=0", "hyperlinkPDF": "https://testestmt.businessdatainc.com/ChevronFCU/rest/document?enc=vWJkE5BqDoMJPUZIrgNM2m2Q1gmoICzVuzkzqMIIrJ97hoNZ6DXZk8yUhRVEanAMOm3wh4Rr3NWqyjmt2Lrgk1b8HBTKIET5KiJ%2FCBsILhypTjXIthPob890iR2h8nC%2F8ypReTzaLCz28KsljDuhCsJTJ4Sv7Ed6drVHykoVpidZsGpbqPI2IyHmOqMYuFMBVmNdTxoYOJTilUFczfb1Gi2tzVcVohYcsjnZ%2Bmjr4vtd3Sh1D%2FVBXEZOmsrXmdimTffa3PACN1iG8ccDRJ%2FN1WhkaS6P%2BYyuHdcDVpJ8fUjAoEckwVUNpKKMKYBOnd%2FuTfAE9ndjhXSGtKKcvAuTW86H%2BNm0GfWHmI3oHQd%2FdzNzQZ4xsK1m%2FsNeR5T0SIQg&iv=nJaZbGXr3C93qCg8nk2DfQ%3D%3D&admin=0", "subCategoryDesc": "Transaction Limit Notice","userID": "52732", "viewed": true}], "exigent": false, "maxItemsInDocList": 8, "size": 16}}]');
    res.setStatusCode(200);

    return res;
}
}