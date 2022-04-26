//
//  JKOSLoggerImp.swift
//  FBSnapshotTestCase
//
//  Created by chiehchun.lee on 2020/8/17.
//

import Foundation
//import Mixpanel

class JKOSLoggerImpShell: JKOSLoggerImpProtocol {
    func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        //initial logger tool
        print("JKOSLoggerImp initial")
//        mixpanel = Mixpanel.initialize(token: mixpanelToken, launchOptions: launchOptions)
    }

    func setUserIdentify(_ userId : String?) {
//        if (userId ?? "").count == 0 { mixpanel?.reset() }
//        mixpanel?.optInTracking()
//        mixpanel?.identify(distinctId: userId ?? "")
//        mixpanel?.userId = userId ?? ""
    }

    func setUserProperties(_ properties : [String:Any]?) {
//        guard let props = properties else {return}
//        mixpanel?.people.set(properties: props as! [String: MixpanelType])
    }

    func sendEvent(eventName: String, properties:[String:Any]) {
        //send event
        print("mixpanel sendEvent \(eventName), withProp:\(properties)")
//        if let propers = properties as? Properties {
//            mixpanel?.track(event: eventName, properties: propers)
//        }
    }

    func sendImediately() {
//        mixpanel?.flush()
    }
}
