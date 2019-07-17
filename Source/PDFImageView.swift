//
//  PDFImageView.m
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 3/16/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit

public class PDFImageView : UIImageView
{
    var pdf:PDFImageRender = PDFImageRender()
    
    private var _scale: Double = 1.0
    
    public var scale: Double
    {
        set
        {
            if newValue > 0.0
            {
                _scale = newValue
                updateImage()
            }
        }
        
        get{return _scale}
    }
    
    private var _currentPage: Int = 1
    
    var currentPage: Int
    {
        set
        {
            if (newValue <= self.pdf.pageCount && newValue > 0)
            {
                _currentPage = newValue
                updateImage()
            }
        }
        get
        {
            if self.pdf.data == nil
            {
                return 0
            }
            else
            {
                return _currentPage
            }
        }
    }

    public convenience init()
    {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    public convenience init(bundlename:String)
    {
        self.init()
        loadFromBundle(bundlename)
    }
    
    public convenience init(filepath:String)
    {
        self.init()
        loadFile(filepath)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    public func loadFromBundle(_ filename: String)
    {
        self.pdf.loadFromBundle(filename: filename)
        if self.pdf.data != nil{updateImage()}
    }
    
    public func loadFile(_ path:String)
    {
        self.pdf.loadFile(path: path)
        if self.pdf.data != nil{updateImage()}
    }
    
    func updateImage()
    {
        if self.pdf.document != nil
        {
            self.image = self.pdf.renderPage(page:self.currentPage, scale:self.scale)
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: self.image!.size.width,
                                height: self.image!.size.height)
        }
    }
}
