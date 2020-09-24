//
//  TweenChain.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 14/09/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import Cocoa
import Tweener

class TweenChain: NSView {

    var squares:[NSView] = [NSView.rounded(), NSView.rounded(), NSView.rounded(), NSView.rounded()]

    let square:NSView = {
       let view = NSView.rounded(10)
       view.layer!.backgroundColor = NSColor.random().cgColor
       view.layer!.opacity = 0.5
       return view
      }()

    var button:NSButton = {
       //Create a button
       let btn = NSButton()
       btn.wantsLayer = true
       btn.title = "PLAY"
       btn.layer?.backgroundColor = .black
       btn.layer?.cornerRadius = 7.0
       return btn
    }()

    //Retain timeline
    let timeline = Timeline()

    override init(frame: CGRect) {
        super.init(frame: frame)

        //Add background squares
        for sqr in squares{
           sqr.layer!.opacity = 0.05
           sqr.layer!.backgroundColor = NSColor.black.cgColor
           sqr.layer!.transform = CATransform3DMakeTranslation(0.0, 0.0, -100)
           addSubview(sqr)
        }
        
        //Align background squares
        squares[0].center(CGPoint(x: center().x - 60.0, y: center().y + 60.0))
        squares[1].center(CGPoint(x: center().x + 60.0, y: center().y + 60.0))
        squares[2].center(CGPoint(x: center().x + 60.0, y: center().y - 60.0))
        squares[3].center(CGPoint(x: center().x - 60.0, y: center().y - 60.0))

        //Add square
        let spacing = square.frame.size.width / 2.0 + 20.0
        square.center(CGPoint(x: spacing, y: spacing))
        square.layerContentsRedrawPolicy = .onSetNeedsDisplay
        addSubview( square )

        //Set initial position
        square.center(squares[0].center())

        //Add button
        button.frame = CGRect(x:( frame.size.width - 200 ) / 2.0 ,
                             y:20.0,
                             width:200,
                             height:50.0)
        button.target = self
        button.action = #selector(playTimeline)
        addSubview(button)

        //Add tween chain to timeline:
        timeline.add(

            //Tween 1, start chain
            Tween(target: square)
            .duration(0.5)
            .ease(.inOutQuad)
            .keys(to:[\NSView.frame : squares[1].frame])
            .onComplete{self.square.layer!.backgroundColor = NSColor.random().cgColor }
            //Tween 2, create a tween after.
            .after()
            .keys(to:[\NSView.frame : squares[2].frame])
            .onComplete{self.square.layer!.backgroundColor = NSColor.random().cgColor }
            //Tween 3, create a tween after.
            .after()
            .keys(to:[\NSView.frame : squares[3].frame])
            .onComplete{self.square.layer!.backgroundColor = NSColor.random().cgColor }
            //Tween 4, create a tween after.
            .after()
            .keys(to:[\NSView.frame : squares[0].frame])
            .onComplete{self.square.layer!.backgroundColor = NSColor.random().cgColor }
   
        ).mode( .loop )
   
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc func playTimeline(){

       if timeline.isPlaying(){ timeline.pause() } else { timeline.play() }
       button.title = timeline.isPlaying() ? "PAUSE" : "PLAY"
    }
    
}
