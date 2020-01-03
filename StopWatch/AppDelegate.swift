//
//  AppDelegate.swift
//  StopWatch
//
//  Created by Sovanna Hing on 25/11/2019.
//  Copyright © 2019 Sovanna Hing. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var labelStart = "00:00:00"
    var timerWatch = Timer()
    var watchHasStarted = false
    var watchCounter = 0 {
        didSet {
            updateStatusItem(time: TimeInterval(watchCounter))
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let item = statusItem {
            item.button?.title = labelStart
            
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Start", action: #selector(self.startWatch(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Reset", action: #selector(self.resetWatch(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            if statusItem != nil {
                statusItem?.menu = menu
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timerWatch.invalidate()
    }
    
    func updateStatusItem(time: TimeInterval) {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if statusItem != nil {
            statusItem?.button?.title = String(
                format: "%02i:%02i:%02i",
                hours, minutes, seconds)
        }
    }

    @objc func startWatch(_ sender: Any?) {
        if watchHasStarted {
            self.pauseWatch(sender)
            return
        }
        
        watchHasStarted = true
        statusItem?.menu?.item(at: 0)?.title = "Pause"
        
        timerWatch = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.update(_:)),
            userInfo: nil,
            repeats: true);
        
        RunLoop.main.add(self.timerWatch, forMode: .common)
    }
    
    @objc func update(_ sender: Any?) {
        watchCounter += 1
    }
    
    @objc func pauseWatch(_ sender: Any?) {
        if watchHasStarted {
            timerWatch.invalidate()
            watchHasStarted = false
            statusItem?.menu?.item(at: 0)?.title = "Resume"
        }
    }
    
    @objc func resetWatch(_ sender: Any?) {
        timerWatch.invalidate()
        watchCounter = 0
        watchHasStarted = false
        statusItem?.menu?.item(at: 0)?.title = "Start"
    }
}

