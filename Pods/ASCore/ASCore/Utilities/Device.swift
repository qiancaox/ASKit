//  Device.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public struct Device {
    
    /// Shortcut of UIDevice.current.
    public static let Current = UIDevice.current
    /// Shortcut of UIDevice.current.systemVersion.
    public static let Version = Current.systemVersion
    /// The machine model associate key.
    private static var machineModelAssociateKey = 0
    /// The screen type associate key.
    private static var isFullScreenAssociateKey = 1
    
    /// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
    /// - See http://theiphonewiki.com/wiki/Models
    public static func machineModel() -> String {
        if let machineModel = objc_getAssociatedObject(self, &machineModelAssociateKey) as? String {
            return machineModel
        }
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let machineModel = String(cString: machine)
        objc_setAssociatedObject(self, &machineModelAssociateKey, machineModel, .OBJC_ASSOCIATION_COPY)
        return machineModel
    }
    
    
    /// The device's screen is full type.
    /// - Device is iPhoneX or later returns true, otherwise false.
    public static func isFullScreen() -> Bool {
        if let flag = objc_getAssociatedObject(self, &isFullScreenAssociateKey) as? Bool {
            return flag
        }
        let model = machineModel()
        let fullScreenMachinModels = ["iPhone10,3", "iPhone10,6", "iPhone11,8", "iPhone11,2",
                                      "iPhone11,6", "iPhone12,1", "iPhone12,3", "iPhone12,5"]
        let flag = fullScreenMachinModels.contains(model)
        objc_setAssociatedObject(self, &isFullScreenAssociateKey, flag, .OBJC_ASSOCIATION_ASSIGN)
        return flag
    }
    
}
