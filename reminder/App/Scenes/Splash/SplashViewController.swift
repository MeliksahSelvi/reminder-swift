//
//  SplashViewController.swift
//  reminder
//
//  Created by Melik on 3.05.2025.
//

import UIKit

protocol SplashViewControllerProtocol : AnyObject {
    
    func routeNextFlow(route: AppRoute)
}

class SplashViewController: UIViewController,SplashViewControllerProtocol {

    private var viewModel: SplashViewModelProtocol
    private var onNavigateOnboarding: (() -> Void)
    private var onNavigateHome: (() -> Void)
    
    private let logoImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    init(viewModel: SplashViewModelProtocol,onNavigateOnboarding: @escaping () -> Void,onNavigateHome: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onNavigateOnboarding = onNavigateOnboarding
        self.onNavigateHome = onNavigateHome
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func routeNextFlow(route: AppRoute) {
        switch route {
            case .onboarding:
                onNavigateOnboarding()
            case .home:
                onNavigateHome()
            default :
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        animateSplashScreen()
        viewModel.getInitialRoute()
    }
}

private extension SplashViewController {
    
    func buildViews() {
        view.backgroundColor = .systemBackground
        
        buildLogo()
        buildLabel()
        buildConstraints()
    }
    
    func buildLogo() {
        logoImageView.image = UIImage(systemName: "alarm")
        logoImageView.tintColor = .systemOrange
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
    }
    
    func buildLabel() {
        titleLabel.text = "Reminder"
        titleLabel.textColor = .label
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(logoImageView.widthAnchor.constraint(equalToConstant: 100))
        constraints.append(logoImageView.heightAnchor.constraint(equalToConstant: 100))
        
        constraints.append(titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,constant: 16))
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20))
        constraints.append(titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        NSLayoutConstraint.activate(constraints)
    }
    
    func animateSplashScreen() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.logoImageView.transform = CGAffineTransform.identity
        })
            
        titleLabel.alpha = 0.0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.titleLabel.alpha = 1.0
            self.titleLabel.transform = CGAffineTransform.identity
        })
    }
}

#Preview {
    let viewModel : SplashViewModelProtocol = PreviewSplashViewModel()
    SplashViewController(viewModel: viewModel,
                         onNavigateOnboarding: {},
                         onNavigateHome: {}
    )
}
