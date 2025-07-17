//
//  UserDataManagerDemo.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import Foundation
import Combine

// MARK: - Demo Usage Examples
class UserDataManagerDemo {
    
    private let userManager = UserDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    func demonstrateCommandPattern() {
        
        // 1. Subscribe to state changes using Command Pattern
        userManager.onUserState
            .receive(on: DispatchQueue.main)
            .sink { state in
                print("🔄 State Updated:")
                print("   - User: \(state.userInformation.fullName)")
                print("   - Valid: \(state.isValid)")
                print("   - Message: \(state.validationMessage ?? "None")")
            }
            .store(in: &cancellables)
        
        // 2. Send actions (commands) using Command Pattern
        print("📤 Sending Actions...")
        
        // Update user information using actions
        userManager.onUserAction.send(.updateFirstName("John"))
        userManager.onUserAction.send(.updateLastName("Doe"))
        userManager.onUserAction.send(.updateWeight("70"))
        userManager.onUserAction.send(.updateHeight("175"))
        userManager.onUserAction.send(.updateGender("Male"))
        
        // 3. Clear data using action
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("🗑️ Clearing data...")
            self.userManager.onUserAction.send(.clearData)
        }
    }
    
    func demonstrateReactiveUpdates() {
        
        // Subscribe to specific publishers using Command Pattern
        userManager.userInformationPublisher
            .receive(on: DispatchQueue.main)
            .sink { userInfo in
                print("👤 User Info Updated: \(userInfo.fullName)")
            }
            .store(in: &cancellables)
        
        userManager.validationPublisher
            .receive(on: DispatchQueue.main)
            .sink { isValid in
                print("✅ Validation Status: \(isValid ? "Valid" : "Invalid")")
            }
            .store(in: &cancellables)
        
        userManager.validationMessagePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { message in
                print("⚠️ Validation Error: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func demonstrateBackwardCompatibility() {
        
        // Sử dụng convenience methods (backward compatibility)
        print("🔄 Using convenience methods...")
        
        userManager.updateFirstName("Jane")
        userManager.updateLastName("Smith")
        userManager.updateWeight("65")
        userManager.updateHeight("165")
        userManager.updateGender("Female")
        
        // Truy cập state hiện tại
        let currentState = userManager.onUserState.value
        print("📊 Current State:")
        print("   - User: \(currentState.userInformation.fullName)")
        print("   - Valid: \(currentState.isValid)")
        print("   - Message: \(currentState.validationMessage ?? "None")")
    }
    
    func demonstrateAdvancedCommandPattern() {
        
        // Subscribe to combined state changes
        userManager.userDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { userInfo, isValid, validationMessage in
                print("🎯 Combined State Update:")
                print("   - User: \(userInfo.fullName)")
                print("   - Valid: \(isValid)")
                print("   - Error: \(validationMessage ?? "None")")
            }
            .store(in: &cancellables)
        
        // Send multiple actions in sequence
        print("🚀 Sending multiple actions...")
        
        let actions: [UserAction] = [
            .updateFirstName("Alice"),
            .updateLastName("Johnson"),
            .updateWeight("60"),
            .updateHeight("170"),
            .updateGender("Female")
        ]
        
        actions.enumerated().forEach { index, action in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                print("📤 Action \(index + 1): \(action)")
                self.userManager.onUserAction.send(action)
            }
        }
    }
}

// MARK: - Usage Examples
extension UserDataManagerDemo {
    
    static func runAllDemos() {
        let demo = UserDataManagerDemo()
        
        print("🚀 Starting UserDataManager Command Pattern Demo...")
        print("=" * 60)
        
        demo.demonstrateCommandPattern()
        demo.demonstrateReactiveUpdates()
        demo.demonstrateBackwardCompatibility()
        demo.demonstrateAdvancedCommandPattern()
        
        print("=" * 60)
        print("✅ Command Pattern Demo completed!")
    }
} 