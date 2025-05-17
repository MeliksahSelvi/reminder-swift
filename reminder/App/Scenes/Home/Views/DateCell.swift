//
//  DateCell.swift
//  reminder
//
//  Created by Melik on 16.05.2025.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    let dateLabel: UILabel = UILabel()
    var date: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func configure(date:Date){
        self.date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateLabel.text = dateFormatter.string(from: date)
    }
}

private extension DateCell {
    
    func setupViews() {

        dateLabel.font = .preferredFont(forTextStyle: .callout)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        buildConstraints()
    }
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 2))
        constraints.append(dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -2))
        constraints.append(dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2))
        constraints.append(dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2))
        NSLayoutConstraint.activate(constraints)
    }
}
