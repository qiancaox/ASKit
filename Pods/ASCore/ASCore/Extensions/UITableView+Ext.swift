//  UITableView+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import UIKit

public extension UITableView {
    
    /// Perform a series of method calls that insert, delete, or select rows and
    /// sections of the receiver.
    func update(usingBlock block: (UITableView) -> Void) {
        beginUpdates()
        block(self)
        endUpdates()
    }
    
    
    /// Reload row at indexPath with animation.
    func reloadRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        reloadRows(at: [indexPath], with: animation)
    }
    
    
    /// Reload row in section with animation.
    func reloadRow(at row: UInt, in section: UInt, with animation: UITableView.RowAnimation) {
        if section >= numberOfSections || row >= numberOfRows(inSection: Int(section)) {
            return
        }
        let indexPath = IndexPath(row: Int(row), section: Int(section))
        reloadRow(at: indexPath, with: animation)
    }
    
    
    /// Insert row at indexPath with animation.
    func insertRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        insertRows(at: [indexPath], with: animation)
    }
    
    
    /// Insert row in section with animation.
    func insertRow(at row: UInt, in section: UInt, with animation: UITableView.RowAnimation) {
        if section >= numberOfSections || row > numberOfRows(inSection: Int(section)) {
            return
        }
        let indexPath = IndexPath(row: Int(row), section: Int(section))
        insertRow(at: indexPath, with: animation)
    }
    
    
    /// Inserts a section in the receiver.
    func insertSections(_ section: UInt, with animation: UITableView.RowAnimation) {
        let sections = IndexSet(integer: IndexSet.Element(section))
        insertSections(sections, with: animation)
    }
    
    
    /// Delete row at indexPath with animatioin.
    func deleteRow(at indexPath: IndexPath, with animation: UITableView.RowAnimation) {
        deleteRows(at: [indexPath], with: animation)
    }
    
    
    /// Delete row in section with animation.
    func deleteRow(at row: UInt, in section: UInt, with animation: UITableView.RowAnimation) {
        if section >= numberOfSections || row >= numberOfRows(inSection: Int(section)) {
            return
        }
        let indexPath = IndexPath(row: Int(row), section: Int(section))
        deleteRow(at: indexPath, with: animation)
    }
    
    
    /// Delete a section in the reciver.
    func deleteSections(_ section: UInt, with animation: UITableView.RowAnimation) {
        let sections = IndexSet(integer: IndexSet.Element(section))
        deleteSections(sections, with: animation)
    }
    
}

public extension UITableView {
    
    
    /// Scroll to row in section at scroll position with animated.
    func scroll(to row: UInt, in section: UInt, at scrollPosition: UITableView.ScrollPosition, with animated: Bool) {
        if section >= numberOfSections || row >= numberOfRows(inSection: Int(section)) {
            return
        }
        let indexPath = IndexPath(row: Int(row), section: Int(section))
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}
