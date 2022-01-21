import Foundation

public struct ResponseHeaders {
    
    private let dict: [String : String]
    
    public init(dict: [String : String]) {
        var lower: [String : String] = [:]
        for (k, v) in dict {
            lower[k.lowercased()] = v
        }
        self.dict = lower
    }
    
    public subscript(field: String) -> String? {
        return dict[field.lowercased()]
    }
    
    public var keys: [String] {
        return dict.keys.sorted()
    }
    
}

public struct Response {
    
    public let statusCode: Int
    public let body: Data
    public let headers: ResponseHeaders
        
    public init(
        statusCode: Int,
        body: Data = Data(),
        headers: ResponseHeaders = .init(dict: [:])
    ) {
        self.statusCode = statusCode
        self.body = body
        self.headers = headers
    }
}
