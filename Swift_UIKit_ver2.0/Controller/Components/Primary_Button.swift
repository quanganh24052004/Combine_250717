import UIKit

enum PrimaryButtonStyle {
    case buttonActive // Trang thai bam duoc
    case buttonInactive // Trang thai chua bam duoc
}
class Primary_Button: UIView {

    // MARK: - Public button để có thể addTarget bên ngoài
        let button: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Continue", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            btn.backgroundColor = .primary1
            btn.layer.cornerRadius = 16
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()

        // MARK: - Initializers
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupLayout()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupLayout()
        }

        // MARK: - Setup
        private func setupLayout() {
            addSubview(button)

            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: topAnchor),
                button.bottomAnchor.constraint(equalTo: bottomAnchor),
                button.leadingAnchor.constraint(equalTo: leadingAnchor),
                button.trailingAnchor.constraint(equalTo: trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 56),
                // button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ])
        }

        // MARK: - Public API
        func setTitle(_ title: String) {
            button.setTitle(title, for: .normal)
        }

        func setEnabled(_ isEnabled: Bool) {
            button.isEnabled = isEnabled
            button.alpha = isEnabled ? 1.0 : 0.5
        }
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        button.addTarget(target, action: action, for: event)
    }
    
    func setStyle(_ style: PrimaryButtonStyle) {
        switch style {
        case .buttonActive:
            button.backgroundColor = .primary1
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 0
            button.isEnabled = true
            button.alpha = 1
        case .buttonInactive:
            button.backgroundColor = .neutral3
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 0
            button.isEnabled = false
            button.alpha = 1
        }
    }

}

#Preview{
    Primary_Button()
}

