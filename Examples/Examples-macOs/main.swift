//
//  main.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 21/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import AppKit

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
NSApplication.shared.mainMenu = NSMenu(title: "Main Menu")
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
