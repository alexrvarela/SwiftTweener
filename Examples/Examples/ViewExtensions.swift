//
//  ViewExtensions.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 12/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class ViewExtensions: UIScrollView {

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
                           ".spin(clockwise..",
                           ".loop()"]
    
    var buttons:[UIButton] = []
    var looping = false

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //Setup grid.
        let cols = 2
        let size = (frame.size.width - spacing) / CGFloat( cols ) - spacing
        var x = 0
        var y = 0
        var contentHeight:CGFloat = 0
        let c:CGFloat = 0.5 / CGFloat(titles.count)
        //Create a grid
        for i in 0 ..< titles.count {
            let button = UIButton(frame:CGRect(x:spacing + (size + spacing) * CGFloat( x ),
                                               y:spacing + (size + spacing) * CGFloat( y ),
                                               width:size,
                                               height:size))
            button.setTitleColor(.white, for: .normal)
            button.setTitle(titles[i], for: .normal)
            button.backgroundColor = UIColor(hue: 0.5 + c * CGFloat(i), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            button.layer.cornerRadius = 10.0
            button.addTarget(self, action: #selector(click), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
            
            contentHeight = button.frame.origin.y + button.frame.size.height + CGFloat( spacing )
            
            x += 1
            if x >= cols { x = 0; y += 1 }
        }

        self.contentSize = CGSize(width: bounds.width, height: contentHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func click(_ sender: UIButton){

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
            .duration(0.15)
            .to(.key(\.opacity, 1.0))//from:[\CALayer.opacity : 0.0],
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
            .onComplete { sender.layer.transform = CATransform3DIdentity }
        case 15:
            sender.flipY()
            .onComplete { sender.layer.transform = CATransform3DIdentity }
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
            sender.setTitle(looping ? ".stopLoop()" : ".loop()", for: .normal)
        default:
            break
        }
    }
    
    @objc func play(_ sender: UIButton){ playAll() }
    
    func playAll(){
        for (index, _) in buttons.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 * Double( index )) { self.click( self.buttons[ index ] ) }
        }
    }


}
