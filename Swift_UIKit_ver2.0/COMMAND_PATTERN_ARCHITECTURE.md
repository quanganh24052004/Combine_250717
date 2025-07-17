# Command Pattern Architecture với Combine

## 🎯 Tổng quan

Project này đã được refactor để sử dụng **Command Pattern** với **Combine** để tạo ra một reactive data flow architecture hiện đại và scalable.

## 🏗️ Kiến trúc Command Pattern

### 1. **UserAction (Commands)**
```swift
enum UserAction {
    case updateFirstName(String)
    case updateLastName(String)
    case updateWeight(String)
    case updateHeight(String)
    case updateGender(String)
    case updateUserInformation(UserInformation)
    case clearData
    case validateData
}
```

### 2. **UserState (State)**
```swift
struct UserState {
    let userInformation: UserInformation
    let isValid: Bool
    let validationMessage: String?
}
```

### 3. **UserDataManager (Command Processor)**
```swift
class UserDataManager {
    // Actions Publisher (Commands)
    private let actionSubject = PassthroughSubject<UserAction, Never>()
    
    // State Publisher (Current State)
    private let stateSubject = CurrentValueSubject<UserState, Never>(UserState())
    
    // Public Publishers
    var onUserAction: PassthroughSubject<UserAction, Never>
    var onUserState: CurrentValueSubject<UserState, Never>
}
```

## 🔄 Data Flow

### 1. **Action Flow (Commands)**
```
UI Event → UserAction → PassthroughSubject → Command Processor → State Update
```

### 2. **State Flow (Reactive Updates)**
```
State Change → CurrentValueSubject → UI Update
```

## 📱 Cách sử dụng trong Screens

### Information Screen (Action Sender)
```swift
// Send actions
userDataManager.onUserAction.send(.updateFirstName(text))

// Observe state changes
userDataManager.onUserState
    .receive(on: DispatchQueue.main)
    .sink { state in
        // Update UI based on state
    }
    .store(in: &cancellables)
```

### Profile Screen (State Observer)
```swift
// Observe state changes
userDataManager.onUserState
    .receive(on: DispatchQueue.main)
    .sink { state in
        updateUI(with: state.userInformation)
    }
    .store(in: &cancellables)
```

## 🎨 Combine Extensions

### UITextField Extensions
```swift
extension UITextField {
    var textPublisher: AnyPublisher<String, Never>
    var editingDidEndPublisher: AnyPublisher<String, Never>
}
```

### UISegmentedControl Extensions
```swift
extension UISegmentedControl {
    func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never>
}
```

## 🔧 Backward Compatibility

UserDataManager vẫn cung cấp các convenience methods để đảm bảo backward compatibility:

```swift
// Old way (still works)
userDataManager.updateFirstName("John")

// New way (Command Pattern)
userDataManager.onUserAction.send(.updateFirstName("John"))
```

## 🚀 Lợi ích của Command Pattern

### 1. **Separation of Concerns**
- Actions (Commands) tách biệt khỏi State
- UI chỉ gửi actions, không trực tiếp thay đổi state
- State management tập trung trong Command Processor

### 2. **Reactive Updates**
- UI tự động cập nhật khi state thay đổi
- Không cần manual UI updates
- Consistent state across all screens

### 3. **Testability**
- Actions có thể được test độc lập
- State changes có thể được observe và verify
- Command Processor có thể được mock

### 4. **Scalability**
- Dễ dàng thêm actions mới
- State structure có thể mở rộng
- Multiple screens có thể observe cùng state

## 📊 Demo Usage

```swift
// Subscribe to state changes
userManager.onUserState
    .receive(on: DispatchQueue.main)
    .sink { state in
        print("State Updated: \(state.userInformation.fullName)")
    }
    .store(in: &cancellables)

// Send actions
userManager.onUserAction.send(.updateFirstName("John"))
userManager.onUserAction.send(.updateLastName("Doe"))
```

## 🔄 Migration Guide

### Từ Old Pattern sang Command Pattern:

**Before:**
```swift
userDataManager.userInformation.firstName = "John"
userDataManager.updateFirstName("John")
```

**After:**
```swift
userDataManager.onUserAction.send(.updateFirstName("John"))
```

**Before:**
```swift
userDataManager.$userInformation.sink { userInfo in
    // Update UI
}
```

**After:**
```swift
userDataManager.onUserState.sink { state in
    // Update UI with state.userInformation
}
```

## ✅ Kết luận

Command Pattern với Combine tạo ra một architecture:
- **Reactive**: UI tự động cập nhật
- **Maintainable**: Code dễ đọc và maintain
- **Testable**: Có thể test từng component độc lập
- **Scalable**: Dễ dàng mở rộng functionality
- **Modern**: Sử dụng Combine framework hiện đại 