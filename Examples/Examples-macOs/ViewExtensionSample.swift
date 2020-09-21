//
//  ViewExtensionSample.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 24/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import Cocoa

class ViewExtensionSample: NSView {

    let spacing:CGFloat =  30
    let titles:[String] = [".spring()",
                           ".zoomIn()",
                           ".zoomOut()",
                           ".pop()",
                           ".fadeIn()",
                           ".fadeOut()",
                           ".flyLeft()",
                           ".flyRight()",
                           ".flyTop()",
                           ".flyBottom()",
                           ".slideLeft()",
                           ".slideRight()",
                           ".slideTop()",
                           ".slideBottom()",
                           ".flipX()",
                           ".flipY()",
                           ".shake()",
                           ".jiggle()",
                           ".bounce()",
                           ".swing()",
                           ".spin()",
                           ".spin(clockwise:false)",
                           ".loop()"]
    
    var buttons:[NSButton] = []
    var looping = false
    var playAllButton = NSButton()
    
    override init(frame: CGRect) {
        
        let cols = 6
        let rows = 4
        let size = CGSize(width: (frame.size.width - spacing) / CGFloat( cols ) - spacing,
                          height: (frame.size.height - spacing) / CGFloat( rows ) - spacing)
        
        super.init(frame: frame)
        //Create a target
        
        var x = 0
        var y = 0
        let c:CGFloat = 0.5 / CGFloat( titles.count )
        
        //Create a grid
        for i in 0 ..< titles.count {
            let button = NSButton(frame:CGRect(x:spacing + (size.width + spacing) * CGFloat( x ),
                                               y:frame.size.height - ( (size.height + spacing) * CGFloat( y ) ) - (size.height + spacing),
                                               width:size.width,
                                               height:size.height))
            button.title = titles[i]
            button.wantsLayer = true
            button.layer?.backgroundColor = NSColor.init(hue: 0.5 + c * CGFloat(i), saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            button.layer?.cornerRadius = 10.0
            button.target = self
            button.action = #selector(click)
            button.isBordered = false
            buttons.append(button)
            addSubview(button)
            
            x += 1
            if x >= cols { x = 0; y += 1 }
        }

        //Try all!
        playAllButton.frame =  CGRect(x:spacing + (size.width + spacing) * CGFloat( x ),
                                      y:frame.size.height - ( (size.height + spacing) * CGFloat( y ) ) - (size.height + spacing),
                                      width:size.width,
                                      height:size.height)
        playAllButton.title = "Play all!"
        playAllButton.wantsLayer = true
        playAllButton.layer!.backgroundColor = .black
        playAllButton.layer?.cornerRadius = 10.0
        playAllButton.target = self
        playAllButton.action = #selector(play)
        addSubview(playAllButton)
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {self.playAll() }
        
    }
    
    @objc func click(_ sender: NSButton){

        switch buttons.firstIndex(of: sender) {
        case 0:
            sender.spring()
        case 1:
            sender.zoomIn()
            sender.fadeIn()
        case 2:
            sender.zoomOut()
            sender.fadeIn()
        case 3:
            sender.pop()
        case 4:
            sender.fadeIn()
        case 5:
            sender.fadeOut()
            //Show again!
            .after()
            .delay(1.0)
            .duration(0.15)
            .keys(to: [\CALayer.opacity : 1.0])
            .play()
        case 6:
            sender.flyLeft()
            sender.fadeIn()
        case 7:
            sender.flyRight()
            sender.fadeIn()
        case 8:
            sender.flyTop()
            sender.fadeIn()
        case 9:
            sender.flyBottom()
            sender.fadeIn()
        case 10:
            sender.slideLeft()
            sender.fadeIn()
        case 11:
            sender.slideRight()
            sender.fadeIn()
        case 12:
            sender.slideTop()
            sender.fadeIn()
        case 13:
            sender.slideBottom()
            sender.fadeIn()
        case 14:
            sender.flipX()
            .onComplete { sender.layer!.transform = CATransform3DIdentity }
        case 15:
            sender.flipY()
            .onComplete { sender.layer!.transform = CATransform3DIdentity }
        case 16:
            sender.shake()
        case 17:
            sender.jiggle()
        case 18:
            sender.bounce()
        case 19:
            sender.swing()
        case 20:
            sender.spin()
        case 21:
            sender.spin(clockwise:false)
        case 22:
            if looping { sender.stopLoop()} else { sender.loop()}
            looping = !looping
            sender.title = looping ? ".stopLoop()" : ".loop()"
        default:
            break
        }
    }
    
    @objc func play(_ sender: NSButton){ playAll() }
    
    func playAll(){
        for (index, _) in buttons.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 * Double( index )) { self.click( self.buttons[ index ] ) }
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
