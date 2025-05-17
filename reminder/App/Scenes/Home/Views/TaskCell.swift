//
//  TaskCell.swift
//  reminder
//
//  Created by Melik on 16.05.2025.
//

protocol TaskCellDelegate: AnyObject {
    func didCheckTaskCell(task: DailyTask, newValue: Bool)
}

import UIKit

class TaskCell: UICollectionViewCell {
    
    private weak var delegate: TaskCellDelegate?
    
    let cellStackView: UIStackView = UIStackView()
    let taskLabel: UILabel = UILabel()
    let completionTimeLabel: UILabel = UILabel()
    let checkboxButton: UIButton = UIButton(type: .system)
    
    var task: DailyTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (_: TaskCell, _: UITraitCollection?) in
            self?.checkboxButton.layer.borderColor = UIColor.label.cgColor
        }
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func configure(dailyTask : DailyTask, delegate : TaskCellDelegate,completionTime: String) {
        self.task = dailyTask
        self.delegate = delegate
        taskLabel.text = dailyTask.title
        completionTimeLabel.text = completionTime
        checkboxButton.isSelected = dailyTask.isCompleted
        if dailyTask.isCompleted {
            cellStackView.layer.borderColor = UIColor.label.cgColor
            checkboxButton.layer.borderWidth = 0
        }
    }
}

private extension TaskCell {
    func setupViews() {
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        cellStackView.layer.borderWidth = 1
        cellStackView.layer.borderColor = UIColor.systemGray.cgColor
        cellStackView.distribution = .fill
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.clipsToBounds = true
        cellStackView.layer.cornerRadius = 8
        cellStackView.isLayoutMarginsRelativeArrangement = true
        cellStackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView.addSubview(cellStackView)
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.distribution = .fill
        textStackView.alignment = .fill
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(textStackView)
        
        taskLabel.font = .preferredFont(forTextStyle: .callout)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.numberOfLines = 1
        textStackView.addArrangedSubview(taskLabel)
        
        completionTimeLabel.font = .preferredFont(forTextStyle: .footnote)
        completionTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        completionTimeLabel.textColor = .systemGray
        completionTimeLabel.numberOfLines = 1
        textStackView.addArrangedSubview(completionTimeLabel)
        
        let spacer : UIView = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.addArrangedSubview(spacer)
        
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.layer.cornerRadius = 16
        checkboxButton.layer.borderColor = UIColor.label.cgColor
        checkboxButton.layer.borderWidth = 3
        checkboxButton.tintColor = .darkGray
        checkboxButton.clipsToBounds = true
        checkboxButton.setImage(UIImage(systemName: "checkmark")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        ), for: .selected)
        
        checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        cellStackView.addArrangedSubview(checkboxButton)
        
        buildConstraints()
    }
    
    func buildConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8))
        constraints.append(cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8))
        constraints.append(cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8))
        constraints.append(cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8))
        
        constraints.append(checkboxButton.widthAnchor.constraint(equalToConstant: 32))
        constraints.append(checkboxButton.heightAnchor.constraint(equalToConstant: 32))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        
        guard let task = self.task else { return }
        if task.isCompleted {
            return
        }
        sender.isSelected.toggle()
        delegate?.didCheckTaskCell(task: task , newValue: sender.isSelected)
    }
}


