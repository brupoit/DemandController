@isTest
public class HTTPMockFactory implements HttpCalloutMock {
  protected Integer code;
  protected String status;
  protected String body;
  protected Map<String, String> responseHeaders;

  public HTTPMockFactory(Integer code, String status, String body, Map<String, String> responseHeaders) {
    this.code = code;
    this.status = status;
    this.body = body;
    this.responseHeaders = responseHeaders;
  }

  public HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    for (String key : this.responseHeaders.keySet()) {
      res.setHeader(key, this.responseHeaders.get(key));
    }

    if (req.getEndpoint().contains('oauth2')) {
        res.setBody('{"access_token": "string_Acess_token"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    } else {
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
    }

    return res;
  }
}