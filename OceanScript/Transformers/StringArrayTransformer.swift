//
//  StringArrayTransformer.swift
//  OceanScript
//
//  Created by Vlad on 27/4/25.
//

import Foundation

@objc(StringArrayTransformer)
class StringArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSString.self]
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            print("🚨 Failed to transform value to Data in StringArrayTransformer 🚨")
            return nil
        }
        do {
            let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data)
            return array
        } catch {
            print("🚨 Error unarchiving array in StringArrayTransformer: \(error) 🚨")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else {
            print("🚨 Failed to reverse transform value to [String] in StringArrayTransformer 🚨")
            return nil
        }
        do {
            let nsArray = NSArray(array: array)
            let data = try NSKeyedArchiver.archivedData(withRootObject: nsArray, requiringSecureCoding: true)
            return data
        } catch {
            print("🚨 Error archiving array in StringArrayTransformer: \(error) 🚨")
            return nil
        }
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName(rawValue: "StringArrayTransformer"))
    }
}
