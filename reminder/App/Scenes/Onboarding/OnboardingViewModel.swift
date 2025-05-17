//
//  OnboardingViewModel.swift
//  reminder
//
//  Created by Melik on 13.05.2025.
//

protocol OnboardingViewModelProtocol : AnyObject {
    
    func assignDelegate(delegate: OnboardingViewControllerProtocol )
    func updateUsername(_ username: String)
    func saveUsername()
}

class OnboardingViewModel : OnboardingViewModelProtocol {
    
    private weak var delegate : OnboardingViewControllerProtocol?
    
    private var currentUsername: String = ""

    private let userDefaultsService: UserDefaultsServiceProtocol

    init(userDefaultsService: UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
    }

    func updateUsername(_ username: String) {
        currentUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.updateStartButtonValidity(isEnabled: currentUsername.isEmpty == false)
    }

    func saveUsername() {
        userDefaultsService.saveUsername(currentUsername)
        delegate?.navigateToHome()
    }

    func assignDelegate(delegate: OnboardingViewControllerProtocol ) {
        self.delegate = delegate
    }
}


