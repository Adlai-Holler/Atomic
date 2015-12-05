## Atomic
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)  [![Cocoapods compatible](https://img.shields.io/cocoapods/v/Atomic.svg)](https://cocoapods.org) [![Cocoapods compatible](https://img.shields.io/cocoapods/p/Atomic.svg)](https://cocoapods.org)

Atomic is a fast, safe class for making values thread-safe in Swift. It is backed by `pthread_mutex_lock` which is the fastest, most-efficient locking mechanism available.

### Installation

- Using [CocoaPods](https://cocoapods.org) by adding `pod Atomic` to your Podfile
- Using [Carthage](https://github.com/Carthage/Carthage) by adding `github "Adlai-Holler/Atomic"` to your Cartfile.

### How to Use

```swift
/// This class is completely thread-safe (yay!).
final class MyCache<Value> {
    private let entries: Atomic<[String: Value]> = Atomic([:])
    
    func valueForKey(key: String) -> Value? {
        return entries.withValue { $0[key] }
    }
    
    func setValue(value: Value, forKey: Key) {
        entries.modify { (var dict) in
            dict[key] = value
            return dict
        }
    }
    
    func clear() {
        entries.value = [:]
    }
    
    func copy() -> [String: Value] {
        return entries.value
    }
}
```

#### Another Example

```swift
/// Thread-safe manager for the `networkActivityIndicator` on iOS.
final class NetworkActivityIndicatorManager {
    static let shared = NetworkActivityIndicatorManager()

    private let count = Atomic(0)

    func incrementActivityCount() {
        let oldValue = count.modify { $0 + 1 }
        if oldValue == 0 {
            updateUI(true)
        }
    }

    func decrementActivityCount() {
        let oldValue = count.modify { $0 - 1 }
        if oldValue == 1 {
            updateUI(false)
        }
    }

    private func updateUI(on: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
}
```

### Features

- Safe. No need to remember to unlock.
- Fast. `pthread_mutex_lock` is faster than `NSLock` and more efficient than `OSSpinLock`.
- Modern. You can safely `throw` errors inside its methods, uses `@noescape` and generics to make your code as clean as possible.
- Tested. This thing is tested like crazy, including accessing it concurrently from 100,000 operations!
