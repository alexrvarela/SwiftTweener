//
//  SupportedTypes.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 09/09/20.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#endif

import Foundation

/// Blocks to cast Custom data types into Arrays and back to Type.
public typealias ToTypeBlock<T> = ([Double]) -> T
public typealias ToArrayBlock<T> = (T) -> [Double]

/// An Interpreter's wrapper.
class AnyInterpreter{
    /// Gets values from Type in to Array.
    func toArray(_ value:Any) -> [Double]? { return nil }
    /// Turns Double's Array in to Type.
    func toType(_ array:[Double]) -> Any? { return nil }
    
    /// KeyPath's write function.
    func write<U>(target:U, key:PartialKeyPath<U>, values:[Double]){ print("Warning, Type not declared")}
    
    /// KeyPath's read function.
    func read<U>(target:U, key:PartialKeyPath<U>)->[Double]{ print("Warning, Type not declared"); return [] }
}

///A class which translates from types to array buffer  and viceversa, Tweener core works with Double type Arrays.
class Interpreter<T>:AnyInterpreter{
   
    /// To Type instance.
    let toTypeBlock:ToTypeBlock<T>
    /// To Array instance.
    let toArrayBlock:ToArrayBlock<T>
    
    /// Designated initializer.
    init(_ toType:@escaping ToTypeBlock<T>, _ toArray:@escaping ToArrayBlock<T>){
        self.toTypeBlock = toType
        self.toArrayBlock = toArray
    }
    
    /// Potentially unsafe function, try to convert a Type into Array.
    override func toArray(_ value:Any) -> [Double]? {
        guard let v = value as? T else { return nil }
        return toArrayBlock( v )
    }
    
    /// Potentially unsafe function, try to convert an Array into Type.
    override func toType(_ array:[Double]) -> Any? { return self.toTypeBlock( array ) }
    
    /// Safe KeyPath write.
    override func write<U>(target:U, key:PartialKeyPath<U>, values:[Double]){
        let wirtableKey = key as! ReferenceWritableKeyPath<U, T>
        target[keyPath: wirtableKey] = toTypeBlock( values )
    }

    /// Safe KeyPath read.
    override func read<U>(target:U, key:PartialKeyPath<U>)->[Double] {
        return toArrayBlock( target[keyPath: key] as! T )
    }
}


///A list with supported types and interpeters, Tweener core works with Double Arrays.
struct SupportedTypes{
    
    /// Internal list with supported types.
    static var list:[Any] = PrebuiltTypes.types
    /// Internal list with declared interpreters.
    static var interpreters:[AnyInterpreter] = PrebuiltTypes.interpeters
    /// A list for protected types.
    static var protected:[Any] = PrebuiltTypes.types
    /// A list for types declared as numerics.
    static var numerics:[Any] = PrebuiltTypes.numerics
    
    ///Try found interperter by type and convert value to Array.
    static func cast(_ value:Any) -> [Double]? {
        for (j, t) in SupportedTypes.list.enumerated() {
            if type( of:type(of: value) ) == type(of: t) {
                return SupportedTypes.interpreters[j].toArray( value )
            }
        }
        return nil
    }
}

///Creates a collection of supported Types.
struct PrebuiltTypes{
    
    ///Type list
    static let types:[Any] = {
        var list:[Any] = []
            //Int
            list.append(Int.self)
            //Float
            list.append(Float.self)
            //Double
            list.append(Double.self)
            #if os(iOS) || os(tvOS) || os(macOS)
            //CGFloat
            list.append(CGFloat.self)
            //CGPoint
            list.append(CGPoint.self)
            //CGSize
            list.append(CGSize.self)
            //CGRect
            list.append(CGRect.self)
            //CGAffineTransform
            list.append(CGAffineTransform.self)
            //CATransform3D
            list.append(CATransform3D.self)
            #endif
            //Os target iOS & tvOS
            #if os(iOS) || os(tvOS)  || os(watchOS)
            //UIColor
            list.append(UIColor.self)
            #endif
            //Os target macOS & watchOS
            #if  os(macOS)
            //NSColor
            list.append(NSColor.self)
            #endif
        return list
    }()
    
