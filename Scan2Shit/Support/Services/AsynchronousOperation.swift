//
//  AsynchronousOperation.swift
//  SongsTransfer
//
//  Created by cuongab on 4/19/19.
//  Copyright © 2019 HCM. All rights reserved.
//

import Foundation
/// https://gist.github.com/Sorix/57bc3295dc001434fe08acbb053ed2bc
/// Subclass of `Operation` that add support of asynchronous operations.
/// ## How to use:
/// 1. Call `super.main()` when override `main` method, call `super.start()` when override `start` method.
/// 2. When operation is finished or cancelled set `self.state = .finished`
class AsynchronousOperation: Operation {
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
        }
    }
}
