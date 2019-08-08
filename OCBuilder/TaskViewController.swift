//
//  TaskViewController.swift
//  OCBuilder
//
//  Created by Pavo on 7/27/19.
//  Copyright © 2019 Pavo. All rights reserved.
//

import Cocoa

class TaskViewController: NSViewController {
    
    @IBOutlet var pathLocation: NSPathControl!
    @IBOutlet var outputText: NSTextView!
    @IBOutlet var buildButton: NSButton!
    @IBOutlet var progressBar: NSProgressIndicator!
    @IBOutlet var stopButton: NSButton!
    
    override func viewDidLoad() {
        stopButton.isEnabled = false
        progressBar.isHidden = true
        super.viewDidLoad()
        if (NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: "com.apple.dt.Xcode") != nil) {
            buildButton.isHidden = false
        } else {
            showCloseAlert()
            buildButton.isHidden = true
            pathLocation.isHidden = true
        }
    }
    
    @objc dynamic var isRunning = false
    var outputPipe:Pipe!
    var buildTask:Process!
    
    @IBAction func startTask(_ sender: Any) {
        stopButton.isEnabled = true
        progressBar.isHidden = false
        outputText.string = ""
        if let repositoryURL = pathLocation.url {
            let cloneLocation = "/tmp"
            let finalLocation = repositoryURL.path
            let nasm = "/usr/local/bin/nasm"
            let mtoc = "/usr/local/bin/mtoc"
            guard let nasmPath = Bundle.main.path(forResource: "nasm", ofType: "") else {
                print("Unable to locate nasm")
                return
            }
            guard let ndisasmPath = Bundle.main.path(forResource: "ndisasm", ofType: "") else {
                print("Unable to locate nasm")
                return
            }
            guard let mtocPath = Bundle.main.path(forResource: "mtoc", ofType: "") else {
                print("Unable to locate mtoc")
                return
            }
            guard let mtocNewPath = Bundle.main.path(forResource: "mtoc", ofType: "NEW") else {
                print("Unable to locate mtoc")
                return
            }
            guard let pythonPath = Bundle.main.path(forResource: "python-3.7.4-macosx10.9", ofType: "pkg") else {
                print("Unable to locate python")
                return
            }
            
            var arguments:[String] = []
            arguments.append(cloneLocation)
            arguments.append(finalLocation)
            arguments.append(nasm)
            arguments.append(mtoc)
            arguments.append(nasmPath)
            arguments.append(mtocPath)
            arguments.append(pythonPath)
            arguments.append(ndisasmPath)
            arguments.append(mtocNewPath)
            buildButton.isEnabled = false
            progressBar.startAnimation(self)
            runInstallRequiredToolsScript(arguments)
        }
    }
    
    
    @IBAction func stopTask(_ sender: Any) {
        stopButton.isEnabled = false
        progressBar.isHidden = true
        if isRunning {
            self.progressBar.doubleValue = 0.0
            buildTask.terminate()
        }
    }
    
    func runInstallRequiredToolsScript(_ arguments:[String]) {
        isRunning = true
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        taskQueue.async {
            guard let path = Bundle.main.path(forResource: "installrequiredtools",ofType:"command") else {
                print("Unable to locate installrequiredtools.command")
                return
            }
            self.buildTask = Process()
            self.buildTask.launchPath = path
            self.buildTask.arguments = arguments
            self.buildTask.terminationHandler = {
                task in
                DispatchQueue.main.async(execute: {
                    self.stopButton.isEnabled = false
                    self.buildButton.isEnabled = true
                    self.progressBar.isHidden = true
                    self.progressBar.stopAnimation(self)
                    self.progressBar.doubleValue = 0.0
                    self.isRunning = false
                })
            }
            self.captureStandardOutputAndRouteToTextView(self.buildTask)
            self.buildTask.launch()
            self.buildTask.waitUntilExit()
        }
    }
    
    func captureStandardOutputAndRouteToTextView(_ task:Process) {
        outputPipe = Pipe()
        task.standardOutput = outputPipe
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
            DispatchQueue.main.async(execute: {
                let previousOutput = self.outputText.string
                let nextOutput = previousOutput + "\n" + outputString
                self.outputText.string = nextOutput
                let range = NSRange(location:nextOutput.count,length:0)
                self.outputText.scrollRangeToVisible(range)
                self.progressBar.increment(by: 2.9)
            })
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
    
    func showCloseAlert() {
        let alert = NSAlert()
        alert.messageText = "Xcode Application is not installed!"
        alert.informativeText = "In order to use OCBuilder you must have the full Xcode application installed. Please install the full Xcode application from https://apps.apple.com/us/app/xcode/id497799835?mt=12."
        alert.alertStyle = .critical
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
