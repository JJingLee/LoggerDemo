//
//  JKOLogger.swift
//  FBSnapshotTestCase
//
//  Created by chiehchun.lee on 2020/8/17.
//

import Foundation

public class JKOLogger : JKOLoggerInterfaceProtocol {
    private var displayEventBlackList: [NSRegularExpression] = []
    public static let reserveKey : String = "hashkey"
    public static let `default` : JKOLogger = JKOLogger()
    public var loggerImp : JKOSLoggerImpProtocol = JKOSLoggerImpShell()
    ///Could be sets for prevent from duplicate log's timeInterval, default as 2
    public var viewEventUnrepeatTime : TimeInterval = 2

    ///Custom implementation of log ability. Must called before launch.
    public func customImp(_ imp : JKOSLoggerImpProtocol) {
        loggerImp = imp
    }
    /// Must launch at AppDelegate:didFinishLaunch
    public func launch(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        loggerImp.launch(launchOptions)
        setupDisplayEventBlackList()
    }
    
    private func setupDisplayEventBlackList() {
        if let uiKitRegex = try? NSRegularExpression(pattern: "UI[A-Za-z0-9]+", options: []) {
            displayEventBlackList.append(uiKitRegex)
        }
        
        if let nav = try? NSRegularExpression(pattern: "[A-Za-z0-9]+NavigationController", options: []) {
            displayEventBlackList.append(nav)
        }
        
        if let jkosTabBar = try? NSRegularExpression(pattern: "JKOSTabBarHandler", options: []) {
            displayEventBlackList.append(jkosTabBar)
        }
    }
    
    public func addDisplayEventBlackListRegexPattern(_ pattern: String) {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            displayEventBlackList.append(regex)
        }
    }
    
    public func validateDisplayPageName(_ pageName: String?) -> Bool {
        guard !displayEventBlackList.isEmpty else { return true }
        return displayEventBlackList.allSatisfy({ (regex) -> Bool in
            if let _ = regex.firstMatch(in: pageName ?? "", options: [], range: NSRange(location: 0, length: pageName?.count ?? 0)) {
                return false
            }
            return true
        })
    }

    /// No need for bothering about the timing that you sends display, and also covering source property for you.
    public func setDisplayEventAsAutoSend() {
        UIViewController.JKOLoggerUIViewControllerSwizzle()
    }

    //MARK: - global parameter
    /// Set user ID, for all the event. set nil when logout
    public func setUserIdentify(_ userId : String?) {
        loggerImp.setUserIdentify(userId)
    }
    /// Set user properties, for all the event.
    public func setUserProperties(_ properties : [String:Any]?) {
        loggerImp.setUserProperties(properties)
    }

    //MARK: - send events
    /// Click log.
    public func clickEvent(with eventStruct : JKOLoggerStruct) {
        let module:String = eventStruct.module ?? "",
        description:String = eventStruct.componentDescription ?? "",
        properties:[String:Any] = eventStruct.properties ?? [:]

        let name = self.eventKeyName(with: "click", module: module, description: description)
        loggerImp.sendEvent(eventName: name, properties: properties)
    }

    private var viewEventCache = NSCache<NSString,NSDate>()
    /// View event. ComponentHashKey must required. "viewEventUnrepeatTime" could be sets for prevent from duplicate log's timeInterval, default as 2.
    public func viewEvent(with eventStruct : JKOLoggerStruct) {
        let module:String = eventStruct.module ?? "",
        description:String = eventStruct.componentDescription ?? "",
        properties:[String:Any] = eventStruct.properties ?? [:],
        hashKey = eventStruct.componentHashKey ?? ""

        //cache handles
        var props = properties
        if hashKey.count > 0 {
            props[JKOLogger.reserveKey] = hashKey
        }
        let cacheKey = self.eventCacheKeyName(with: "view", module: module, description: description, properties: props)
        let current = NSDate()
        if let time = viewEventCache.object(forKey: cacheKey as NSString) {
            guard (current.timeIntervalSince1970 - time.timeIntervalSince1970) > viewEventUnrepeatTime else {
                return
            }
        }
        viewEventCache.setObject(current, forKey: cacheKey as NSString)

        //send event
        let name = self.eventKeyName(with: "view", module: module, description: description)
        loggerImp.sendEvent(eventName: name, properties: properties)
    }

    ///ViewController display event. would autoSending when setDisplayEventAsAutoSend() been called.
    public func displayEvent(with eventStruct:JKOLoggerDisplayStruct) {
        let name = self.eventKeyName(with: "display", module: eventStruct.module ?? "", description: eventStruct.componentDescription ?? "")
        loggerImp.sendEvent(eventName: name, properties: eventStruct.properties ?? [:])

    }
    public func disapearEvent(with eventStruct:JKOLoggerDisplayStruct) {
        let name = self.eventKeyName(with: "disappear", module: eventStruct.module ?? "", description: eventStruct.componentDescription ?? "")
        loggerImp.sendEvent(eventName: name, properties: eventStruct.properties ?? [:])
    }

    public func scrollEvent(with eventStruct:JKOLoggerDisplayStruct) {
        let name = self.eventKeyName(with: "scroll", module: eventStruct.module ?? "", description: eventStruct.componentDescription ?? "")
        loggerImp.sendEvent(eventName: name, properties: eventStruct.properties ?? [:])
    }
    public func inputEvent(with eventStruct:JKOLoggerDisplayStruct) {
        let name = self.eventKeyName(with: "input", module: eventStruct.module ?? "", description: eventStruct.componentDescription ?? "")
        loggerImp.sendEvent(eventName: name, properties: eventStruct.properties ?? [:])
    }
    ///Developer event, aka. monitor event.
    public func devEvent(with eventStruct : JKOLoggerStruct) {
        let module:String = eventStruct.module ?? "",
        description:String = eventStruct.componentDescription ?? "",
        properties:[String:Any] = eventStruct.properties ?? [:]

        let name = self.eventKeyName(with: "monitor", module: module, description: description)
        loggerImp.sendEvent(eventName: name, properties: properties)

    }

    ///Uploads queued data to the Mixpanel server.
    public func sendImediately() {
        loggerImp.sendImediately()
    }

    private func eventKeyName(with typeName:String, module:String, description:String)->String {
        let key = "\(typeName)_\(module)_\(description)".trimmingCharacters(in: CharacterSet.init(charactersIn: "_"))
        return key
    }

    private func eventCacheKeyName(with typeName:String, module:String, description:String, properties:[String:Any])->String {
        var key = "\(typeName)_\(module)_\(description)"
        if let _hashKey = properties[JKOLogger.reserveKey] as? String {
            key = key + "_\(_hashKey)"
        }
        key = key.trimmingCharacters(in: CharacterSet.init(charactersIn: "_"))
        return key
    }
}
