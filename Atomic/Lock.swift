//
//  Lock.swift
//  Atomic
//
//  Created by Adlai Holler on 1/31/16.
//  Copyright © 2016 Adlai Holler. All rights reserved.
//

import Darwin

final public class Lock {
    internal var _lock = pthread_mutex_t()

    /// Initializes the variable with the given initial value.
    public init() {
        let result = pthread_mutex_init(&_lock, nil)
        assert(result == 0, "Failed to init mutex in \(self)")
    }

    public func lock() {
        let result = pthread_mutex_lock(&_lock)
        assert(result == 0, "Failed to lock mutex in \(self)")
    }

    public func tryLock() -> Int32 {
        return pthread_mutex_trylock(&_lock)
    }

    public func unlock() {
        let result = pthread_mutex_unlock(&_lock)
        assert(result == 0, "Failed to unlock mutex in \(self)")
    }

    deinit {
        let result = pthread_mutex_destroy(&_lock)
        assert(result == 0, "Failed to destroy mutex in \(self)")
    }

}

extension Lock {
    public func withCriticalScope<Result>(@noescape body: () throws -> Result) rethrows -> Result {
        lock()
        defer { unlock() }
        return try body()
    }
}