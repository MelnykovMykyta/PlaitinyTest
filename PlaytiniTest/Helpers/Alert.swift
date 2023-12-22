//
//  Alert.swift
//  PlaytiniTest
//
//  Created by Nikita Melnikov on 22.12.2023.
//

import Foundation
import UIKit

class Alert {
    
    static func showAlert(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Start", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first {
                if let viewController = window.rootViewController {
                    viewController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
