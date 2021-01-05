//
//  String+Helpers.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public static var emailRegexString = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    func stringWithoutBlank() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var isValidEmail: Bool {
        return NSPredicate(format:"SELF MATCHES %@", String.emailRegexString).evaluate(with: self)
    }
        
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    public func toURL() -> URL {
        guard let apiURL = URL(string: self) else {
            fatalError("API URL is invalid")
        }
        return apiURL
    }
    
    func replace(with text: String, in range: NSRange) -> String? {
        guard range.location + range.length <= self.count else { return nil }
        return (self as NSString).replacingCharacters(in: range, with: text)
    }
    
    public func isURL() -> Bool {
       return URL(string: self) != nil
    }
    
    public  func isValidUrl() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}

extension StringProtocol where Index == String.Index {
    
    func nsRange(of string: String) -> NSRange? {
        guard let range = self.range(of: string) else {  return nil }
        return NSRange(range, in: self)
    }
    
    func caseInsensitiveRange(of string: String) -> NSRange? {
        return lowercased().nsRange(of: string.lowercased())
    }
}
