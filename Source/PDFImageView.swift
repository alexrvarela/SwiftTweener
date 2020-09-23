//
//  PDFImageView.m
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 3/16/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

#if os(iOS)
import UIKit
/// Creates a UIImageView which renders and displays a PDF document's CGImage.
public class PDFImageView : UIImageView
{
    var pdf:PDFImageRender = PDFImageRender()
    
    private var _scale: Double = 1.0
    
    /// Changes render scale, affects UIImageView's size..
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
    
    /// Changes document's page, first page is default.
    public var currentPage: Int
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
    
    /// Initializer.
    public convenience init()
    {
        self.init(frame: CGRect.zero)
    }
    
    /// UIView's init(frame: CGRect) initializer.
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    /// Initializes with a pdf file name located in App's main bundle.
    /// - Parameter bundlename: String with pdf document's name in bundle.
    public convenience init(bundlename:String)
    {
        self.init()
        loadFromBundle(bundlename)
    }
    
    /// Initializes with a file path to resource.
    /// - Parameter filepath: String with document's name in bundle.
    public convenience init(filepath:String)
    {
        self.init()
        loadFile(filepath)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    /// Loads a document located in App's main bundle.
    /// - Parameter filename: String with document's name in bundle.
    public func loadFromBundle(_ filename: String)
    {
        self.pdf.loadFromBundle(filename: filename)
        if self.pdf.data != nil{updateImage()}
    }
    
    /// Loads a file from path to resource.
    /// - Parameter path: String with document's name in bundle.
    public func loadFile(_ path:String)
    {
        self.pdf.loadFile(path: path)
        if self.pdf.data != nil{updateImage()}
    }
    
    /// Refresh pdf's image.
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
#endif
