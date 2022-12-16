@isTest
global class VSMockHttpResponseGenerator implements HttpCalloutMock {
        //this mock is for Freshdesk but in theory it should be 
        //available for any mock response
        //if code is using values from the response to do further processing
        //the json response may need ot be updated 
        //this is an object resonse and array response
    global static HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test","id" : "122312414","email":"sdfasdfasdf@mail.com"}');
        res.setStatusCode(200);
        return res;
    }
    global static HTTPResponse respondArray(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"example":"test","id" : "122312414","email":"sdfasdfasdf@mail.com"}]');
        res.setStatusCode(200);
        return res;
    }
}