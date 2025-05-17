//
//  AppNavigator.swift
//  reminder
//
//  Created by Melik on 15.05.2025.
//

import UIKit

final class AppNavigator {
    
    private let window: UIWindow
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let dailyTaskService : DailyTaskServiceProtocol

    private var navigationController: UINavigationController?
    
    init(window: UIWindow, userDefaultsService: UserDefaultsServiceProtocol, dailyTaskService : DailyTaskServiceProtocol) {
        self.window = window
        self.userDefaultsService = userDefaultsService
        self.dailyTaskService = dailyTaskService
    }
    
    func start() {
        let splashViewModel = SplashViewModel(userDefaultsService: userDefaultsService)
        let splashViewController = SplashViewController(
            viewModel: splashViewModel,
            onNavigateOnboarding: { [weak self] in
                self?.navigateOnboarding()
            },
            onNavigateHome: { [weak self] in
                self?.navigateHome()
            }
        )
        splashViewModel.assignDelegate(delegate: splashViewController)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    private func navigateOnboarding() {
        let onboardingViewModel = OnboardingViewModel(userDefaultsService: userDefaultsService)
        let onboardingViewController = OnboardingViewController(
            viewModel: onboardingViewModel,
            onNavigateHome: { [weak self] in
                self?.navigateHome()
            }
        )
        onboardingViewModel.assignDelegate(delegate: onboardingViewController)
        window.rootViewController = onboardingViewController
    }

    private func navigateHome() {
        let homeViewModel : HomeViewModelProtocol = HomeViewModel(dailyTaskService: dailyTaskService , userDefaultsService: userDefaultsService)
        let homeViewController = HomeViewController(
            homeViewModel: homeViewModel,
            onNavigateTaskView: { [weak self] task in
                self?.navigateTaskView(task : task)
            }
        )
        homeViewModel.assignDelegate(delegate: homeViewController)
        let navController = UINavigationController(rootViewController: homeViewController)
        self.navigationController = navController
        window.rootViewController = navController
    }
    
    private func navigateTaskView(task : DailyTask?) {
        let taskViewModel : TaskViewModelProtocol = TaskViewModel(dailyTaskService: dailyTaskService, task: task)
        let taskViewController = TaskViewController(viewModel: taskViewModel)
        taskViewModel.assignDelegate(delegate: taskViewController)
        
        if let homeVC = navigationController?.topViewController as? HomeViewController {
            taskViewController.delegate = homeVC
        }
        navigationController?.pushViewController(taskViewController, animated: true)
    }
}
