//
//  UserDataManager.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import Foundation
import Combine

// MARK: - User Actions (Commands)
enum UserAction {
    case updateFirstName(String)
    case updateLastName(String)
    case updateWeight(String)
    case updateHeight(String)
    case updateGender(String)
    case updateUserInformation(UserInformation)
    case clearData
    case validateData
}

// MARK: - User State
struct UserState {
    let userInformation: UserInformation
    let isValid: Bool
    let validationMessage: String?
    
    init(userInformation: UserInformation = UserInformation(), isValid: Bool = false, validationMessage: String? = nil) {
        self.userInformation = userInformation
        self.isValid = isValid
        self.validationMessage = validationMessage
    }
    
    func updated(with userInfo: UserInformation) -> UserState {
        return UserState(
            userInformation: userInfo,
            isValid: userInfo.isValid,
            validationMessage: userInfo.validationMessage
        )
    }
}

// MARK: - UserDataManager with Command Pattern
class UserDataManager: ObservableObject {
    static let shared = UserDataManager()
    
    // MARK: - Command Pattern Implementation
    
    // Actions Publisher (Commands)
    private let actionSubject = PassthroughSubject<UserAction, Never>()
    
    // State Publisher (Current State)
    private let stateSubject = CurrentValueSubject<UserState, Never>(UserState())
    
    // Public Publishers
    var onUserAction: PassthroughSubject<UserAction, Never> {
        return actionSubject
    }
    
    var onUserState: CurrentValueSubject<UserState, Never> {
        return stateSubject
    }
    
    // Convenience Publishers for backward compatibility
    var userInformationPublisher: AnyPublisher<UserInformation, Never> {
        return stateSubject.map { $0.userInformation }.eraseToAnyPublisher()
    }
    
    var validationPublisher: AnyPublisher<Bool, Never> {
        return stateSubject.map { $0.isValid }.eraseToAnyPublisher()
    }
    
    var validationMessagePublisher: AnyPublisher<String?, Never> {
        return stateSubject.map { $0.validationMessage }.eraseToAnyPublisher()
    }
    
    // Current state properties for backward compatibility
    var userInformation: UserInformation {
        return stateSubject.value.userInformation
    }
    
    var isDataValid: Bool {
        return stateSubject.value.isValid
    }
    
    var validationMessage: String? {
        return stateSubject.value.validationMessage
    }
    
    // Private cancellables
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupCommandProcessor()
        loadExistingData()
    }
    
    // MARK: - Command Processor
    
    private func setupCommandProcessor() {
        actionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.processAction(action)
            }
            .store(in: &cancellables)
    }
    
    private func processAction(_ action: UserAction) {
        switch action {
        case .updateFirstName(let firstName):
            var updatedInfo = stateSubject.value.userInformation
            updatedInfo.firstName = firstName
            updateState(with: updatedInfo)
            
        case .updateLastName(let lastName):
            var updatedInfo = stateSubject.value.userInformation
            updatedInfo.lastName = lastName
            updateState(with: updatedInfo)
            
        case .updateWeight(let weight):
            var updatedInfo = stateSubject.value.userInformation
            updatedInfo.weight = weight
            updateState(with: updatedInfo)
            
        case .updateHeight(let height):
            var updatedInfo = stateSubject.value.userInformation
            updatedInfo.height = height
            updateState(with: updatedInfo)
            
        case .updateGender(let gender):
            var updatedInfo = stateSubject.value.userInformation
            updatedInfo.gender = gender
            updateState(with: updatedInfo)
            
        case .updateUserInformation(let userInfo):
            updateState(with: userInfo)
            
        case .clearData:
            let emptyState = UserState()
            stateSubject.send(emptyState)
            UserInformation.clear()
            
        case .validateData:
            let currentInfo = stateSubject.value.userInformation
            updateState(with: currentInfo)
        }
    }
    
    private func updateState(with userInfo: UserInformation) {
        let newState = UserState().updated(with: userInfo)
        stateSubject.send(newState)
        userInfo.save()
    }
    
    // MARK: - Backward Compatibility Methods
    
    func updateFirstName(_ firstName: String) {
        actionSubject.send(.updateFirstName(firstName))
    }
    
    func updateLastName(_ lastName: String) {
        actionSubject.send(.updateLastName(lastName))
    }
    
    func updateWeight(_ weight: String) {
        actionSubject.send(.updateWeight(weight))
    }
    
    func updateHeight(_ height: String) {
        actionSubject.send(.updateHeight(height))
    }
    
    func updateGender(_ gender: String) {
        actionSubject.send(.updateGender(gender))
    }
    
    func updateUserInformation(_ userInfo: UserInformation) {
        actionSubject.send(.updateUserInformation(userInfo))
    }
    
    func clearData() {
        actionSubject.send(.clearData)
    }
    
    // MARK: - Private Methods
    
    private func loadExistingData() {
        if let existingData = UserInformation.load() {
            actionSubject.send(.updateUserInformation(existingData))
        }
    }
}

// MARK: - Combine Extensions for Enhanced Functionality
extension UserDataManager {
    
    // Combined publisher for all user data
    var userDataPublisher: AnyPublisher<(UserInformation, Bool, String?), Never> {
        return stateSubject
            .map { state in
                (state.userInformation, state.isValid, state.validationMessage)
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for specific user information changes
    func userInfoPublisher<T>(_ keyPath: KeyPath<UserInformation, T>) -> AnyPublisher<T, Never> {
        return stateSubject
            .map { $0.userInformation }
            .map(keyPath)
            .eraseToAnyPublisher()
    }
} 