//
//  BiometricIDAuthClass.swift
//  FaceID_Authentication
//
//  Created by Amit on 24/07/24.
//

import Foundation
import LocalAuthentication

class BiometricIDAuthClass {
    enum BiometricType {
        case none
        case touchID
        case faceID
        case unknown
    }
    
    enum BiometricError: LocalizedError {
        case authenticationFailed
        case userCancel
        case userFallback
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .authenticationFailed: return "There was a problem verifying your identity!"
            case .userCancel: return "You pressed cancel button!"
            case .userFallback: return "You pressed password!"
            case .biometryNotAvailable: return "Face/Touch ID is not available in that Device!"
            case .biometryNotEnrolled: return "Face/Touch ID is not set up in that Device!"
            case .biometryLockout: return "Face/Touch ID is locked!"
            case .unknown: return "Face/Touch ID may not be configured in current Device!"
            }
        }
    }
    
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    
    private var error: NSError?
    
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
         localizedReason: String = "Verifying your Identity",
         localizedFallbackTitle: String = "Enter App Password") {
        self.policy = policy
        self.localizedReason = localizedReason
        context.localizedFallbackTitle = localizedFallbackTitle
        context.localizedCancelTitle = "Touch me not"
    }
    
    func canEvaluate(completion: (Bool, BiometricType, BiometricError?) -> Void) {
        // Asks Context if it can evaluate a Policy
        // Passes an Error pointer to get error code in case of failure
        guard context.canEvaluatePolicy(policy, error: &error) else {
            // Extracts the LABiometryType from Context
            // Maps it to our BiometryType
            let type = biometricType(for: context.biometryType)
            // Unwraps Error
            // If not available, sends false for Success & nil in BiometricError
            guard let error = error else {
                return completion(false, type, nil)
            }
            // Maps error to our BiometricError
            return completion(false, type, biometricError(from: error))
        }
        // Context can evaluate the Policy
        completion(true, biometricType(for: context.biometryType), nil)
    }
    
    func evaluate(completion: @escaping (Bool, BiometricError?) -> Void) {
        // Asks Context to evaluate a Policy with a LocalizedReason
        context.evaluatePolicy(policy, localizedReason: localizedReason) { [weak self] success, error in
            // Moves to the main thread because completion triggers UI changes
            DispatchQueue.main.async {
                if success {
                    // Context successfully evaluated the Policy
                    completion(true, nil)
                } else {
                    // If not available, sends false for Success & nil for BiometricError
                    guard let error = error else { return completion(false, nil) }

                    completion(false, self?.biometricError(from: error as NSError))
                }
            }
        }
    }
    
    /*
     This function return the multiple type error which one related to Face/Touch ID
     */
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        return error
    }
    
    private func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .unknown
        }
    }
    

}
