//
//  CombineExtensions.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import Foundation
import Combine
import UIKit

// MARK: - UITextField Combine Extensions
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    var editingDidEndPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

// MARK: - UIButton Combine Extensions
extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        return Publishers.ControlEvent(control: self, events: .touchUpInside)
            .eraseToAnyPublisher()
    }
}

// MARK: - UISegmentedControl Combine Extensions
extension UISegmentedControl {
    func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {
        return Publishers.ControlEvent(control: self, events: events)
            .eraseToAnyPublisher()
    }
}

// MARK: - Publishers.ControlEvent for UIButton
extension Publishers {
    struct ControlEvent<ControlType: UIControl>: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        let control: ControlType
        let events: UIControl.Event
        
        init(control: ControlType, events: UIControl.Event) {
            self.control = control
            self.events = events
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = Subscription(subscriber: subscriber, control: control, events: events)
            subscriber.receive(subscription: subscription)
        }
        
        private class Subscription<S: Subscriber, ControlType: UIControl>: Combine.Subscription where S.Input == Void, S.Failure == Never {
            private var subscriber: S?
            private let control: ControlType
            private let events: UIControl.Event
            
            init(subscriber: S, control: ControlType, events: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                self.events = events
                
                control.addTarget(self, action: #selector(handleEvent), for: events)
            }
            
            @objc private func handleEvent() {
                _ = subscriber?.receive(())
            }
            
            func request(_ demand: Subscribers.Demand) {
                // No-op for UI events
            }
            
            func cancel() {
                subscriber = nil
                control.removeTarget(self, action: #selector(handleEvent), for: events)
            }
        }
    }
}

// MARK: - Debounce Extension
extension Publisher {
    func debounced<S: Scheduler>(for dueTime: S.SchedulerTimeType.Stride, scheduler: S) -> AnyPublisher<Output, Failure> {
        return self.debounce(for: dueTime, scheduler: scheduler).eraseToAnyPublisher()
    }
}

// MARK: - Validation Extensions
extension Publisher where Output == String {
    func validateNotEmpty(errorMessage: String) -> AnyPublisher<ValidationResult, Never> {
        return self
            .map { text in
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return ValidationResult.invalid(errorMessage)
                } else {
                    return ValidationResult.valid
                }
            }
            .replaceError(with: .invalid(errorMessage))
            .eraseToAnyPublisher()
    }
    
    func validateLength(min: Int, max: Int, errorMessage: String) -> AnyPublisher<ValidationResult, Never> {
        return self
            .map { text in
                let length = text.count
                if length < min || length > max {
                    return ValidationResult.invalid(errorMessage)
                } else {
                    return ValidationResult.valid
                }
            }
            .replaceError(with: .invalid(errorMessage))
            .eraseToAnyPublisher()
    }
}

// MARK: - ValidationResult
enum ValidationResult {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .valid:
            return nil
        case .invalid(let message):
            return message
        }
    }
} 