//
//  CustomTableViewCell.swift
//  CaseStudy
//
//  Created by Tolga Sayan on 20.03.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
  static let identifier = "CustomTableViewCell"
  
  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 5
    return stackView
  }()
  
  private var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.contentMode = .right
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  private var idLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.contentMode = .left
    label.font = .systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  public var viewModel: CustomCellViewModel? {
    didSet {
      guard let viewModel = viewModel else {
        isHidden = true
        return
      }
      initView(viewModel: viewModel)
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(idLabel)
    contentView.addSubview(stackView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -180),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
    ])
  }
  
  private func initView(viewModel: CustomCellViewModel) {
    self.nameLabel.text = viewModel.name
    self.idLabel.text = String(format: "%(\(viewModel.id))")
  }
}
