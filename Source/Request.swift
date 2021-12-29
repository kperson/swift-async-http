import Foundation


public enum RequestMethod : String {
    
    case POST = "POST"
    case GET = "GET"
    case DELETE = "DELETE"
    case PUT = "PUT"
    case OPTIONS = "OPTIONS"
    case CONNECT = "CONNECT"
    case TRACE = "TRACE"
    case HEAD = "HEAD"
    case PATCH = "PATCH"
    
}


public struct Request {
    
    public let method: RequestMethod
    public let url: String
    public let headers: [String : String]
    public let body: Data
    public let cachePolicy: URLRequest.CachePolicy?
    public let session: URLSession?
    
    
    public init(
        method: RequestMethod,
        url: String,
        headers: [String : String] = [:],
        body: Data = Data(),
        cachePolicy: URLRequest.CachePolicy? = nil,
        session: URLSession?
    ) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
        self.cachePolicy = cachePolicy
        self.session = session
    }
    
}
