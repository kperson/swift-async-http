# Swift Async Http

**Swift Async Http is a basic async HTTP client that wraps URLSession and URLRequest.
This client works with iOS, tvOS, macOS, watchOS, and Linux.**


[![CircleCI](https://circleci.com/gh/kperson/swift-async-http/tree/master.svg?style=svg)](https://circleci.com/gh/kperson/swift-async-http/?branch=master)

## Cocoapod Installation
Add the following to your Podfile.
```
pod 'AsyncHttp'
```

## Swift Package Installation
Add the following to your Package.
```
.package(url: "https://github.com/kperson/swift-async-http.git", .upToNextMajor(from: "1.0.0"))
```


## Basic Usuage
```swift
import AsyncHttp

let client = HttpClient()
// you may specify session (URLSession), cachePolicy, and timeoutInterval optionaly for the client

let request = Request(
    method : .POST,
    url: "https://www.example.com/my-path",
    headers: ["k" : "v"]
    body: Data()
)
// you can override session (URLSession), cachePolicy, and timeoutInterval for reach request if you like by providing extra parameters

let response = try await client.fetch(request)
print(response.statusCode)
print(response.headers["some_header"]) //NOTE: headers are case insenstive
print(response.headers["some_HEADER"]) //NOTE: headers are case insenstive
//the above two lines are equivalent
```

## Request Builder
```swift
import AsyncHttp

let builder = RequestBuilder(
    method: .GET, 
    url: "https://www.example.com/my-path"
)
builder.addHeader(field: "k", value: "v")
builder.addQueryParam(nane: "q", value: "hello")
// you may also specify body, session (URLSession), cachePolicy, and timeoutInterval
let request = builder.build()
let response = try await client.fetch(request)
print(response.statusCode)
```
