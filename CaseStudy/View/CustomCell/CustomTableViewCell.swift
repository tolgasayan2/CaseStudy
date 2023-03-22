//
//  CustomTableViewCell.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  static let identifier = "CustomTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
