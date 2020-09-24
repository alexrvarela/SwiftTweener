//
//  TimelineSample.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 14/09/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import Cocoa
import Tweener

//Rounded view
extension NSView {
    static func rounded(_ radius:CGFloat = 10, size:CGSize = CGSize(width:100.0, height:100.0)) -> NSView {
        let view = NSView(frame:CGRect(x:0.0, y:0.0, width:size.width, height:size.height))
        view.wantsLayer = true
        view.layer!.cornerRadius = radius
        return view
    }
}

//Generate randomColor
extension NSColor{
    public static func random() -> NSColor{
        return NSColor(hue: CGFloat.random(in: 0 ..< 1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}

class TimelineSample: NSView {

    let square:NSView = {
        let view = NSView.rounded(10, size:CGSize(width: 250, height: 250))
        view.layer!.backgroundColor = NSColor.random().cgColor
        view.layer!.opacity = 0.5
        return view
       }()
    
    var button:NSButton = {
        //Create a button
        let btn = NSButton()
        //Create a backed layer
        btn.wantsLayer = true
        btn.title = "PLAY TIMELINE"
        btn.layer?.backgroundColor = .black
        btn.layer?.cornerRadius = 7.0
        return btn
    }()
    
    //Retain timeline
    let timeline = Timeline()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //Add square
        addSubview( square )
        square.center(center())

        //Add button
        button.frame = CGRect(x:( frame.size.width - 200 ) / 2.0 ,
                              y:20.0,
                              width:200,
                              height:50.0)
        button.target = self
        button.action = #selector(playTimeline)
        addSubview(button)
        
        //Add to timeline using declarative syntax:
        timeline.add(
            //To prevent play imediatelly call remove()
            square.flipX(inverted: true).stop(),
            square.flipY().stop().delay(1.0),
            square.flipX().stop().delay(2.0),
            square.flipY(inverted: true).stop().delay(3.0)
        ).mode( .loop )
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func playTimeline(){
        
        square.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        if timeline.isPlaying(){ timeline.pause() } else { timeline.play() }
        button.title = timeline.isPlaying() ? "PAUSE TIMELINE" : "PLAY TIMELINE"
    }

}
