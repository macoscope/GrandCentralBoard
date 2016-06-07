platform :tvos, '9.0'
use_frameworks!

target "GrandCentralBoard" do
 pod 'Alamofire', '~> 3.0'
 pod 'Decodable', '~> 0.4'
 pod 'MD5', '~> 0.1'
 pod 'GCBCore', '~> 1.0'
 pod 'GCBUtilities', :path => './'
 pod 'Operations', '~> 2.9'
 pod 'Moya/RxSwift', '~> 6.4'
 pod 'SlackKit', :git => "https://github.com/michallaskowski/SlackKit", :branch => "add-tv-os-to-podspec"
 
 target "GrandCentralBoardTests" do
     inherit! :search_paths
     pod 'Nimble', '~> 4.0'
     pod 'OHHTTPStubs', '~> 5.0'
     pod 'OHHTTPStubs/Swift', '~> 5.0'
     pod 'FBSnapshotTestCase', :git => "https://github.com/facebook/ios-snapshot-test-case"
 end
end
