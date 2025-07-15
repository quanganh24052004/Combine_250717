//
//  Onboarding.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import UIKit

class Onboarding: UIViewController {
    
    @IBOutlet weak var continueButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroud1
        
        continueButton.setTitle("Continue")
        //continueButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        continueButton.onTap = { [weak self] in
            let nextVC = OnboardingScreen()
            self?.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        
        
    }
}
