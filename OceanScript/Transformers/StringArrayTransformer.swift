//
//  StringArrayTransformer.swift
//  OceanScript
//
//  Created by Vlad on 27/4/25.
//

import Foundation

// MARK: - Class
/// A value transformer for converting an array of strings to Data and back for Core Data.
@objc(StringArrayTransformer)
class StringArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    // MARK: - Properties
    
    /// The allowed top-level classes for unarchiving.
    override static var allowedTopLevelClasses: [AnyClass] {
        [NSArray.self, NSString.self]
    }
    
    // MARK: - Transformer Methods
    
    /// The class of the transformed value.
    override class func transformedValueClass() -> AnyClass {
        NSArray.self
    }
    
    /// Indicates whether reverse transformation is supported.
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    /// Transforms Data into an array of strings.
    /// - Parameter value: The Data to transform.
    /// - Returns: The transformed array of strings, or nil if transformation fails.
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            logError("Failed to transform value to Data")
            return nil
        }
        do {
            let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data)
            return array
        } catch {
            logError("Error unarchiving array: \(error)")
            return nil
        }
    }
    
    /// Transforms an array of strings into Data.
    /// - Parameter value: The array of strings to transform.
    /// - Returns: The transformed Data, or nil if transformation fails.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else {
            logError("Failed to reverse transform value to [String]")
            return nil
        }
        do {
            let nsArray = NSArray(array: array)
            let data = try NSKeyedArchiver.archivedData(withRootObject: nsArray, requiringSecureCoding: true)
            return data
        } catch {
            logError("Error archiving array: \(error)")
            return nil
        }
    }
    
    // MARK: - Static Methods
    
    /// Registers the transformer with Core Data.
    static func register() {
        ValueTransformer.setValueTransformer(StringArrayTransformer(), forName: NSValueTransformerName(rawValue: "StringArrayTransformer"))
    }
    
    // MARK: - Logging Helpers
    
    /// Logs an error message.
    /// - Parameter message: The error message to log.
    private func logError(_ message: String) {
        #if DEBUG
        print("❌ StringArrayTransformer: \(message)")
        #endif
    }
} // StringArrayTransformer
