//
//  TaskViewController.swift
//  reminder
//
//  Created by Melik on 15.05.2025.
//
import UIKit

protocol TaskViewControllerProtocol : AnyObject {
    
    func updateSaveButtonValidity(isEnabled: Bool)
    func executeSaveAfterActions()
}

protocol TaskViewControllerDelegate: AnyObject {
    func onSaveTask()
}

class TaskViewController: UIViewController, TaskViewControllerProtocol {
    
    private var viewModel: TaskViewModelProtocol
    weak var delegate: TaskViewControllerDelegate?
    
    
    private let contentView = UIView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let dayPickerStack : UIStackView = UIStackView()
    private let hourPickerStack : UIStackView = UIStackView()
    private let taskTextField: UITextField = UITextField()
    private let dayImageView: UIImageView = UIImageView(image: UIImage(systemName: "calendar"))
    private let hourImageView: UIImageView = UIImageView(image: UIImage(systemName: "clock"))
    private let dayPicker : UIDatePicker = UIDatePicker()
    private let hourPicker : UIDatePicker = UIDatePicker()
    private let saveButton = UIButton(type: .system)
    
    init(viewModel: TaskViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    func updateSaveButtonValidity(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func executeSaveAfterActions() {
        navigationController?.popViewController(animated: true)
        self.delegate?.onSaveTask()
    }
    
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        applyTaskToView()
    }
}

private extension TaskViewController {
    
    func applyTaskToView() {
        if let task = self.viewModel.getTask() {
            print("task : \(task)")
            let date = task.remindAt
            hourPicker.date = date
            dayPicker.date = date
            taskTextField.text = task.title
            mainLabel.text = "Edit Task"
        }
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground

        buildMainView()
        buildMainLabel()
        buildSubLabel()
        buildDayPicker()
        buildHourPicker()
        buildTaskTextField()
        buildSaveButton()
        buildConstraints()
    }
    
    func buildMainView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
    }
    
    func buildMainLabel() {
        mainLabel.text = "New Task"
        mainLabel.textAlignment = .left
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont.boldSystemFont(ofSize: 32)
        contentView.addSubview(mainLabel)
    }
    
    func buildSubLabel() {
        subLabel.text = "Remind"
        subLabel.textAlignment = .left
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.font = .preferredFont(forTextStyle: .callout)
        contentView.addSubview(subLabel)
    }
    
    func buildDayPicker() {
        dayPickerStack.axis = .horizontal
        dayPickerStack.distribution = .fill
        dayPickerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayPickerStack)
        
        dayImageView.contentMode = .scaleAspectFit
        dayImageView.tintColor = .label
        dayImageView.translatesAutoresizingMaskIntoConstraints = false
        dayImageView.isUserInteractionEnabled = true
        dayImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        dayImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        dayPickerStack.addArrangedSubview(dayImageView)
        
        dayPicker.datePickerMode = .date
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        dayPicker.addTarget(self, action: #selector(dayChanged), for: .valueChanged)
        dayPicker.minimumDate = .now
        dayPickerStack.addArrangedSubview(dayPicker)
    }
    
    func buildHourPicker() {
        hourPickerStack.axis = .horizontal
        hourPickerStack.distribution = .fillProportionally
        hourPickerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hourPickerStack)
        
        
        hourImageView.contentMode = .scaleAspectFit
        hourImageView.tintColor = .label
        hourImageView.translatesAutoresizingMaskIntoConstraints = false
        hourImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        hourPickerStack.addArrangedSubview(hourImageView)
        
        hourPicker.datePickerMode = .time
        hourPicker.translatesAutoresizingMaskIntoConstraints = false
        hourPicker.addTarget(self, action: #selector(hourChanged), for: .valueChanged)
        hourPicker.minimumDate = .now
        hourPickerStack.addArrangedSubview(hourPicker)
    }
    
    func buildTaskTextField() {
        taskTextField.placeholder = "Here will be the text of the new task"
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        taskTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contentView.addSubview(taskTextField)
    }
    
    func buildSaveButton()  {
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .systemBackground
        saveButton.backgroundColor = .label
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(savePopup), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
        contentView.addSubview(saveButton)
    }
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16))
        constraints.append(contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16))
        constraints.append(contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 256))
        constraints.append(contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -256))
        constraints.append(mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20))
        constraints.append(mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10))
        constraints.append(subLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(dayPickerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(dayPickerStack.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 10))
        constraints.append(dayImageView.trailingAnchor.constraint(equalTo: dayPicker.leadingAnchor,constant: -6))
        constraints.append(hourPickerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(hourPickerStack.topAnchor.constraint(equalTo: dayPickerStack.bottomAnchor, constant: 10))
        constraints.append(hourImageView.trailingAnchor.constraint(equalTo: hourPicker.leadingAnchor, constant: -6))
        constraints.append(taskTextField.topAnchor.constraint(equalTo: hourPickerStack.bottomAnchor, constant: 10))
        constraints.append(taskTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        constraints.append(saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20))
        constraints.append(saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20))
        constraints.append(saveButton.widthAnchor.constraint(equalToConstant: 64))
        
        NSLayoutConstraint.activate(constraints)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.updateTitle(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
    }

    @objc func dayChanged(_ sender: UIDatePicker) {
        viewModel.updateDate(sender.date)
    }

    @objc func hourChanged(_ sender: UIDatePicker) {
        viewModel.updateTime(sender.date)
    }

    @objc private func savePopup() {
        viewModel.saveTask()
    }
}
