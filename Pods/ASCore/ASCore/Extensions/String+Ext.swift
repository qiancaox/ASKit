//  String+Ext.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import Foundation
import UIKit.UIFont
import CommonCrypto

public extension String {
    
    subscript(r: Range<Int>) -> String {
        let siOffset = min(count - 1, max(0, r.lowerBound))
        let eiOffset = min(count - 1, max(0, r.upperBound))
        let si = index(startIndex, offsetBy: siOffset)
        let ei = index(startIndex, offsetBy: eiOffset)
        return String(self[si..<ei])
    }
    
    subscript(r: ClosedRange<Int>) -> String {
        let siOffset = min(count - 1, max(0, r.lowerBound))
        let eiOffset = min(count - 1, max(0, r.upperBound))
        let si = index(startIndex, offsetBy: siOffset)
        let ei = index(startIndex, offsetBy: eiOffset)
        return String(self[si...ei])
    }
    
    subscript(x: Int) -> String {
        return self[x...x]
    }
    
}

public extension String {
    
    /// Returns the size of the string if it were rendered with the specified constraints.
    /// - Parameters:
    ///   - font: The font to use for computing the string size.
    ///   - size: The maximum acceptable size for the string. This value is
    ///   used to calculate where line breaks and wrapping would occur.
    ///   - mode: The line break options for computing the size of the string.
    ///   For a list of possible values, see NSLineBreakMode.
    /// - Returns: The size the resulting string's bounding box. These values
    /// may be rounded up to the nearest whole number.
    func size(for font: UIFont, constraintSize size: CGSize, lineBreakMode mode: NSLineBreakMode) -> CGSize {
        var result = CGSize.zero
        var attr: [NSAttributedString.Key : Any] = [.font : font]
        if mode != .byWordWrapping {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = mode
            attr[.paragraphStyle] = paragraphStyle
        }
        result = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                   attributes: attr, context: nil).size
        return result
    }
    
    
    /// Returns the height of the string if it were rendered with the specified constraints.
    /// - Parameters:
    ///   - font: The font to use for computing the string size.
    ///   - width: The maximum acceptable width for the string. This value is used
    ///   to calculate where line breaks and wrapping would occur.
    ///   - mode: The line break options for computing the size of the string.
    ///   For a list of possible values, see NSLineBreakMode.
    /// - Returns: The height of the resulting string's bounding box. These values
    /// may be rounded up to the nearest whole number.
    func height(for font: UIFont, maxWidth width: CGFloat, lineBreakMode mode: NSLineBreakMode) -> CGFloat {
        let constraintSize = CGSize(width: width, height: 0)
        let size = self.size(for: font, constraintSize: constraintSize, lineBreakMode: mode)
        return size.height
    }
    
    
    /// Returns the width of the string if it were to be rendered with the specified
    /// font with constant height.
    /// - Parameters:
    ///   - font: The font to use for computing the string width.
    ///   - height: The constant height for string to use for computing the string width.
    ///   - mode: The line break options for computing the size of the string.
    ///   For a list of possible values, see NSLineBreakMode.
    /// - Returns: The width of the resulting string's bounding box. These values may be
    /// rounded up to the nearest whole number.
    func width(for font: UIFont, maxHeight height: CGFloat, lineBreakMode mode: NSLineBreakMode) -> CGFloat {
        let constraintSize = CGSize(width: 0, height: height)
        let size = self.size(for: font, constraintSize: constraintSize, lineBreakMode: mode)
        return size.width
    }
    
}

public extension String {
    
    /// Returns a lowercase NSString for md5 hash.
    func md5String() -> String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    
    /// Encoding using utf8.
    func data() -> Data? {
        return data(using: .utf8)
    }
    
}

public extension String {
    
    /// Whether it can match the regular expression.
    /// - Parameters:
    ///   - regex: The regular expression.
    ///   - options: The matching options to report.
    /// - Returns: YES if can match the regex; otherwise, NO.
    func matches(regex: String, options: NSRegularExpression.Options) -> Bool {
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else {
            return false
        }
        return pattern.numberOfMatches(in: self, options: .reportProgress, range: NSMakeRange(0, count)) > 0
    }
    
    
    func isPhoneNumber() -> Bool {
        let regex = "^1[3|4|5|7|8][0-9]\\d{8}$"
        return matches(regex: regex, options: .caseInsensitive)
    }
    
    
    func isEmailAddress() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return matches(regex: regex, options: .caseInsensitive)
    }
    
    
    func isURLLink() -> Bool {
        let regex = "http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?"
        return matches(regex: regex, options: .caseInsensitive)
    }
    
}

public extension String {
    
    /// Trim blank characters (space and newline) in head and tail.
    func trimed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Not empty or nil.
    func isExist() -> Bool {
        return count > 0
    }
    
}
