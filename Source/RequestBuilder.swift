import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class RequestBuilder {
    
    public let method: RequestMethod
    private let urlWithoutParams: String
    private var queryParams: [URLQueryItem] = []
    
    public private(set) var headers: [String : String] = [:]
    
    public var body: Data? = nil
    public var cachePolicy: URLRequest.CachePolicy?
    public var session: URLSession?
    public var timeoutInterval: TimeInterval?
    
    public init(method: RequestMethod, url: String) {
        self.method = method
        self.urlWithoutParams = url
    }
    
    public func addHeader(field: String, value: String) {
        headers[field] = value
    }
    
    public func addQueryParam(name: String, value: String?) {
        queryParams.append(URLQueryItem(name: name, value: value))
    }

    public var url: URL {
        var urlComps = URLComponents(string: urlWithoutParams)
        urlComps?.queryItems = queryParams
        return urlComps?.url ?? URL(string: urlWithoutParams)!
    }
    
    public func build() -> Request {
        return .init(
            method: method,
            url: url.absoluteString,
            headers: headers,
            body: body,
            cachePolicy: cachePolicy,
            session: session,
            timeoutInterval: timeoutInterval
        )
    }
    
}
