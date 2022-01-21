import Foundation
import XCTest
import AsyncHttp

struct SamplPayload: Codable, Equatable {
    
    let value: String
    
}

class JSONHttpClientTests: RequestTestCase {
    
    let path = "/my/json/path"
    let headers = ["x-MY-KEY": "some-key"]
    let queryParams = ["key": "value"]
    
    let samplePayloadJSON = "{\"value\":\"hello world\"}"
    let samplePayload = SamplPayload(value: "hello world")
    let samplePayloadData = "{\"value\":\"hello world\"}".data(using: .utf8)!
    
    
    private lazy var client: JSONHttpClient = {
        return JSONHttpClient(baseURL: "http://\(Self.testingHost):\(Self.testingPort)")
    }()

    func testGet() async throws {
        let res = try await client.get(path: path, queryParams: queryParams, headers: headers)
        let echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .GET, echo: echo, hasBody: false)
    }
        
    func testPost() async throws {
        var res = try await client.post(path: path, queryParams: queryParams, headers: headers, body: samplePayload)
        var echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .POST, echo: echo, hasBody: true)
        
        res = try await client.postData(path: path, queryParams: queryParams, headers: headers, body: samplePayloadData)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .POST, echo: echo, hasBody: true, checkContentType: false)
        
        res = try await client.post(path: path, queryParams: queryParams, headers: headers)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .POST, echo: echo, hasBody: false)
    }
    
    func testDelete() async throws {
        var res = try await client.delete(path: path, queryParams: queryParams, headers: headers, body: samplePayload)
        var echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .DELETE, echo: echo, hasBody: true)
        
        res = try await client.deleteData(path: path, queryParams: queryParams, headers: headers, body: samplePayloadData)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .DELETE, echo: echo, hasBody: true, checkContentType: false)
        
        res = try await client.delete(path: path, queryParams: queryParams, headers: headers)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .DELETE, echo: echo, hasBody: false)
    }
    
    func testPut() async throws {
        var res = try await client.put(path: path, queryParams: queryParams, headers: headers, body: samplePayload)
        var echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .PUT, echo: echo, hasBody: true)
        
        res = try await client.putData(path: path, queryParams: queryParams, headers: headers, body: samplePayloadData)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .PUT, echo: echo, hasBody: true, checkContentType: false)
        
        res = try await client.put(path: path, queryParams: queryParams, headers: headers)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .PUT, echo: echo, hasBody: false)
    }
    
    func testPatch() async throws {
        var res = try await client.patch(path: path, queryParams: queryParams, headers: headers, body: samplePayload)
        var echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .PATCH, echo: echo, hasBody: true)
        
        res = try await client.patchData(path: path, queryParams: queryParams, headers: headers, body: samplePayloadData)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .PATCH, echo: echo, hasBody: true, checkContentType: false)
        
        res = try await client.patch(path: path, queryParams: queryParams, headers: headers)
        echo = try res.extract(type: EchoResponse.self)
        checkBodyResponse(method: .PATCH, echo: echo, hasBody: false)
    }
    
    func testOptionalExtract() throws {
        let request = Request(method: .GET, url: "http://localhost")
        let response = Response(statusCode: 404, body: samplePayloadData)
        let jsonResponse = JSONResponse(
            request: request,
            response: response,
            decoder: JSONDecoder(),
            treat400PlusAsError: true
        )
        // even if there is a body, the response 404, return nil
        let sample = try jsonResponse.extractOptional(type: SamplPayload.self)
        XCTAssertNil(sample)
    }
    
    func testTreat400PlusAsErrorOn() throws {
        let request = Request(method: .GET, url: "http://localhost")
        let response = Response(statusCode: 500, body: samplePayloadData)
        let jsonResponse = JSONResponse(
            request: request,
            response: response,
            decoder: JSONDecoder(),
            treat400PlusAsError: true
        )
        // even if there is a body, the response is 500, return nil
        XCTAssertThrowsError(try jsonResponse.extract(type: SamplPayload.self))
    }
    
    func testTreat400PlusAsErrorOff() throws {
        let request = Request(method: .GET, url: "http://localhost")
        let response = Response(statusCode: 500, body: samplePayloadData)
        let jsonResponse = JSONResponse(
            request: request,
            response: response,
            decoder: JSONDecoder(),
            treat400PlusAsError: false
        )
        let res = try jsonResponse.extract(type: SamplPayload.self)
        XCTAssertEqual(res, samplePayload)
    }
    
    private func checkBodyResponse(method: RequestMethod, echo: EchoResponse, hasBody: Bool, checkContentType: Bool = true) {
        let expectedHeaders = [
            "x-my-key": "some-key"
        ]
        if !echo.body.isEmpty && checkContentType {
            XCTAssertEqual(echo.headers["content-type"], "application/json")
        }
        let echoHeaders = ["x-my-key": echo.headers["x-my-key"]!]
        let expected = EchoResponse(
            path: "/my/json/path",
            headers: expectedHeaders,
            method: method.rawValue,
            body: hasBody ? samplePayloadJSON : "",
            query: queryParams
        )
        XCTAssertEqual(
            echo.copyHeaders(newHeaders: echoHeaders),
            expected
        )
    }
    
}
