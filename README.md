# Swift Async Http

**Swift Async Http is a basic async HTTP client that wraps URLSession and URLRequest.**

[![CircleCI](https://circleci.com/gh/kperson/swift-async-http/tree/master.svg?style=svg)](https://circleci.com/gh/kperson/swift-async-http/?branch=master)

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

## TODO
 - add cocoapod support
 - add installation documentation