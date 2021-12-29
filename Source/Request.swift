import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


public enum RequestMethod : String {

    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case CONNECT = "CONNECT"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    case PATCH = "PATCH"
    
}


public struct Request {
    
    public let method: RequestMethod
    public let url: String
    public let headers: [String : String]
    public let body: Data?
    public let cachePolicy: URLRequest.CachePolicy?
    public let session: URLSession?
    public let timeoutInterval: TimeInterval?
    
    public init(
        method: RequestMethod,
        url: String,
        headers: [String : String] = [:],
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy? = nil,
        session: URLSession? = nil,
        timeoutInterval: TimeInterval? = nil
    ) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
        self.cachePolicy = cachePolicy
        self.session = session
        self.timeoutInterval = timeoutInterval
    }
    
}
