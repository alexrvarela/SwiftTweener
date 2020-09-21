//
//  SimpleTween.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 21/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import Cocoa
import Tweener

class SimpleTween: NSView {
    
    var square:NSView!
    
    var button:NSButton = {
        //Create a button
        let btn = NSButton()
        btn.wantsLayer = true
        btn.title = "ADD TWEEN"
        btn.layer?.backgroundColor = .black
        btn.layer?.cornerRadius = 7.0
        return btn
    }()
       
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        button.frame = CGRect(x:( frame.size.width - 200 ) / 2.0 ,
                              y:20.0,
                              width:200,
                              height:50.0)
        button.target = self
        button.action = #selector(addTween)
        addSubview(button)
        
        //Create a target
        square = NSView(frame:CGRect(x:20.0, y:self.frame.size.height - 100 - 20.0, width:100.0, height:100.0))
        square.wantsLayer = true
        square.layer?.backgroundColor = .init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        square.layer?.cornerRadius = 10.0
        addSubview(square)
        

   }
   
   required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
   
   @objc func addTween() {
    
        Tween(target:square)//Target
        .duration(0.75)//Duration in seconds
        .ease( Ease.inOutCubic )//Animation curve
        .keys(from: [\NSView.alphaValue:0.25,
                     \NSView.frame:CGRect(x:20.0,
                                          y:frame.size.height - 100 - 20.0,
                                          width:100.0,
                                          height:100.0)],
              to: [\NSView.alphaValue:1.0,
                   \NSView.frame:CGRect(x: frame.size.width - 280.0 - 20.0,
                                        y:frame.size.height - 280.0 - 20.0,
                                        width:280.0,
                                        height:280.0)])
        .onComplete { print("Tween 1 complete") }
        .after()//Creates a new tween after with same target and properties.
        .duration(1.0)
        .ease(Ease.outBounce)
        .keys(to: [\NSView.alphaValue:0.25, \NSView.frame:CGRect(x:20.0, y:frame.size.height - 100 - 20.0, width:100.0, height:100.0)])
        .onComplete { print("Tween 2 complete") }
        .play()
    }
}
