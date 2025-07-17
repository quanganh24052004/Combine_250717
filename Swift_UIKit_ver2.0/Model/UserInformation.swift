//
//  UserInformation.swift
//  Swift_UIKit_ver2.0
//
//  Created by iKame Elite Fresher 2025 on 7/15/25.
//

import Foundation

struct UserInformation: Codable {
    var firstName: String
    var lastName: String
    var weight: String
    var height: String
    var gender: String
    
    // Computed property để lấy tên đầy đủ
    var fullName: String {
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    // Computed property để tính BMI
    var bmiValue: String {
        guard let weightValue = Double(weight),
              let heightValue = Double(height),
              heightValue > 0 else {
            return "N/A"
        }
        
        let heightInMeters = heightValue / 100 // Convert cm to meters
        let bmi = weightValue / (heightInMeters * heightInMeters)
        return String(format: "%.1f", bmi)
    }
    
    // Computed property để lấy BMI category
    var bmiCategory: String {
        guard let bmiValue = Double(bmiValue) else {
            return "N/A"
        }
        
        switch bmiValue {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
    
    // Initializer với giá trị mặc định
    init(firstName: String = "", lastName: String = "", weight: String = "", height: String = "", gender: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.weight = weight
        self.height = height
        self.gender = gender
    }
    
    // Kiểm tra xem thông tin có hợp lệ không
    var isValid: Bool {
        return !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !weight.trimmingCharacters(in: .whitespaces).isEmpty &&
               !height.trimmingCharacters(in: .whitespaces).isEmpty &&
               !gender.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // Lấy thông báo lỗi nếu có
    var validationMessage: String? {
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "First name is required"
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Last name is required"
        }
        if weight.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Weight is required"
        }
        if height.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Height is required"
        }
        if gender.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Gender is required"
        }
        return nil
    }
}

// MARK: - UserDefaults Extension để lưu trữ dữ liệu
extension UserInformation {
    private static let userDefaultsKey = "UserInformation"
    
    // Lưu thông tin vào UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: UserInformation.userDefaultsKey)
        }
    }
    
    // Lấy thông tin từ UserDefaults
    static func load() -> UserInformation? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let userInfo = try? JSONDecoder().decode(UserInformation.self, from: data) else {
            return nil
        }
        return userInfo
    }
    
    // Xóa thông tin từ UserDefaults
    static func clear() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    // Kiểm tra xem đã có thông tin được lưu chưa
    static var hasSavedData: Bool {
        return UserDefaults.standard.object(forKey: userDefaultsKey) != nil
    }
} 