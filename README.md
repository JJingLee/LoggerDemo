# JKOLogger

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Architecture
### JKOLogger
JKOLogger user Interface, handles JKOLogger specific bussiness logic.
    
```swift
public class JKOLogger {

    public static let reserveKey: String

    public static let `default`: JKOLogger

    public var loggerImp: JKOSLoggerImpProtocol

    ///Could be sets for prevent from duplicate log's timeInterval, default as 2
    public var viewEventUnrepeatTime: TimeInterval

    ///Custom implementation of log ability. Must called before launch.
    public func customImp(_ imp: JKOSLoggerImpProtocol)

    /// Must launch at AppDelegate:didFinishLaunch
    public func launch(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?)

    /// No need for bothering about the timing that you sends display, and also covering source property for you.
    public func setDisplayEventAsAutoSend()

    /// Set user ID, for all the event. set nil when logout
    public func setUserIdentify(_ userId: String?)

    /// Set user properties, for all the event.
    public func setUserProperties(_ properties: [String : Any]?)

    /// Click log.
    public func clickEvent(with eventStruct: JKOLoggerStruct)

    /// View event. ComponentHashKey must required. "viewEventUnrepeatTime" could be sets for prevent from duplicate log's timeInterval, default as 2.
    public func viewEvent(with eventStruct: JKOLoggerStruct)

    ///ViewController display event. would autoSending when setDisplayEventAsAutoSend() been called.
    public func displayEvent(with eventStruct: JKOLoggerDisplayStruct)

    ///Developer event, aka. monitor event.
    public func devEvent(with eventStruct: JKOLoggerStruct)

    ///Uploads queued data to the Mixpanel server.
    public func sendImediately()
}
```
    
    
### JKOSLoggerImpProtocol
JKOLogger's Imp default as JKOS mixpanel implement, you can custom your own Implement by fullfilling `JKOSLoggerImpProtocol`, and set by `JKOLogger:customImp(_ imp :)`
```swift
@objc public protocol JKOSLoggerImpProtocol {
    func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)

    func setUserIdentify(_ userId: String?)

    func setUserProperties(_ properties: [String : Any]?)

    func sendEvent(eventName: String, properties: [String : Any])

    func sendImediately()
}
```
### Utils
#### `display Utils`, auto collect source page, will auto collect in 'source' key of event properties. set through: 
```swift
    JKOLogger.default.setDisplayEventAsAutoSend()
```
#### `JKOScrollViewExposeLogger`, scrollViews' exposure is a annoying thing, this utils solve your trouble here.
```swift
//initial
var logger : JKOScrollViewExposeLogger?
logger = JKOScrollViewExposeLogger(table)

//add as logged view
logger?.appendLoggerViewIfNotExist(headerView)

//despose, may not cause leak in most cases, but might cause crash in the momoent that observer not been released.
logger?.despose()
```

## Requirements

## Installation

```ruby
pod 'JKOLogger', :git => 'http://gitlab.jkopay.com.tw/Source/IOS/JKOLogger.git'
```

