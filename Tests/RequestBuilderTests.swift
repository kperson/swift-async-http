import Foundation
import XCTest
@testable import AsyncHttp


class RequestBuilderTests: XCTestCase {
    
    func testBuilderQueryParams() async throws {
        let builder = RequestBuilder(method: .GET, url: "http://localhost")
        builder.addQueryParam(name: "query", value: "test")
        let request = builder.build()
        XCTAssertEqual(request.url, "http://localhost?query=test")
        XCTAssertEqual(request.method, .GET)
    }
    
    func testBuilderQueryParamsBulk() async throws {
        let builder = RequestBuilder(method: .GET, url: "http://localhost")
        _ = builder.addQueryParams(nameValues: ["query": "test", "query2": "test2"])
        let request = builder.build()
        XCTAssertEqual(request.url, "http://localhost?query=test&query2=test2")
        XCTAssertEqual(request.method, .GET)
    }
    
    func testBuilderHeaders() async throws {
        let builder = RequestBuilder(method: .GET, url: "http://localhost")
        builder.addHeader(field: "k", value: "v")
        let request = builder.build()
        XCTAssertEqual(request.headers, ["k": "v"])
        XCTAssertEqual(request.method, .GET)
    }
    
    func testBuilderHeadersBulk() async throws {
        let builder = RequestBuilder(method: .GET, url: "http://localhost")
        builder.addHeaders(fieldValues: ["k": "v", "k2": "v2"])
        let request = builder.build()
        XCTAssertEqual(request.headers, ["k": "v", "k2": "v2"])
        XCTAssertEqual(request.method, .GET)
    }
    
    func testBuilderBody() async throws {
        let body = "abc".data(using: .utf8)!
        let builder = RequestBuilder(method: .POST, url: "http://localhost")
        builder.body = body
        let request = builder.build()
        XCTAssertEqual(request.body, body)
        XCTAssertEqual(request.method, .POST)
    }
    
    func testBuilderSettings() async throws {
        let builder = RequestBuilder(method: .POST, url: "http://localhost")
        builder.cachePolicy = .returnCacheDataElseLoad
        builder.timeoutInterval = 20
        let request = builder.build()
        XCTAssertEqual(request.timeoutInterval, 20)
        XCTAssertEqual(request.cachePolicy, .returnCacheDataElseLoad)
    }
    
    func testSetBody() async throws {
        let builder = RequestBuilder(method: .POST, url: "http://localhost")
        builder.setBody(body: "hello")
        let request = builder.build()
        XCTAssertEqual(request.body, "hello".data(using: .utf8))
    }
    
}
