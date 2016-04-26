# KRMLogger

#[![CI Status](http://img.shields.io/travis/asowers/KRMLogger.svg?style=flat)](https://travis-ci.org/asowers/KRMLogger)
[![Version](https://img.shields.io/cocoapods/v/KRMLogger.svg?style=flat)](http://cocoapods.org/pods/KRMLogger)
[![License](https://img.shields.io/cocoapods/l/KRMLogger.svg?style=flat)](http://cocoapods.org/pods/KRMLogger)
[![Platform](https://img.shields.io/cocoapods/p/KRMLogger.svg?style=flat)](http://cocoapods.org/pods/KRMLogger)

## Description

KRMLogger is an asynchronous console event logger. KRMLogger supports multiple log sources and log levels. The example project includes an interactive example of using the Logger in your project.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Example

```Swift
import UIKit
import KRMLogger

class ViewController: UIViewController, ConsoleLoggerDelegate {

    @IBOutlet weak var logLevel: UISegmentedControl!
    @IBOutlet weak var logMessageTextView: UITextView!
    @IBOutlet weak var logRecordTextView: UITextView!

    var logger: KRMLogger?
    let console = Console()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logger = KRMLogger(name: "com.logger-example.logger", destinations: [self.console])
        self.console.delegate = self
    }
    
    func consoleLog(msg: String) {
        self.updateLogRecordOnMainThread((self.logRecordTextView?.text ?? "") + "\(msg)\n")
    }
    
    func updateLogRecordOnMainThread(text: String) {
        dispatch_async(dispatch_get_main_queue(),{
            self.logRecordTextView?.text = text
        })
    }

    @IBAction func didTapClearLog(sender: AnyObject) {
        self.updateLogRecordOnMainThread("")
    }
    
    
    @IBAction func didTapLogEntryButton(sender: AnyObject) {
        self.logger?.log(LogLevel(rawValue: self.logLevel.selectedSegmentIndex)!, self.logMessageTextView.text)
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.logMessageTextView?.resignFirstResponder()
    }
}
```

![Alt text](https://github.com/yourkarma/KRMLogger/blob/master/KRMLogger/Assets/logger.png?raw=true "Logger Example")

## Requirements

## Installation

KRMLogger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KRMLogger"
```

## Author

asowers1, asow123@gmail.com

## License

KRMLogger is available under the MIT license. See the LICENSE file for more info.
