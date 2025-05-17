//
//  UserDefaultsService.swift
//  reminder
//
//  Created by Melik on 13.05.2025.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func getUsername() -> String?
    func saveUsername(_ username: String)
    func removeUsername()
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.USERNAME)
    }
    
    func saveUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: UserDefaultKeys.USERNAME)
    }
    
    func removeUsername() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.USERNAME)
    }
}
