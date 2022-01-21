import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum HttpClientErrors: Error {
    
    case unableToCreateUrl(String)
    case unableToConvertToHttpResponse
    
}

open class HttpClient {
    
    public let session: URLSession
    public let cachePolicy: URLRequest.CachePolicy?
    public let timeoutInterval: TimeInterval?
    
    public init(
        session: URLSession = URLSession.shared,
        cachePolicy: URLRequest.CachePolicy? = nil,
        timeoutInterval: TimeInterval? = nil
    ) {
        self.session = session
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }
    
    public func fetch(request: Request) async throws -> Response {
        guard let url = URL(string: request.url) else { throw HttpClientErrors.unableToCreateUrl(request.url) }
        var urlRequest = URLRequest(url: url)
        
        // request method
        urlRequest.httpMethod = request.method.rawValue
        
        // override the timeout if specified
        if let t = request.timeoutInterval {
            urlRequest.timeoutInterval = t
        }
        // use default timeout if provied and not overriden
        else if let t = timeoutInterval {
            urlRequest.timeoutInterval = t
        }
        
        // override the cache policy if specified
        if let c = request.cachePolicy {
            urlRequest.cachePolicy = c
        }
        // use default cache policy if provied and not overriden
        else if let c = cachePolicy {
            urlRequest.cachePolicy = c
        }
        
        // request body
        if let b = request.body, !b.isEmpty {
            urlRequest.httpBody = b
        }
        
        for (headerKey, headerValue) in request.headers {
            urlRequest.addValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let requestSession = request.session ?? session
        return try await withCheckedThrowingContinuation { continuation in
            let task = requestSession.dataTask(with: urlRequest) { data, response, error in
                if let e = error {
                    continuation.resume(throwing: e)
                }
                else if let httpResponse = response as? HTTPURLResponse {
                    var responseHeaders: [String : String] = [:]
                    for (headerKey, _) in httpResponse.allHeaderFields {
                        if  let k = headerKey as? String,
                            let v = httpResponse.value(forHTTPHeaderField: k) {
                            responseHeaders[k] = v
                        }
                    }
                    let response = Response(
                        statusCode: httpResponse.statusCode,
                        body: data ?? Data(),
                        headers: ResponseHeaders(dict: responseHeaders)
                    )
                    continuation.resume(returning: response)
                }
                else {
                    continuation.resume(throwing: HttpClientErrors.unableToConvertToHttpResponse)
                }
            }
            task.resume()
        }
    }
    
}
