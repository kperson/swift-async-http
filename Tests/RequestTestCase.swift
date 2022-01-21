import Foundation
import XCTest
@testable import AsyncHttp

struct EchoResponse: Codable, Equatable {
    
    let path: String
    let headers: [String : String]
    let method: String
    let body: String
    let query: [String : String]
    
    func copyHeaders(newHeaders: [String : String]) -> EchoResponse {
        EchoResponse(path: path, headers: newHeaders, method: method, body: body, query: query)
    }
    
}

class RequestTestCase: XCTestCase {
     
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
    
    static var testingPort: String {
        ProcessInfo.processInfo.environment["TESTING_PORT"] ?? "9001"
    }
    
    static var testingHost: String {
        ProcessInfo.processInfo.environment["TESTING_HOST"] ?? "localhost"
    }
    
    static private var echoIsRunning: Bool {
        ProcessInfo.processInfo.environment["ECHO_IS_RUNNING"] == "1"
    }
    
    @discardableResult private static func shell(_ command: String, traceId: String? = nil) -> (Bool, String) {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        try! task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        task.waitUntilExit()
        let exitStatus = task.terminationStatus
        return (exitStatus == 0, output)
    }
    
}
