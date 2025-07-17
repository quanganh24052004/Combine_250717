//
//  Profile.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import UIKit
import Combine

class Profile: UIViewController {

    @IBOutlet weak var updateButton: PrimaryButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var bmi: UILabel!
    
    // Combine properties
    private let userDataManager = UserDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCombineBindings()
        updateButton.setTitle("Back to Information")
        updateButton.onTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupCombineBindings() {
        // Observe user information changes
        userDataManager.userInformationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userInfo in
                self?.updateUI(with: userInfo)
            }
            .store(in: &cancellables)
        
        // Initial update
        updateUI(with: userDataManager.userInformation)
    }
    
    private func updateUI(with userInfo: UserInformation) {
        fullName.text = "\(userInfo.fullName)"
        weight.text = "\(userInfo.weight) kg"
        height.text = "\(userInfo.height) cm"
        gender.text = "\(userInfo.gender)"
        bmi.text = "\(userInfo.bmiValue)"
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
