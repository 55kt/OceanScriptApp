//
//  SupportMailManager.swift
//  OceanScript
//
//  Created by Vlad on 7/5/25.
//

import Foundation
import MessageUI
import SwiftUI

// MARK: - Class
/// Manages the sending of support emails using MFMailComposeViewController.
class SupportMailManager: NSObject {
    // MARK: - Properties
    private var completion: ((Result<Void, Error>) -> Void)?
    
    // MARK: - Methods
    
    /// Sends a support email with the specified message to the recipient.
    /// - Parameters:
    ///   - message: The message to include in the email.
    ///   - recipient: The email address of the recipient.
    ///   - completion: A closure called with the result of the email sending operation.
    func sendSupportEmail(message: String, recipient: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.completion = completion
        
        if !MFMailComposeViewController.canSendMail() {
            completion(.failure(SupportMailError.deviceCannotSendMail))
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([recipient])
        mailComposer.setSubject("Support Request - OceanScript")
        mailComposer.setMessageBody(message, isHTML: false)
        
        // Present the mail composer using the top view controller
        if let topViewController = topViewController() {
            topViewController.present(mailComposer, animated: true, completion: nil)
        } else {
            completion(.failure(SupportMailError.noRootViewController))
        }
    }
    
    // MARK: - Private Methods
    
    /// Finds the topmost view controller to present the mail composer.
    /// - Returns: The topmost view controller, or nil if not found.
    private func topViewController() -> UIViewController? {
        // Get the active window scene
        guard let windowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first as? UIWindowScene else {
            return nil
        }
        
        // Get the windows for the scene
        guard let window = windowScene.windows.first else {
            return nil
        }
        
        // Start with the root view controller
        var topController = window.rootViewController
        
        // Traverse the view controller hierarchy to find the topmost presented controller
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SupportMailManager: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if let error = error {
                self.completion?(.failure(error))
                return
            }
            
            switch result {
            case .sent:
                self.completion?(.success(()))
            case .cancelled:
                break // Do not treat cancellation as an error
            case .saved:
                self.completion?(.failure(SupportMailError.userSavedDraft))
            case .failed:
                self.completion?(.failure(SupportMailError.sendFailed))
            @unknown default:
                self.completion?(.failure(SupportMailError.unknownResult))
            }
        }
    }
}

// MARK: - Errors
/// Errors that can occur during the email sending process.
enum SupportMailError: Error {
    case deviceCannotSendMail
    case noRootViewController
    case userSavedDraft
    case sendFailed
    case unknownResult
}
