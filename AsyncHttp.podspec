Pod::Spec.new do |spec|
    spec.swift_versions = ['5.5']
    spec.name         = 'AsyncHttp'
    spec.version      = '1.1.2'
    spec.license      =  { :type => 'MIT' }
    spec.homepage     = 'https://github.com/kperson/swift-async-http'
    spec.authors      = 'Kelton Person'
    spec.summary      = 'Swift Async Http is a basic async HTTP client that wraps URLSession and URLRequest'
    spec.source       = { :git => 'https://github.com/kperson/swift-async-http.git', :tag => '1.1.2' }
    spec.source_files = 'Source/*.{swift}'
    spec.requires_arc = true
    spec.ios.deployment_target = '13.0'
    spec.tvos.deployment_target = '13.0'
    spec.osx.deployment_target = '12.0'
    spec.watchos.deployment_target = '6.0'
  end
