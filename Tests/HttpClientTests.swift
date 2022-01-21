import Foundation
import XCTest
@testable import AsyncHttp


class HttpClientTests: RequestTestCase {
    
    let headerKey = "hELlO"
    let headerValue = "world"
    let client = HttpClient()
    let decoder = JSONDecoder()

    func testMethodsWithBodies() async throws {
        let body = "test body"
        let bodyData = body.data(using: .utf8)!
        let methods: [RequestMethod] = [
            .POST, .PUT, .DELETE, .OPTIONS, .TRACE, .PATCH
        ]
        for method in methods {
            let response = try await client.fetch(request: .init(
                method: method,
                url: Self.url,
                headers: [headerKey : headerValue],
                body: bodyData
            ))
            let echoResponse = try decoder.decode(EchoResponse.self, from: response.body)
            XCTAssertEqual(method.rawValue, echoResponse.method)
            XCTAssertEqual(Self.path, echoResponse.path)
            XCTAssertEqual(headerValue, echoResponse.headers[headerKey.lowercased()])
            XCTAssertEqual(body, echoResponse.body)
        }
    }
    
    func testMethodsWithoutBodies() async throws {
        let methods: [RequestMethod] = [
            .GET
        ]
        for method in methods {
            let response = try await client.fetch(request: .init(
                method: method,
                url: Self.url,
                headers: [headerKey : headerValue]
            ))
            let echoResponse = try decoder.decode(EchoResponse.self, from: response.body)
            XCTAssertEqual(method.rawValue, echoResponse.method)
            XCTAssertEqual(Self.path, echoResponse.path)
            XCTAssertEqual(headerValue, echoResponse.headers[headerKey.lowercased()])
            XCTAssertEqual("", echoResponse.body)
        }
    }
    
    static private var url: String {
        return "http://\(testingHost):\(testingPort)\(path)"
    }

    static private var path: String {
        return "/my-path"
    }
    
}
