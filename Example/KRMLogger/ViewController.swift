//
//  ViewController.swift
//  Logger
//
//  Created by asowers on 04/25/2016.
//  Copyright (c) 2016 asowers. All rights reserved.
//

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

