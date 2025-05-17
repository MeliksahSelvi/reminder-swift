//
//  MainTitleCell.swift
//  reminder
//
//  Created by Melik on 16.05.2025.
//

import UIKit

class MainTitleCell: UICollectionViewCell {
    
    let cellStackView: UIStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func configure() {
        
    }
}

private extension MainTitleCell {
    
    func setupViews() {
        cellStackView.axis = .horizontal
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellStackView)
        
        let mainTitle: UILabel = UILabel()
        mainTitle.text = "Today's Reminders"
        mainTitle.textAlignment = .left
        mainTitle.font = .preferredFont(forTextStyle: .callout)
        cellStackView.addArrangedSubview(mainTitle)
        
        buildConstraints()
    }
    
    func buildConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16))

        NSLayoutConstraint.activate(constraints)
    }
}
