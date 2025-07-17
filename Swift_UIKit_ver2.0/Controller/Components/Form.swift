//
//  Form.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import UIKit

class Form: UIView {
    @IBOutlet var form: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        loadFromNib()


    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.neutral4.cgColor
        textField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        
    }
    
    override func layoutSubviews() {
        
    }
    
    private func loadFromNib() {
        let nib = UINib(nibName: "Form", bundle: nil)
        let nibView = nib.instantiate(withOwner: self).first as! UIView

        addSubview(nibView)
        
        nibView.translatesAutoresizingMaskIntoConstraints = false
        nibView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nibView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nibView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nibView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setPlaceholder(_ text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.neutral3,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
