//
//  ScrollTimeline.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/10/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class ScrollTimeline:UIView, UIScrollViewDelegate
{
    let scrollview:UIScrollView = UIScrollView()
    let container:UIView = UIView()
    let timeline:Timeline = Timeline()
    
    let stars:PDFImageView = PDFImageView(bundlename:"stars")
    let comet:PDFImageView = PDFImageView(bundlename:"comet")
    let sun:PDFImageView = PDFImageView(bundlename:"sun")
    let earth:PDFImageView = PDFImageView(bundlename:"earth")
    let mars:PDFImageView = PDFImageView(bundlename:"mars")
    let jupyter:PDFImageView = PDFImageView(bundlename:"jupyter")
    let saturn:PDFImageView = PDFImageView(bundlename: "saturn")
    let ufo:PDFImageView = PDFImageView(bundlename:"ufo")
    let fire:PDFImageView = PDFImageView(bundlename:"fire")
    let rocket:PDFImageView = PDFImageView(bundlename: "rocket")
    let moon:PDFImageView = PDFImageView(bundlename: "moon")
    let spaceman:PDFImageView = PDFImageView(bundlename: "spaceman")
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //Setup instances
        backgroundColor = UIColor(red:52.0/255,
                                       green:52.0/255,
                                       blue:71.0/255,
                                       alpha:1.0)
        clipsToBounds = true
        
        scrollview.frame = bounds
        scrollview.contentSize = CGSize(width:scrollview.frame.size.width, height:3000.0)
        scrollview.contentInset = UIEdgeInsets.init(top: -225, left: 0, bottom: -225, right: 0)
        scrollview.delegate = self
        addSubview(scrollview)
        
        addSubview(stars)
        stars.center = center
        
        addSubview(comet)
        comet.center = center
        
        addSubview(sun)
        sun.scale = 4.0
        sun.center = center
        
        addSubview(earth)
        earth.center = center
        
        addSubview(mars)
        mars.center = center
        
        addSubview(jupyter)
        jupyter.center = center

        addSubview(saturn)
        saturn.center = center
        
        addSubview(ufo)
        ufo.center = center
        
        addSubview(fire)
        fire.center = center
        
        addSubview(rocket)
        rocket.center = center
        
        addSubview(moon)
        moon.scale = 5.0
        moon.center = center
        
        addSubview(spaceman)
        spaceman.center = center
        
        var nFrame:CGRect = fire.frame
        
        //ROCKET FIRE
        nFrame.origin.y  = rocket.frame.origin.y + 24.0
        fire.frame = nFrame//initial value
        nFrame.origin.y  = rocket.frame.origin.y + 24.0
        nFrame.origin.y  = rocket.frame.origin.y - fire.frame.size.height + 24.0///destination value

        timeline.add(Tween(target: fire, duration: 0.25, ease: .none, delay: 0.8, to: [.key(\.frame, nFrame)]))

        //SUN
        nFrame = sun.frame
        nFrame.origin.y = -sun.frame.size.height + 300.0
        sun.frame = nFrame
        nFrame.origin.y = -sun.frame.size.height
        
        timeline.add(Tween(target: sun, duration: 1.0, ease: .none, delay: 0.5, to: [.key(\.frame, nFrame)]))
        
        //MOON
        nFrame = moon.frame
        nFrame.origin.y = self.frame.size.height
        moon.frame = nFrame//initial value
        nFrame.origin.y = -moon.frame.size.height//destination value
        
        timeline.add(Tween(target: moon, duration: 1.0, ease: .none, delay: 1.5, to: [.key(\.frame, nFrame)]))
        
        
        //HEARTH
        nFrame = earth.frame
        nFrame.origin.y = self.frame.size.height
        earth.frame = nFrame//initial value
        nFrame.origin.y = -earth.frame.size.height//destination value
        
        timeline.add(Tween(target: earth, duration: 2.5, ease: .none, delay: 0.85, to: [.key(\.frame, nFrame)]))
        
        
        //SPACEMAN
        nFrame = spaceman.frame
        nFrame.origin.y = self.frame.size.height + moon.frame.size.height * 0.75
        nFrame.origin.x += 200.0
        spaceman.frame = nFrame//initial value
        
        nFrame.origin.x -= 100.0
        nFrame.origin.y = -moon.frame.size.height * 0.75//destination value
        timeline.add(Tween(target: spaceman, duration: 1.0, ease: .none, delay: 1.5, to: [.key(\.frame, nFrame)]))
        
        //COMET
        nFrame = comet.frame
        
        nFrame.origin.x = -comet.frame.size.width
        nFrame.origin.y = self.frame.size.height / 2.0 + comet.frame.size.height
        comet.frame = nFrame//initial value
        
        nFrame.origin.x = self.frame.size.width
        nFrame.origin.y = self.frame.size.height / 2.0 - comet.frame.size.height//destination value
        
        timeline.add(Tween(target: comet, duration: 1.0, ease: .none, delay: 2.5, to: [.key(\.frame, nFrame)]))
        
        //MARS
        nFrame = mars.frame
        
        nFrame.origin.x = 54.0
        nFrame.origin.y = self.frame.size.height
        mars.frame = nFrame//initial value
        
        nFrame.origin.y = -mars.frame.size.height//destination value
        
        timeline.add(Tween(target: mars, duration: 1.0, ease: .none, delay: 3.5, to: [.key(\.frame, nFrame)]))
        
        //UFO
        nFrame = ufo.frame
        
        nFrame.origin.x = self.frame.size.width
        nFrame.origin.y = nFrame.origin.y - 50.0
        ufo.frame = nFrame//initial value
        
        nFrame.origin.x = -ufo.frame.size.width//destination value
        nFrame.origin.y = nFrame.origin.y + 100.0
        
        timeline.add(Tween(target: ufo, duration: 0.75, ease: .none, delay: 4.5, to: [.key(\.frame, nFrame)]))
        
        //JUPYTER
        nFrame = jupyter.frame
        
        nFrame.origin.x = 54
        nFrame.origin.y = self.frame.size.height
        jupyter.frame = nFrame//initial value
        nFrame.origin.y = -400.0//destination value
        
        timeline.add(Tween(target: jupyter, duration: 1.5, ease: .none, delay: 5.0, to: [.key(\.frame, nFrame)]))
        
        //SATURN
        nFrame = saturn.frame
        nFrame.origin.x = self.frame.size.width - 54 - saturn.frame.size.width
        nFrame.origin.y = self.frame.size.height
        saturn.frame = nFrame//initial value
        
        nFrame.origin.y = -saturn.frame.size.height//destination value
        
        timeline.add(Tween(target: saturn, duration: 1.5, ease: .none, delay: 7.0, to: [.key(\.frame, nFrame)]))
        
        bringSubviewToFront(scrollview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Control timeline here!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let interpolation = Double(scrollview.contentOffset.y / (scrollview.contentSize.height - scrollview.frame.size.height))
        timeline.setTime(interpolation * timeline.getDuration())
    }
    
}
