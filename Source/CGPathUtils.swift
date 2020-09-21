//
//  CGPathUtils.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 7/16/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// A set of CGPath utilities.
public class CGPathUtils{
    /// Gets the CGPath from a Font.
    public static func getFontPath(string:String, fontName:String, fontSize:CGFloat) -> CGPath
    {
        let letters = CGMutablePath()
        let ctFont = CTFontCreateWithName(fontName as CFString, fontSize, nil)
        let attrString = NSAttributedString(string: string, attributes: [kCTFontAttributeName as NSAttributedString.Key : ctFont])
        let line = CTLineCreateWithAttributedString(attrString)
        let runArray = CTLineGetGlyphRuns(line)
        
        for runIndex in 0 ..< CFArrayGetCount(runArray)
        {
            let ctRun = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let dictRef = CTRunGetAttributes(ctRun)
            let dict = dictRef as NSDictionary
            let runFont = dict[kCTFontAttributeName as String] as! CTFont
            
            for runGlyphIndex in 0 ..< CTRunGetGlyphCount(ctRun)
            {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph = CGGlyph()
                var position = CGPoint.zero
                
                CTRunGetGlyphs(ctRun, thisGlyphRange, &glyph)
                CTRunGetPositions(ctRun, thisGlyphRange, &position)
                
                let letter = CTFontCreatePathForGlyph(runFont, glyph, nil)
                let transform = CGAffineTransform(translationX: position.x, y: position.y)
                if let letter = letter {letters.addPath(letter, transform: transform)}
            }
        }
        
        return letters
    }
    /// Flips a CGPath vertically.
    public static func flipPathVertically(path:CGPath) -> CGPath
    {
        let boundingBox = path.boundingBox
        let transformPath = CGMutablePath()
        let scale = CGAffineTransform(scaleX: 1.0, y: -1.0)
        transformPath.addPath(path, transform: scale)
        
        let translatePath = CGMutablePath()
        let translate = CGAffineTransform(translationX: 0.0, y: boundingBox.size.height)
        translatePath.addPath(transformPath, transform: translate)
        
        return translatePath
    }
    
    /// Translates x and y CGPath's points.
    public static func translatePath(path:CGPath, x:CGFloat, y:CGFloat) -> CGPath
    {
        let translatePath = CGMutablePath()
        let translate = CGAffineTransform(translationX:x, y:y)
        translatePath.addPath(path, transform: translate)
        
        return translatePath
    }
    
    /// Makes a rounded CGPath rectangle.
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
