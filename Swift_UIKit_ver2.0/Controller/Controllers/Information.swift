//
//  Information.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import UIKit
import Combine

class Information: UIViewController {
    
    @IBOutlet weak var firstName: Form!
    @IBOutlet weak var lastName: Form!
    
    @IBOutlet weak var weight: Form!
    @IBOutlet weak var height: Form!
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var button: PrimaryButton!
    
    // Combine properties
    private let userDataManager = UserDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCombineBindings()
        loadExistingData()
    }
    
    private func setupUI() {
        firstName.title.text = "First name"
        lastName.title.text = "Last name"
        weight.title.text = "Weight"
        height.title.text = "Height"
        
        firstName.setPlaceholder("Enter first name...")
        lastName.setPlaceholder("Enter last name")
        weight.setPlaceholder("Enter weight (kg)...")
        height.setPlaceholder("Enter height (cm)...")
        
        // Gender segmented control is already configured in xib
        
        button.setTitle("Continue")
        button.onTap = { [weak self] in
            self?.saveAndContinue()
        }
    }
    
    private func setupCombineBindings() {
        // Observe state changes using Command Pattern
        userDataManager.onUserState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateUpdate(state)
            }
            .store(in: &cancellables)
        
        // Setup text field bindings using Command Pattern
        setupTextFieldBindings()
    }
    
    private func handleStateUpdate(_ state: UserState) {
        // Update button state based on validation
        button.isEnabled = state.isValid
        button.alpha = state.isValid ? 1.0 : 0.5
        
        // Show validation error if any
        if let message = state.validationMessage {
            showValidationError(message)
        }
    }
    
    private func setupTextFieldBindings() {
        // Bind firstName text field using Command Pattern
        firstName.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.onUserAction.send(.updateFirstName(text))
            }
            .store(in: &cancellables)
        
        // Bind lastName text field using Command Pattern
        lastName.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.onUserAction.send(.updateLastName(text))
            }
            .store(in: &cancellables)
        
        // Bind weight text field using Command Pattern
        weight.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.onUserAction.send(.updateWeight(text))
            }
            .store(in: &cancellables)
        
        // Bind height text field using Command Pattern
        height.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.onUserAction.send(.updateHeight(text))
            }
            .store(in: &cancellables)
        
        // Bind gender segmented control using Command Pattern
        gender.publisher(for: .valueChanged)
            .sink { [weak self] _ in
                let selectedGender = self?.gender.selectedSegmentIndex == 0 ? "Male" : "Female"
                self?.userDataManager.onUserAction.send(.updateGender(selectedGender))
            }
            .store(in: &cancellables)
    }
    
    private func loadExistingData() {
        // Load existing data from UserDataManager state
        let currentState = userDataManager.onUserState.value
        firstName.textField.text = currentState.userInformation.firstName
        lastName.textField.text = currentState.userInformation.lastName
        weight.textField.text = currentState.userInformation.weight
        height.textField.text = currentState.userInformation.height
        
        // Load gender from segmented control
        if currentState.userInformation.gender == "Male" {
            gender.selectedSegmentIndex = 0
        } else if currentState.userInformation.gender == "Female" {
            gender.selectedSegmentIndex = 1
        }
    }
    
    private func saveAndContinue() {
        // Check if data is valid using Command Pattern
        let currentState = userDataManager.onUserState.value
        guard currentState.isValid else {
            if let errorMessage = currentState.validationMessage {
                showAlert(message: errorMessage)
            }
            return
        }
        
        // Navigate to next screen
        let nextVC = Profile()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showValidationError(_ message: String) {
        // Hiển thị lỗi validation một cách nhẹ nhàng hơn
        // Có thể thêm toast hoặc label error
        print("Validation Error: \(message)")
    }
}


