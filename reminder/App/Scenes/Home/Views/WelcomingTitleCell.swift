//
//  WelcomingTitleCell.swift
//  reminder
//
//  Created by Melik on 16.05.2025.
//


import UIKit

class WelcomingTitleCell: UICollectionViewCell {
    
    let cellStackView: UIStackView = UIStackView()
    let welcomeTitle: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func configure(greetingMessage: String) {
        welcomeTitle.text = greetingMessage
    }
}

private extension WelcomingTitleCell {
    
    func setupViews() {
        cellStackView.axis = .horizontal
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellStackView)
        
        
        welcomeTitle.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        welcomeTitle.textAlignment = .left
        welcomeTitle.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(welcomeTitle)
        
        let spacer = UIView()
        cellStackView.addArrangedSubview(spacer)
        
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        cellStackView.addArrangedSubview(imageView)

        buildConstraints()
    }
    
    func buildConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16))
        constraints.append(cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8))
        
        NSLayoutConstraint.activate(constraints)
    }

}
