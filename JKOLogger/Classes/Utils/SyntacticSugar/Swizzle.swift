//
//  Swizzle.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/11/5.
//

import Foundation
public class SwizzleTool {
    public class func swizzle(_ target:AnyClass, _ originalSelector:Selector, _ swizzledSelector:Selector) {
        guard let originalMethod = class_getInstanceMethod(target, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(target, swizzledSelector) else { return }

        let didAddMethod = class_addMethod(target, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(target, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }

    public class func classSwizzle(_ target:AnyClass, _ originalSelector:Selector, _ swizzledSelector:Selector) {
        guard let originalMethod = class_getClassMethod(target, originalSelector) else { return }
        guard let swizzledMethod = class_getClassMethod(target, swizzledSelector) else { return }

        let didAddMethod = class_addMethod(target, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(target, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}
