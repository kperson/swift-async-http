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
    
    @discardableResult public func addHeader(field: String, value: String) -> RequestBuilder {
        headers[field] = value
        return self
    }
    
    @discardableResult public func addHeaders(fieldValues: [String : String]) -> RequestBuilder {
        for (f, v) in fieldValues {
            _ = addHeader(field: f, value: v)
        }
        return self
    }
    
    @discardableResult public func addQueryParam(name: String, value: String?) -> RequestBuilder {
        queryParams.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    @discardableResult public func addQueryParams(nameValues: [String : String?]) -> RequestBuilder {
        for (n, v) in nameValues {
            _ = addQueryParam(name: n, value: v)
        }
        return self
    }
    
    @discardableResult public func setBody(body: Data) -> RequestBuilder {
        self.body = body
        return self
    }
    
    @discardableResult public func setBody(body: String, encoding: String.Encoding = .utf8) -> RequestBuilder {
        self.body = body.data(using: encoding)
        return self
    }

    public var url: URL {
        var urlComps = URLComponents(string: urlWithoutParams)
        if !queryParams.isEmpty {
            urlComps?.queryItems = queryParams.sorted { a, b in a.name < b.name }
        }
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
