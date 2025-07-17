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
        // Observe validation status để enable/disable button
        userDataManager.validationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.button.isEnabled = isValid
                self?.button.alpha = isValid ? 1.0 : 0.5
            }
            .store(in: &cancellables)
        
        // Observe validation message để hiển thị lỗi
        userDataManager.validationMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message {
                    self?.showValidationError(message)
                }
            }
            .store(in: &cancellables)
        
        // Setup text field bindings
        setupTextFieldBindings()
    }
    
    private func setupTextFieldBindings() {
        // Bind firstName text field using extension
        firstName.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.updateFirstName(text)
            }
            .store(in: &cancellables)
        
        // Bind lastName text field using extension
        lastName.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.updateLastName(text)
            }
            .store(in: &cancellables)
        
        // Bind weight text field using extension
        weight.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.updateWeight(text)
            }
            .store(in: &cancellables)
        
        // Bind height text field using extension
        height.textField.textPublisher
            .debounced(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.userDataManager.updateHeight(text)
            }
            .store(in: &cancellables)
        
        // Bind gender segmented control
        gender.publisher(for: .valueChanged)
            .sink { [weak self] _ in
                let selectedGender = self?.gender.selectedSegmentIndex == 0 ? "Male" : "Female"
                self?.userDataManager.updateGender(selectedGender)
            }
            .store(in: &cancellables)
    }
    
    private func loadExistingData() {
        // Load existing data from UserDataManager
        firstName.textField.text = userDataManager.userInformation.firstName
        lastName.textField.text = userDataManager.userInformation.lastName
        weight.textField.text = userDataManager.userInformation.weight
        height.textField.text = userDataManager.userInformation.height
        
        // Load gender from segmented control
        if userDataManager.userInformation.gender == "Male" {
            gender.selectedSegmentIndex = 0
        } else if userDataManager.userInformation.gender == "Female" {
            gender.selectedSegmentIndex = 1
        }
    }
    
    private func saveAndContinue() {
        // Check if data is valid
        guard userDataManager.isDataValid else {
            if let errorMessage = userDataManager.validationMessage {
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
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }


