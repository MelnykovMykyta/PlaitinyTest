//
//  VCChanger.swift
//  PlaytiniTest
//
//  Created by Nikita Melnikov on 22.12.2023.
//

import Foundation
import UIKit

class VCChanger {
    
    static func changeVC(vc: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UINavigationController(rootViewController: vc)
            window.makeKeyAndVisible()
        }
    }
}
