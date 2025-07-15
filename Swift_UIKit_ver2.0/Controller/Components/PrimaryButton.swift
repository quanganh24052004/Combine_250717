//
//  PrimaryButton.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import UIKit

class PrimaryButton: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    override func layoutSubviews() {
        
    }
    
    private func loadFromNib() {
        let nib = UINib(nibName: "PrimaryButton", bundle: nil)
        let nibView = nib.instantiate(withOwner: self).first as! UIView
        
        addSubview(nibView)
        
        nibView.translatesAutoresizingMaskIntoConstraints = false
        nibView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nibView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nibView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nibView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    @objc private func buttonTapped() {
        onTap?()
    }
    
    public func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
}
