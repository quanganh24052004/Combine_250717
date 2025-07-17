//
//  UserDataManager.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import Foundation
import Combine

class UserDataManager: ObservableObject {
    static let shared = UserDataManager()
    
    // Published properties để các view có thể observe
    @Published var userInformation: UserInformation = UserInformation()
    @Published var isDataValid: Bool = false
    @Published var validationMessage: String?
    
    // Private cancellables để quản lý subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupBindings()
        loadExistingData()
    }
    
    private func setupBindings() {
        // Observe changes in userInformation và tự động validate
        $userInformation
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] userInfo in
                self?.validateData(userInfo)
            }
            .store(in: &cancellables)
    }
    
    private func validateData(_ userInfo: UserInformation) {
        isDataValid = userInfo.isValid
        validationMessage = userInfo.validationMessage
    }
    
    // MARK: - Public Methods
    
    func updateUserInformation(_ userInfo: UserInformation) {
        userInformation = userInfo
        saveData()
    }
    
    func updateFirstName(_ firstName: String) {
        userInformation.firstName = firstName
        saveData()
    }
    
    func updateLastName(_ lastName: String) {
        userInformation.lastName = lastName
        saveData()
    }
    
    func updateWeight(_ weight: String) {
        userInformation.weight = weight
        saveData()
    }
    
    func updateHeight(_ height: String) {
        userInformation.height = height
        saveData()
    }
    
    func updateGender(_ gender: String) {
        userInformation.gender = gender
        saveData()
    }
    
    func clearData() {
        userInformation = UserInformation()
        UserInformation.clear()
    }
    
    // MARK: - Private Methods
    
    private func loadExistingData() {
        if let existingData = UserInformation.load() {
            userInformation = existingData
        }
    }
    
    private func saveData() {
        userInformation.save()
    }
}

// MARK: - Combine Extensions
extension UserDataManager {
    
    // Publisher cho việc thay đổi dữ liệu
    var userInformationPublisher: AnyPublisher<UserInformation, Never> {
        return $userInformation.eraseToAnyPublisher()
    }
    
    // Publisher cho validation status
    var validationPublisher: AnyPublisher<Bool, Never> {
        return $isDataValid.eraseToAnyPublisher()
    }
    
    // Publisher cho validation message
    var validationMessagePublisher: AnyPublisher<String?, Never> {
        return $validationMessage.eraseToAnyPublisher()
    }
    
    // Combined publisher cho tất cả thông tin user
    var userDataPublisher: AnyPublisher<(UserInformation, Bool, String?), Never> {
        return Publishers.CombineLatest3(
            $userInformation,
            $isDataValid,
            $validationMessage
        ).eraseToAnyPublisher()
    }
} 