//
//  Atomic.swift
//  Atomic
//
//  Adapted from Atomic.swift in ReactiveCocoa.
//  Original file is by Justin Spahr-Summers 2014-06-10.
//

import Foundation

/// An atomic variable.
public final class Atomic<Value> {
    internal var _lock = pthread_mutex_t()
    internal var _value: Value

    /// Atomically gets or sets the value of the variable.
    public var value: Value {
        get {
            lock()
            defer { unlock() }

            return _value
        }

        set(newValue) {
            lock()
            defer { unlock() }

            _value = newValue
        }
    }

    /// Initializes the variable with the given initial value.
    public init(_ value: Value) {
        pthread_mutex_init(&_lock, nil)
        _value = value
    }

    internal func lock() {
        pthread_mutex_lock(&_lock)
    }

    internal func unlock() {
        pthread_mutex_unlock(&_lock)
    }

    /// Atomically replaces the contents of the variable.
    ///
    /// Returns the old value.
    public func swap(newValue: Value) -> Value {
        return modify { _ in newValue }
    }

    /// Atomically modifies the variable.
    ///
    /// Returns the old value.
    public func modify(@noescape action: (Value) throws -> Value) rethrows -> Value {
        lock()
        defer { unlock() }

        let oldValue = _value
        _value = try action(_value)
        return oldValue
    }

    /// Atomically performs an arbitrary action using the current value of the
    /// variable.
    ///
    /// Returns the result of the action.
    public func withValue<Result>(@noescape action: (Value) throws -> Result) rethrows -> Result {
        lock()
        defer { unlock() }
        
        return try action(_value)
    }
}
