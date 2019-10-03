//
//  PauseTweens.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/14/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class PauseTweens:UIView, FreezeProtocol
{
    let clouds1 = UIView()
    let clouds2 = UIView()
    let clouds3 = UIView()
    
    let pauseButton = UIButton()
    var paused:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.0/255.0,
                                       green:230.0/255.0,
                                       blue:240.0/255,
                                       alpha:1.0)
        clipsToBounds = true
        
        let screenSize = UIScreen.main.bounds.size
        
        let pdfView = PDFImageView()
        pdfView.loadFromBundle("clouds1")
        
        clouds1.frame = pdfView.bounds
        clouds1.backgroundColor = UIColor(patternImage: pdfView.image!)
        clouds1.frame = CGRect(x:0.0,
                                        y:screenSize.height * 0.2,
                                        width:clouds1.frame.size.width * 2.0,
                                        height:clouds1.frame.size.height)
        addSubview(clouds1)
        
        pdfView.loadFromBundle("clouds2")
        clouds2.frame = pdfView.bounds
        clouds2.backgroundColor = UIColor(patternImage: pdfView.image!)
        clouds2.frame = CGRect(x:0.0,
                                    y:screenSize.height * 0.35,
                                    width:clouds2.frame.size.width * 2.0,
                                    height:clouds2.frame.size.height)
        addSubview(clouds2)
        
        pdfView.loadFromBundle("clouds3")
        clouds3.frame = pdfView.bounds
        clouds3.backgroundColor = UIColor(patternImage: pdfView.image!)
        clouds3.frame = CGRect(x:0.0,
                                    y:screenSize.height * 0.5,
                                    width:clouds3.frame.size.width * 2.0,
                                    height:clouds3.frame.size.height)
        addSubview(clouds3)

        cloud1Tween()
        cloud2Tween()
        cloud3Tween()
        
        //Freeze
        freeze()
        
        pauseButton.frame = CGRect(x:20.0,
                                       y:frame.size.height -  70.0,
                                       width:frame.size.width - 40.0,
                                       height:50.0)
        
        pauseButton.setTitle("PAUSE TWEENS", for: .normal)
        pauseButton.addTarget(self, action: #selector(playPause), for: .touchUpInside)
        pauseButton.setTitleColor(UIColor.white, for: .normal)
        pauseButton.backgroundColor = UIColor(red:0.0/255.0, green:230.0/255.0, blue:240.0/255, alpha:1.0)
        pauseButton.layer.cornerRadius = 7.0
        addSubview(pauseButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playPause()
    {
    paused = !paused
    
        if (paused)
        {
            pauseButton.setTitle("RESUME TWEENS", for: .normal)
            Tweener.pauseTweens(target:clouds1)
            Tweener.pauseTweens(target:clouds2)
            Tweener.pauseTweens(target:clouds3)
        }
        else
        {
            pauseButton.setTitle("PAUSE TWEENS", for: .normal)
            Tweener.resumeTweens(target:clouds1)
            Tweener.resumeTweens(target:clouds2)
            Tweener.resumeTweens(target:clouds3)
        }
    }
    
    func cloud1Tween()
    {
        var newFrame = clouds1.frame
        newFrame.origin.x = -clouds1.frame.size.width / 2.0
        
        Tween(target:clouds1, duration:6.0, ease:Ease.none, delay: 0.0,
               keys:[\UIView.frame:newFrame],
              completion: {
                var resetFrame = self.clouds1.frame
                resetFrame.origin.x = 0.0
                self.clouds1.frame = resetFrame
                self.cloud1Tween()
        }).play()
    }
    
    
    func cloud2Tween()
    {
        var newFrame = clouds2.frame
        newFrame.origin.x = -clouds2.frame.size.width / 2.0
        
        Tween(target:clouds2,
              duration:4.0,
              ease:Ease.none,
              delay:0.0,
              keys:[\UIView.frame:newFrame],
              completion:{
                var resetFrame = self.clouds2.frame
                resetFrame.origin.x = 0
                self.clouds2.frame = resetFrame
                self.cloud2Tween()
        }).play()
    }
    
    func cloud3Tween()
    {
        var newFrame = clouds3.frame
        newFrame.origin.x = -clouds3.frame.size.width / 2.0
        
        Tween(target:clouds3,
              duration:2.0,
              ease:Ease.none,
              delay:0.0,
              keys:[\UIView.frame:newFrame],
              completion:{
                var resetFrame =  self.clouds3.frame
                resetFrame.origin.x = 0
                self.clouds3.frame = resetFrame
                self.cloud3Tween()}
            ).play()
    }
    
    func freeze()
    {
        if(!paused){playPause()}
    }
    
    func warm()
    {
        if(paused){playPause()}
    }
    
}
