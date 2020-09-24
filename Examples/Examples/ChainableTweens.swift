//
//  ChainableTweens.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 12/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

extension CAShapeLayer {
  static func rectangle(roundedRect: CGRect, cornorRadius: CGFloat, color: UIColor) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornorRadius)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = color.cgColor
        return shape
    }
}

//Rounded view
extension UIView {
    static func rounded(_ radius:CGFloat = 10) -> UIView {
        let view = UIView(frame:CGRect(x:0.0, y:0.0, width:100.0, height:100.0))
        view .layer.cornerRadius = radius
        return view
    }
}

//Generate randomColor
extension UIColor{
    public static func random() -> UIColor{
        return UIColor(hue: CGFloat.random(in: 0 ..< 1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}

class ChainableTweens: UIView, FreezeProtocol {

    var squares:[UIView] = [UIView.rounded(), UIView.rounded(), UIView.rounded(), UIView.rounded()]

    let square:UIView = {
        let view = UIView.rounded(10)
        view.backgroundColor = UIColor.random()
        view.alpha = 0.5
        return view
    }()
        
    let button:UIButton = {
        let button = UIButton()
        button.setTitle("PLAY TIMELINE", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    //Retain timeline
    let timeline = Timeline()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Add background squares
       for sqr in squares{
            sqr.backgroundColor = .black
            sqr.alpha = 0.05
            sqr.layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -100)
            addSubview(sqr)
       }
       //Align background squares
       squares[0].center = CGPoint(x: center.x - 60.0, y: center.y - 60.0)
       squares[1].center = CGPoint(x: center.x + 60.0, y: center.y - 60.0)
       squares[2].center = CGPoint(x: center.x + 60.0, y: center.y + 60.0)
       squares[3].center = CGPoint(x: center.x - 60.0, y: center.y + 60.0)
        
        //Add square
        let spacing = square.frame.size.width / 2.0 + 20.0
        square.center = CGPoint(x: spacing, y: spacing)
        addSubview( square )
       
        //Set initial position
        square.center = squares[0].center
        
        //Add button
        addSubview(button)
        button.frame = CGRect(x:20.0, y:frame.size.height - 70.0, width:frame.size.width - 40.0, height:50.0)
        button.addTarget(self, action: #selector(playTimeline), for: .touchUpInside)
        
        //Add to timeline using declarative syntax:
        timeline.add(

            //Tween 1, start chain
            Tween(target: square)
            .ease(.inOutQuad)
            .keys(to:[\UIView.center : squares[1].center])
            .onStart {
                //Change color
                Tween(target: self.square).keys(to: [\UIButton.backgroundColor! : UIColor.random()] ).play()
                self.square.flipX(inverted: true)
            }
            .onComplete { print("Tween 1 complete") }
            
            //Tween 2
            .after()
            .keys(to:[\UIView.center : squares[2].center])
            .onStart {
                //Change color
                Tween(target: self.square).keys(to: [\UIButton.backgroundColor! : UIColor.random()] ).play()
                self.square.flipY()
            }
            .onComplete { print("Tween 2 complete") }
            
            //Tween 3
            .after()
            .keys(to:[\UIView.center : squares[3].center])
            .onStart {
                //Change color
                Tween(target: self.square).keys(to: [\UIButton.backgroundColor! : UIColor.random()] ).play()
                self.square.flipX()
            }
            .onComplete { print("Tween 3 complete") }
            
            //Tween 4
            .after()
            .keys(to:[\UIView.center : squares[0].center])
            .onStart {
                //Change color
                Tween(target: self.square).keys(to: [\UIButton.backgroundColor! : UIColor.random()] ).play()
                self.square.flipY(inverted: true)
            }
            .onComplete { print("Tween 4 complete") }
            
        ).mode( .loop )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playTimeline(){
        if timeline.isPlaying(){ timeline.pause() } else { timeline.play() }
        
        button.setTitle(timeline.isPlaying() ? "PAUSE TIMELINE" : "PLAY TIMELINE", for: .normal)
    }
    
    func freeze() { if timeline.isPlaying(){ timeline.pause() } }
    
    func warm(){ }
}