    ///Interpeters, in same order than list.
    static let interpeters:[AnyInterpreter] = {
        var list:[AnyInterpreter] = []
        //Int
        list.append(Interpreter({ v -> Int in return Int(v[0]) },
                               { i -> [Double] in return [Double(i)] }))
        
        //Float
        list.append(Interpreter({ v -> Float in return Float(v[0]) },
                               { f -> [Double] in return [Double(f)] }))
        //Double
        list.append(Interpreter({ v -> Double in return v[0] },
                               { d -> [Double] in return [d] }))
        
        #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
        //CGFloat
        list.append(Interpreter({ v -> CGFloat in return CGFloat(v[0]) },
                               { f -> [Double] in return [Double(f)] }))
        //CGPoint
        list.append(Interpreter({ v -> CGPoint in return CGPoint(x:v[0], y:v[1])},
                               { p -> [Double] in return [Double(p.x), Double(p.y)] }))
        //CGSize
        list.append(Interpreter({ v -> CGSize in return CGSize(width:v[0], height:v[1])},
                               { s -> [Double] in return [Double(s.width), Double(s.height)] }))
        
        //CGRect
        list.append(Interpreter({ v -> CGRect in return CGRect(x:v[0], y:v[1], width:v[2], height:v[3])},
                               { rect -> [Double] in return [Double(rect.origin.x), Double(rect.origin.y), Double(rect.size.width), Double(rect.size.height)] }))
        //CGAffineTransform
        list.append(Interpreter({ v -> CGAffineTransform in
                                    let f = v.map{ CGFloat($0) }
                                    return CGAffineTransform(a: f[0], b: f[1], c: f[2], d: f[3], tx: f[4], ty: f[5])},
                               { t -> [Double] in
                                                         let f:[CGFloat] = [t.a, t.b, t.c, t.d, t.tx, t.ty]
                                                         return f.map{ Double($0) }
                                                     }))
        #endif
        
        #if os(iOS) || os(tvOS) || os(macOS)
        //CATransform3D
        list.append(Interpreter({ v -> CATransform3D in
                                    let f = v.map{ CGFloat($0) }
                                    return CATransform3D(m11: f[0], m12: f[1], m13: f[2], m14: f[3],
                                                         m21: f[4], m22: f[5], m23: f[6], m24: f[7],
                                                         m31: f[8], m32: f[9], m33: f[10], m34: f[11],
                                                         m41: f[12], m42: f[13], m43: f[14], m44: f[15]) },
                               { t -> [Double] in
                                     let f:[CGFloat] = [t.m11, t.m12, t.m13, t.m14,
                                                        t.m21, t.m22, t.m23, t.m24,
                                                        t.m31, t.m32, t.m33, t.m34,
                                                        t.m41, t.m42, t.m43, t.m44]
                                     return f.map{ Double($0) } }))
        
        #endif
        //Os target iOS & tvOS
        #if os(iOS) || os(tvOS) || os(watchOS)
        //UIColor
        list.append(Interpreter({ v -> UIColor in
                                    //Map components as CGFloat
                                    let f = v.map{ CGFloat($0) }
                                    return UIColor(red: f[0], green: f[1], blue: f[2], alpha: f[3]) },
                                
                                { color -> [Double] in
                                    
                                    //Map components as Double
                                    let components = color.cgColor.components!.map{ Double($0) }
                                    var v:[Double] = []
                                    
                                    //Force to RGBA
                                    switch components.count {
                                        case 1://Gray
                                            for _ in 0 ... 2 { v.append(components[ 0 ] ) }
                                            v.append( 1.0 )//Add alpha
                                        case 2://Gray+Alpha
                                            for _ in 0 ... 2 { v.append( components[ 0 ]  ) }
                                            v.append( Double( components[ 1 ] ) )
                                        case 3://RGB
                                            for c in components { v.append( c ) }
                                            v.append( 1.0 )//Add alpha
                                        case 4://GRB+Alpha
                                            for c in components{ v.append( c ) }
                                        default:
                                            for _ in 0 ... 2 { v.append( 0.0 ) }
                                            v.append( 1.0 )//Add alpha
                                    }
                                    return v
                        } ))
        #endif
        //Os target macOS & watchOS
        #if os(macOS)
        //NSColor
        list.append(Interpreter({ v -> NSColor in
                                    //Map components as CGFloat
                                    let f = v.map{ CGFloat($0) }
                                    return NSColor(red: f[0], green: f[1], blue: f[2], alpha: f[3]) },
                                
                                { color -> [Double] in
                                    //Map components as Double
                                    let components = color.cgColor.components!.map{ Double($0) }
                                    var v:[Double] = []
                                    
                                    //Force to RGBA
                                    switch components.count {
                                        case 1://Gray
                                            for _ in 0 ... 2 { v.append(components[ 0 ] ) }
                                            v.append( 1.0 )//Add alpha
                                        case 2://Gray+Alpha
                                            for _ in 0 ... 2 { v.append( components[ 0 ]  ) }
                                            v.append( Double( components[ 1 ] ) )
                                        case 3://RGB
                                            for c in components { v.append( c ) }
                                            v.append( 1.0 )//Add alpha
                                        case 4://GRB+Alpha
                                            for c in components{ v.append( c ) }
                                        default:
                                            for _ in 0 ... 2 { v.append( 0.0 ) }
                                            v.append( 1.0 )//Add alpha
                                    }
                                    return v
                                    
                                }))
        #endif
        //TODO:Linux?
        
        // Setup code
        return list
    }()
    
    ///Numerics, no order required, but incluided in lists
    static let numerics:[Any] = {
        var list:[Any] = []
               //Int
               list.append(Int.self)
               //Float
               list.append(Float.self)
               //Double
               list.append(Double.self)
               #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
               //CGFloat
               list.append(CGFloat.self)
               #endif
        return list
    }()
}

