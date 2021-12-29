import Foundation
import XCTest
@testable import AsyncHttp


class RequestBuilderTests: XCTestCase {
    
    func testBuilderQueryParams() async throws {
        let builder = RequestBuilder(method: .GET, urlStr: "http://localhost")
        builder.addQueryParam(name: "query", value: "test")
        let request = builder.build()
        XCTAssertEqual(request.url, "http://localhost?query=test")
        XCTAssertEqual(request.method, .GET)
    }
    
    func testBuilderHeaders() async throws {
        let builder = RequestBuilder(method: .GET, urlStr: "http://localhost")
        builder.addHeader(field: "k", value: "v")
        let request = builder.build()
        XCTAssertEqual(request.headers, ["k" : "v"])
        XCTAssertEqual(request.method, .GET)
    }
    
    func testBuilderBody() async throws {
        let body = "abc".data(using: .utf8)!
        let builder = RequestBuilder(method: .POST, urlStr: "http://localhost")
        builder.body = body
        let request = builder.build()
        XCTAssertEqual(request.body, body)
        XCTAssertEqual(request.method, .POST)
    }
    
    func testBuilderSettings() async throws {
        let builder = RequestBuilder(method: .POST, urlStr: "http://localhost")
        builder.cachePolicy = .returnCacheDataElseLoad
        builder.timeoutInterval = 20
        let request = builder.build()
        XCTAssertEqual(request.timeoutInterval, 20)
        XCTAssertEqual(request.cachePolicy, .returnCacheDataElseLoad)
    }
    
}
