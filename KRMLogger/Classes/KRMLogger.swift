//
//  KRMLogger.swift
//  Pods
//
//  Created by Andrew Sowers on 4/25/16.
//
//

import Foundation

public enum LogLevel: Int {
    case Severe = 0
    case Error = 1
    case Warn = 2
    case Info = 3
    case Debug = 4
    case Trace = 5
    
    public var label: String {
        switch self {
        case .Severe: return "SEVERE"
        case .Error: return "ERROR"
        case .Warn: return "WARN"
        case .Info: return "INFO"
        case .Debug: return "DEBUG"
        case .Trace: return "TRACE"
        }
    }
}

public protocol LogFormatter {
    func format<T>(logger: KRMLogger, level: LogLevel, value: T) -> String
}

public class DefaultFormatter: LogFormatter {
    public init() {}
    public func format<T>(logger: KRMLogger, level: LogLevel, value: T) -> String {
        return "\(NSDate().description) \(level.label) \(logger.name): \(self.messageFor(value))"
    }
    
    func messageFor<T>(value: T) -> String {
        if let value = value as? Streamable {
            var string =  ""
            value.writeTo(&string)
            return string
        } else if let value = value as? CustomStringConvertible {
            return value.description
        } else if let value = value as? CustomDebugStringConvertible {
            return value.debugDescription
        }
        return Mirror(reflecting: value).description
    }
}

public protocol LogDestination {
    var formatter: LogFormatter { get set }
    func log<T>(logger: KRMLogger, level: LogLevel, value: T)
}

public protocol ConsoleLoggerDelegate {
    func consoleLog(msg: String)
}

public class Console: LogDestination {
    public var formatter: LogFormatter = DefaultFormatter()
    public var delegate: ConsoleLoggerDelegate?
    public init() {}
    
    public func log<T>(logger: KRMLogger, level: LogLevel, value: T) {
        let msg = self.formatter.format(logger, level: level, value: value)
        self.delegate?.consoleLog(msg)
        flockfile(stdout)
        print(msg)
        funlockfile(stdout)
    }
}

public class KRMLogger {
    public let name: String
    public let destinations: [LogDestination]
    public let level: LogLevel
    
    public let queue: dispatch_queue_t?
    
    public init(name: String, destinations: [LogDestination] = [Console()], level: LogLevel = .Trace, queue: dispatch_queue_t? = dispatch_queue_create("com.Karma.KRMLogger", nil)) {
        self.name = name
        self.destinations = destinations
        self.level = level
        self.queue = queue
    }
    
    public func log<T>(level: LogLevel, _ value: T) {
        let closure: dispatch_block_t = {
            if level.rawValue <= self.level.rawValue {
                self.destinations.forEach {
                    $0.log(self, level: level, value: value)
                }
            }
        }
        
        if let queue = self.queue {
            dispatch_async(queue, closure)
        } else {
            closure()
        }
    }
    
    public func severe<T>(value: T) {
        self.log(.Severe, value)
    }
    
    public func error<T>(value: T) {
        self.log(.Error, value)
    }
    
    public func warn<T>(value: T) {
        self.log(.Warn, value)
    }
    
    public func info<T>(value: T) {
        self.log(.Info, value)
    }
    
    public func debug<T>(value: T) {
        self.log(.Debug, value)
    }
    
    public func trace<T>(value: T) {
        self.log(.Trace, value)
    }
}