//
//  SplashViewModel.swift
//  reminder
//
//  Created by Melik on 13.05.2025.
//

import Foundation

protocol SplashViewModelProtocol {
    
    func assignDelegate(delegate: SplashViewControllerProtocol)
    func getInitialRoute()
}

final class SplashViewModel: SplashViewModelProtocol {
    
    private let userDefaultsService: UserDefaultsServiceProtocol
    private weak var delegate : SplashViewControllerProtocol?
    
    init(userDefaultsService: UserDefaultsServiceProtocol){
        self.userDefaultsService = userDefaultsService
    }
    
    func assignDelegate(delegate: SplashViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func getInitialRoute() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let username = self.userDefaultsService.getUsername()
            if username == nil {
                self.delegate?.routeNextFlow(route: .onboarding)
            } else {
                self.delegate?.routeNextFlow(route: .home)

            }
        }
    }
}
