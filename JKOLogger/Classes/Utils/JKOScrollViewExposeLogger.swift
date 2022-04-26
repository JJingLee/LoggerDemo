//
//  JKOScrollViewExposeLogger.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/8/17.
//

import Foundation
public protocol JKOScrollViewExposeSubViewListener {
    var groupName : String? { get set }
}
public class JKOScrollViewExposeLogger {
    private weak var _logger : JKOLogger? = JKOLogger.default

    private var _listenedScrolls : [UIScrollView] = []

    private var listenerViews : [UIView] = []
    private var subviewsIsExposing : [Bool] = []
    private var scrollObservations : [NSKeyValueObservation] = []
    private var needTriggerEvent : Bool = true
    deinit {
        print("deinit \(type(of: self))")
    }

    /** 若只有一個ScrollView, 可直接把scrollview設定為targetView就好 */
    public init(_ targetView : UIView?=nil, logger : JKOLogger = JKOLogger.default, listenTo listenedScrolls : [UIScrollView] = []) {
        var subScrolls = listenedScrolls
        if let rootScroll = targetView as? UIScrollView {//兼容舊版
            if !subScrolls.contains(rootScroll) {subScrolls.append(rootScroll)}
        }
        _listenedScrolls = subScrolls
        _logger = logger
        listensScroll()
    }

    public func appendLoggerViewIfNotExist(_ view : UIView) {
        defer { objc_sync_exit(self.listenerViews) }
        objc_sync_enter(self.listenerViews)
        guard !listenerViews.contains(view) else {return}
        listenerViews.append(view)
        subviewsIsExposing.append(false)
    }

    private func getExposureState(_ index : Int)->Bool {
        defer { objc_sync_exit(self.subviewsIsExposing) }
        objc_sync_enter(self.subviewsIsExposing)
        guard self.subviewsIsExposing.count > index else { return false }
        return self.subviewsIsExposing[index]
    }

    private func setExposureState(_ index : Int, value : Bool) {
        defer { objc_sync_exit(self.subviewsIsExposing) }
        objc_sync_enter(self.subviewsIsExposing)
        guard self.subviewsIsExposing.count > index else { return }
        self.subviewsIsExposing[index] = value
    }

    private func listensScroll() {
        for scrollV in _listenedScrolls {
            let observation = scrollV.observe(\.contentOffset, options: .new, changeHandler: { [weak self](scroll, observedChange) in
                guard let self = self else {return}
                if !self.needTriggerEvent {return}
                self.sendEvent(scroll,with: observedChange.newValue)
            })
            self.scrollObservations.append(observation)
        }
    }
    public func setPauseEvents() {
        needTriggerEvent = false
    }
    public func setRestartEvents() {
        needTriggerEvent = true
    }
    public func resendExposureEvent(_ group: String? = nil) {
        objc_sync_enter(self.subviewsIsExposing)
        self.subviewsIsExposing = Array<Bool>.init(repeating: false, count: self.subviewsIsExposing.count)
        objc_sync_exit(self.subviewsIsExposing)
        for scroll in self._listenedScrolls {
            self.sendEvent(scroll, with: scroll.contentOffset, for: group)
        }
    }

    private func sendEvent(_ scrollView : UIScrollView, with offset:CGPoint?, for group: String? = nil) {
        let newVal = offset
        let scrollSize = scrollView.bounds.size
        let maxX : CGFloat = (newVal?.x ?? 0) + scrollSize.width
        let minX : CGFloat = newVal?.x ?? 0
        let maxY : CGFloat = (newVal?.y ?? 0) + scrollSize.height
        let minY : CGFloat = newVal?.y ?? 0

        var currentIndex = 0
        //check subViews is exposured or not
        objc_sync_enter(self.listenerViews)
        for subv in self.listenerViews {
            guard let subV = subv as? (UIView & JKOLoggerComponentProtocol) else {continue}
            let listenerSubView = subV as? JKOScrollViewExposeSubViewListener
            if let _group = group, listenerSubView?.groupName != _group {
                continue
            }
            
            //layout of subV relately on the scrollView
            let zeroCoor = subV.convert(CGPoint.zero, to: scrollView)
            let maxCoor = CGPoint(x: zeroCoor.x+subV.bounds.width, y: zeroCoor.y+subV.bounds.height)
            let subvSize = subV.bounds.size
            //keep a buffer for reuse components, reuse components would produce slower than it's actually apear on the screen
            let xBuffer : CGFloat = subvSize.width * 0.1
            let yBuffer : CGFloat = subvSize.height * 0.1
            let xIntheRange = (zeroCoor.x >= minX && zeroCoor.x < (maxX-xBuffer)) || (maxCoor.x > (minX+xBuffer) && maxCoor.x <= maxX)
            let yIntheRange = (zeroCoor.y >= minY && zeroCoor.y < (maxY-yBuffer)) || (maxCoor.y > minY && maxCoor.y <= (maxY+yBuffer))
            if xIntheRange && yIntheRange {
            // if is exposure
                guard self.subviewsIsExposing.count > currentIndex else { continue }
                if !self.getExposureState(currentIndex) {
                    let module = subV.module ?? ""
                    let description = subV.componentDescription ?? ""
                    let property : [String:Any] = subV.properties ?? [:]
                    self._logger?.viewEvent(with: JKOLoggerStruct(module: module, componentDescription: description, componentHashKey: subV.componentHashKey ?? "", properties: property))
                    self.setExposureState(currentIndex, value: true)
                }
            }else {
            //if not exposure
                guard self.subviewsIsExposing.count > currentIndex else { continue }
                self.setExposureState(currentIndex, value: false)
            }

            currentIndex += 1
        }
        objc_sync_exit(self.listenerViews)
    }

    public func despose() {
        listenerViews = []
        for observer in scrollObservations {
            observer.invalidate()
        }
        scrollObservations = []
    }
}


