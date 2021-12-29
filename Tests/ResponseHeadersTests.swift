import Foundation
import XCTest
@testable import AsyncHttp

class ResponderHeaderTests: XCTestCase {
    
    func testHeaderCase() {
        let headers = ResponseHeaders(dict: ["HeLlO": "world"])
        XCTAssertEqual(headers["hello"], "world")
        XCTAssertEqual(headers["HELLO"], "world")
        XCTAssertNil(headers["ABC"])
    }
    
}
