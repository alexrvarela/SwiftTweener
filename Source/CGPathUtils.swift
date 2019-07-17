//
//  CGPathUtils.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 7/16/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation
public class CGPathUtils{
    
    //TODO:Bugfix, remove odd frame
    public static func getFontPath(string:String, fontSize:CGFloat) -> CGPath
    {
        let font = UIFont.init(name:"Menlo-Regular",size:12.0)
        let letters = CGMutablePath.init()
        
        let ctFont:CTFont = CTFontCreateWithName(font!.fontName as CFString, font!.pointSize, nil)
        
        let attrs : [NSAttributedString.Key : Any] = [kCTFontAttributeName as NSAttributedString.Key:ctFont]
        let attrString:NSAttributedString = NSAttributedString(string: string, attributes:attrs)
        let line:CTLine =  CTLineCreateWithAttributedString(attrString)
        let runArray:CFArray = CTLineGetGlyphRuns(line)
        let arrayCount = CFArrayGetCount(runArray)
        
        for runIndex in 0 ... arrayCount - 1
        {
            let ctRun:CTRun = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let key = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
            let ctFont:CTFont = unsafeBitCast(CFDictionaryGetValue(CTRunGetAttributes(ctRun),key), to: CTFont.self)
            
            for runGlyphIndex in 0 ... CTRunGetGlyphCount(ctRun)
            {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph:CGGlyph = CGGlyph()
                var position:CGPoint = CGPoint()
                
                CTRunGetGlyphs(ctRun, thisGlyphRange, &glyph)
                CTRunGetPositions(ctRun, thisGlyphRange, &position)
                
                let letter:CGPath = CTFontCreatePathForGlyph(ctFont, glyph, nil)!
                let transform:CGAffineTransform = CGAffineTransform(translationX: position.x, y: position.y)
                letters.addPath(letter, transform:transform)
            }
        }
        
        return letters
    }
    
    
    public static func flipPathVertically(path:CGPath) -> CGPath
    {
        let boundingBox = path.boundingBox
        let transformPath = CGMutablePath()
        let scale = CGAffineTransform(scaleX: 1.0, y: -1.0)//flip CGPath vertically
        transformPath.addPath(path, transform: scale)
        
        let translatePath = CGMutablePath()
        let translate = CGAffineTransform(translationX: 0.0, y: boundingBox.size.height)//translate to position
        translatePath.addPath(transformPath, transform: translate)
        
        return translatePath
    }
    
    public static func makeRoundRect(rect:CGRect, cornerRadius:CGFloat) -> CGPath
    {
        var cornerRadius = cornerRadius
        
        if (rect.size.width / 2 < cornerRadius)
        {cornerRadius = rect.size.width / 2}
        
        if rect.size.height / 2 < cornerRadius
        {cornerRadius = rect.size.height / 2}
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x:rect.origin.x, y:rect.origin.y + rect.size.height - cornerRadius))
        
        path.addArc(tangent1End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y),
                    tangent2End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y),
                    radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y),
                    tangent2End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y + rect.size.height),
                    radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y + rect.size.height),
                    tangent2End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y + rect.size.height),
                    radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y + rect.size.height),
                    tangent2End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y),
                    radius: cornerRadius)
        
        path.closeSubpath()
        
        return path
    }
}
