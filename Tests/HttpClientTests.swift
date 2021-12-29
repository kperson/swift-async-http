import Foundation
import XCTest
@testable import AsyncHttp

struct EchoResponse: Codable {
    
    let path: String
    let headers: [String : String]
    let method: String
    let body: String
    
}

class HttpClientTests: XCTestCase {
    
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
    
    override class func setUp() {
        super.setUp()
        if !echoIsRunning {
            removeContainers()
            startContainers()
        }
        Thread.sleep(forTimeInterval: 1)
    }
    
    override class func tearDown() {
        super.tearDown()
        if !echoIsRunning {
            removeContainers()
        }
    }
    
    static private func startContainers() {
        shell("\(docker) run --rm -d --name=http-echo -p \(testingPort):80 mendhak/http-https-echo")
    }
    
    static private func removeContainers() {
        shell("\(docker) rm -f http-echo")
    }
        
    static private var docker: String {
        ProcessInfo.processInfo.environment["DOCKER_EXECUTABLE"] ?? "/usr/local/bin/docker"
    }
    
    static private var testingPort: String {
        ProcessInfo.processInfo.environment["TESTING_PORT"] ?? "9001"
    }
    
    static private var testingHost: String {
        ProcessInfo.processInfo.environment["TESTING_HOST"] ?? "localhost"
    }
    
    static private var echoIsRunning: Bool {
        ProcessInfo.processInfo.environment["ECHO_IS_RUNNING"] == "1"
    }
    
    static private var url: String {
        return "http://\(testingHost):\(testingPort)\(path)"
    }
    
    static private var path: String {
        return "/my-path"
    }
    
    @discardableResult private static func shell(_ command: String, traceId: String? = nil) -> (Bool, String) {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()
        
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        task.waitUntilExit()
        let exitStatus = task.terminationStatus
        return (exitStatus == 0, output)
    }
    
}
