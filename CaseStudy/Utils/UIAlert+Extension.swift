//
//  UIAlert+Extension.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 24.03.2023.
//

import Foundation
import UIKit

extension UIAlertController {
  func makeAlert(title: String?, message: String?) -> Self {
    let title = title.stringValue
    let message = message.stringValue
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    return alert as! Self
  }
}
