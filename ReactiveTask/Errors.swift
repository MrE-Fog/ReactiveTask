//
//  Errors.swift
//  ReactiveTask
//
//  Created by Justin Spahr-Summers on 2014-12-01.
//  Copyright (c) 2014 Carthage. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// An error originating from ReactiveTask.
public enum TaskError: ErrorType {
	/// A shell task exited unsuccessfully.
	case ShellTaskFailed(Task, exitCode: Int32, standardError: String?)

	/// An error was returned from a POSIX API.
	case POSIXError(Int32)
}

extension TaskError: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .ShellTaskFailed(task, exitCode, standardError):
			var description = "A shell task (\(task)) failed with exit code \(exitCode)"
			if let standardError = standardError {
				description += ":\n\(standardError)"
			}

			return description

		case let .POSIXError(code):
			return NSError(domain: NSPOSIXErrorDomain, code: Int(code), userInfo: nil).description
		}
	}
}

extension TaskError: Equatable {}

public func ==(lhs: TaskError, rhs: TaskError) -> Bool {
	switch (lhs, rhs) {
	case (.ShellTaskFailed(let lhsTask, let lhsCode, let lhsErr), .ShellTaskFailed(let rhsTask, let rhsCode, let rhsErr)):
		return lhsTask == rhsTask && lhsCode == rhsCode && lhsErr == rhsErr
	case (.POSIXError(let lhsCode), .POSIXError(let rhsCode)):
		return lhsCode == rhsCode
	default:
		return false
	}
}
