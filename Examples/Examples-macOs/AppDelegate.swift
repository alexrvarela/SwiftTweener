//
//  AppDelegate.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 14/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import AppKit
import Tweener

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window:NSWindow!
    let mainView = NSView()
    var statusBarItem: NSStatusItem!
    var samplesMenu:NSMenu!
    
    var sampleIndex:Int = 0 {
        willSet{
            samplesMenu?.item(at: sampleIndex)?.state = .off
        }
        didSet{
            samplesMenu?.item(at: sampleIndex)?.state = .on
            Tween(target:self.mainView)
                .duration(0.75)
                .ease(.outQuad)
                .to(.key(\.frame, CGRect(x: -window.frame.size.width * CGFloat( sampleIndex ),
                                         y: mainView.frame.origin.y,
                                         width: mainView.frame.size.width,
                                         height: mainView.frame.size.height)))
                .play()
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //Sizing
        let windowSize = NSSize(width: 1024, height: 600)
        let screenSize = NSScreen.main?.frame.size ?? .zero
        let windowRect = NSMakeRect(screenSize.width/2 - windowSize.width/2,
                                    screenSize.height/2 - windowSize.height/2,
                                    windowSize.width,
                                    windowSize.height)
        //Create a window
        window = NSWindow(contentRect: windowRect,
                          styleMask: [.miniaturizable, .closable, .titled],
                          backing: .buffered,
                          defer: false)
        window.contentView = mainView
        window.makeKeyAndOrderFront(nil)
        
        //Create Main view
        mainView.wantsLayer = true
        mainView.frame.size = windowSize
        mainView.layer?.backgroundColor = .white
        
        //Build Main Menu
        createMenu()
        
        //Add Samples and add to Menu.
        mainView.addSubview( ViewExtensionSample(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "NSview extensions", action: #selector(selectSample), keyEquivalent: "1"), at: 0)
        samplesMenu?.item(at: 0)?.state = .on
        
        mainView.addSubview( SimpleTween(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "Simple Tween", action: #selector(selectSample), keyEquivalent: "2"), at: 1)
        
        mainView.addSubview( PathSample(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "Path Tweens", action: #selector(selectSample), keyEquivalent: "3"), at: 2)
        
        mainView.addSubview( Random(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "Random Tweens", action: #selector(selectSample), keyEquivalent: "4"), at: 3)
        
        mainView.addSubview( TimelineSample(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "Timeline", action: #selector(selectSample), keyEquivalent: "5"), at: 4)
        
        mainView.addSubview( TweenChain(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "Tween chain", action: #selector(selectSample), keyEquivalent: "6"), at: 5)
        
        mainView.addSubview( StringSample(frame: mainView.bounds) )
        samplesMenu.insertItem(NSMenuItem( title: "Animate Text", action: #selector(selectSample), keyEquivalent: "7"), at: 6)
        
        //Align samples
        var x:CGFloat = 0.0
        for view in mainView.subviews{
            view.frame.origin.x = x
            x = x + mainView.bounds.size.width
        }
        
        //Update main view width.
        mainView.frame.size.width = x
    }
    
    @objc func selectSample(_ sender: NSMenuItem){
        //Get selected index
        if let selectedIndex:Int = samplesMenu.items.firstIndex(of: sender){
            sampleIndex = selectedIndex
        }
    }
    
    func createMenu(){
        
        //Create Root item
        let rootMenuItem = NSMenuItem( title: "Examples Menu", action: nil, keyEquivalent: "" )
        NSApplication.shared.mainMenu?.addItem(rootMenuItem)
        
        //Create root menu
        samplesMenu = NSMenu(title: "Examples")
        NSApplication.shared.mainMenu?.setSubmenu(samplesMenu, for: rootMenuItem)
        
        //Add github launch
        samplesMenu.addItem(NSMenuItem.separator())
        let gitHubMenuItem = NSMenuItem( title: "View on GitHub", action: #selector(visitGithubSite), keyEquivalent: "")
        samplesMenu.addItem(gitHubMenuItem)
        
        //Add quit option
        samplesMenu.addItem(NSMenuItem.separator())
        let quitMenuItem = NSMenuItem( title: "Quit Examples", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        samplesMenu.addItem(quitMenuItem)
    }
    
    @objc func visitGithubSite(){
        if let url = URL(string: "https://github.com/alexrvarela/SwiftTweener/"){
            NSWorkspace.shared.open(url)
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        NSMenu.setMenuBarVisible(true)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
