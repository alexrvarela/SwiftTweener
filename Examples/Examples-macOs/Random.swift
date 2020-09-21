//
//  Random.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 10/09/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import AppKit
import Tweener

class Random: NSView {

    var button:NSButton!
    var dots:[NSView] = []
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        for _ in 1...100 {
            let size  = CGFloat.random(in: 25.0 ... 200)
            let dot = NSView(frame: CGRect(x:CGFloat.random(in: 0.0 ... frame.size.width - size),
                                           y:CGFloat.random(in: 0.0 ... frame.size.height - size),
                                           width:size,
                                           height:size))
            dot.wantsLayer = true
            dot.layer?.backgroundColor = NSColor.init(hue: CGFloat.random(in: 0 ..< 1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            dot.layer!.cornerRadius = size / 2
            dots.append(dot)
            addSubview(dot)
        }
        
         //Create a button
         button = NSButton(frame: CGRect(x:( frame.size.width - 200 ) / 2.0 ,
                                         y:20.0,
                                         width:200,
                                         height:50.0))
         button.wantsLayer = true
         button.title = "ANIMATE"
         button.target = self
         button.action = #selector(animate)
         button.layer?.backgroundColor = .black
         button.layer?.cornerRadius = 7.0
         addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func animate() {
        for dot in dots {
            Tween(target:dot)
                .ease(Ease.outBack)
                .duration(Double.random(in: 0.25 ... 2.0))
                .delay(Double.random(in: 0.25 ... 2.0))
                .keys(to: [\NSView.frame : CGRect(x: CGFloat.random(in: 0.0 ... frame.size.width - dot.frame.size.width),
                                                  y:CGFloat.random(in: 0.0 ... frame.size.height - dot.frame.size.height),
                                                  width:dot.frame.size.width,
                                                  height:dot.frame.size.height)])
                .play()
        }
    }
}
