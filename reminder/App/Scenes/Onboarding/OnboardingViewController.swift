//
//  OnboardingViewController.swift
//  reminder
//
//  Created by Melik on 11.05.2025.
//

import UIKit

protocol OnboardingViewControllerProtocol : AnyObject{
    
    func updateStartButtonValidity(isEnabled: Bool)
    func navigateToHome()
}

class OnboardingViewController: UIViewController, OnboardingViewControllerProtocol {

    private var viewModel: OnboardingViewModelProtocol
    private var onNavigateHome: (() -> Void)
    
    private let mainStack: UIStackView = UIStackView()
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    private let startButton: UIButton = UIButton(type: .custom)
    
    init(viewModel: OnboardingViewModelProtocol,onNavigateHome: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onNavigateHome = onNavigateHome
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
    }
     
    func updateStartButtonValidity(isEnabled: Bool) {
        self.startButton.isEnabled = isEnabled
        self.startButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func navigateToHome() {
        onNavigateHome()
    }
}

private extension OnboardingViewController {
    
    func buildViews(){
        view.backgroundColor = .systemBackground
        buildMainStack()
        buildImage()
        buildTitleLabel()
        buildTextField()
        buildStartButton()
        buildConstraints()
    }
    
    func buildMainStack(){
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
    }
    
    func buildImage() {
        imageView.image = UIImage(systemName: "alarm")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(imageView)
    }
    
    func buildTitleLabel() {
        titleLabel.text = "Sana nasıl hitap edelim?"
        titleLabel.textColor = .label
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(titleLabel)
    }
    
    func buildTextField() {
        textField.placeholder = "Placeholder"
        textField.textColor = .label
        textField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainStack.addArrangedSubview(textField)
    }
    
    func buildStartButton(){
        let buttonStack: UIStackView = UIStackView()
        buttonStack.alignment = .center
        buttonStack.distribution = .fill
        buttonStack.alignment = .fill
        buttonStack.axis = .horizontal
        
        startButton.backgroundColor = .systemOrange
        startButton.setTitle("Giriş Yap", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 16
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        startButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        startButton.titleLabel?.textAlignment = .center
        startButton.contentHorizontalAlignment = .center
        startButton.contentVerticalAlignment = .center
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        startButton.isEnabled = false
        startButton.alpha = 0.5
        buttonStack.addArrangedSubview(startButton)
        
        mainStack.addArrangedSubview(buttonStack)
    }
    
    @objc func handleLogin() {
        viewModel.saveUsername()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.updateUsername(textField.text ?? "")
    }
    
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16))
        constraints.append(mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16))
        constraints.append(mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30))
        
        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 100))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 100))
        
        NSLayoutConstraint.activate(constraints)
    }
}


 #Preview {
     let viewModel : OnboardingViewModelProtocol = PreviewOnboardingViewModel()
     OnboardingViewController(viewModel: viewModel, onNavigateHome: {})
 }
 
