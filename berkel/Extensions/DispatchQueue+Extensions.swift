//
//  DispatchQueue+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Foundation

extension DispatchQueue {

    static func delay(_ milliseconds: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: closure)
    }
}

extension DispatchQueue {
    
    class func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }

    class func mainSyncSafe<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try work()
        } else {
            return try DispatchQueue.main.sync(execute: work)
        }
    }

    // FOR JUST DEBUG MODE
    static var currentLabel: String {
        #if DEBUG || Debug || debug
            return String(validatingUTF8: __dispatch_queue_get_label(nil))!
        #else
            return "This variable is only used for debug mode"
        #endif
    }
}
