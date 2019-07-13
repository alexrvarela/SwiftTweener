//
//  ScrollAims.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/29/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class ScrollAims:UIView, UIScrollViewDelegate
{
    let scrollview:UIScrollView = UIScrollView()
    let sand:UIView = UIView()
    let body:PDFImageView = PDFImageView(bundlename: "bb8-body")
    let head:PDFImageView = PDFImageView(bundlename: "bb8-head")
    let rotationAim:RotationAim = RotationAim()
    let arcAim:ArcAim = ArcAim()
    var lastOffset:CGFloat = 0.0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:222.0/255.0,
                                  green:255.0/255.0,
                                  blue:220.0/255,
                                  alpha:1.0)
        
        //Scrollview
        scrollview.frame = bounds
        scrollview.contentSize = CGSize(width:self.frame.size.width * 5.0, height:self.frame.size.height)
        scrollview.delegate = self
        addSubview(scrollview)
        
        //Sand background
        let pdfView = PDFImageView(bundlename: "sand")
        
        //body

        body.center =  center
        addSubview(body)
        
        head.center =  CGPoint(x:center.x,
                               y:center.y - ((body.frame.size.height + head.frame.size.height) / 2.0) + 15.0)
        //+ self.head.frame.size.height
        addSubview(head)
        
        sand.frame = pdfView.bounds
        sand.backgroundColor = UIColor(patternImage: pdfView.image!)
        sand.frame = CGRect(x:-self.frame.size.width,
                            y:(self.frame.size.height + body.frame.size.height) / 2.0,
                            width:scrollview.contentSize.width + self.frame.size.width * 2.0,
                            height:(self.frame.size.height - body.frame.size.height) / 2.0)
        
        scrollview.addSubview(sand)
        //head
        
        //Setup rotation Aim
        rotationAim.target = body
        
        //Setup arc Aim
        arcAim.target = head
        arcAim.radius  = body.frame.size.width * 0.7
        arcAim.orientToArc = true
        arcAim.arcAngleOffset = -90.0
        arcAim.angleOffset = -90.0
        arcAim.center  = center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Control aims here!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //Rotation, value 532.0 is total lenght of a bb8's body circle
        rotationAim.distance = (scrollview.contentOffset.x / 537.0)
        
        //Calculate velocity
        var velocity = scrollview.contentOffset.x - lastOffset
        
        //Set max velocity
        let max:CGFloat = 35.0
        if velocity < -max {velocity = -max}
        if velocity > max {velocity = max}
        
        //Calculate interpolation
        let interpolation = velocity / max
        
        //Arc angle
        arcAim.arcAngle = 45.0 * interpolation
        
        //Store last scroll offset to calculate velocity
        lastOffset = scrollview.contentOffset.x
    }

}
