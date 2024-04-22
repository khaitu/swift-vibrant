//
//  VibrantColors.swift
//  swift-vibrant-ios
//
//  Created by Bryce Dougherty on 5/3/20.
//  Copyright © 2020 Bryce Dougherty. All rights reserved.
//

#if os(iOS)
  import UIKit
#elseif os(macOS)
  import AppKit
#endif

import SwiftUI

public typealias Vec3<T> = (T, T, T)
public typealias RGB = (r: UInt8, g: UInt8, b: UInt8)
public typealias HSL = (h: Double, s: Double, l: Double)
public typealias XYZ = (x: Double, y: Double, z: Double)
public typealias LAB = (L: Double, a: Double, b: Double)


//export type Vec3 = [Double, Double, Double]
//

public struct Palette {
    public var Vibrant: Swatch?
    public var Muted: Swatch?
    public var DarkVibrant: Swatch?
    public var DarkMuted: Swatch?
    public var LightVibrant: Swatch?
    public var LightMuted: Swatch?
}

public class Swatch: Equatable {
    
    private var _hsl: HSL?

    private var _rgb: RGB

    private var _yiq: Double?

    private var _population: Int

    private var _hex: String?

    #if os(iOS)
    private var _uiColor: UIColor?
    #elseif os(macOS)
    private var _uiColor: NSColor?
    #endif

    private var _color: SwiftUI.Color?

    var r: UInt8 { self._rgb.r }

    var g: UInt8 { self._rgb.g }

    var b: UInt8 { self._rgb.b }

    public var rgb: RGB { self._rgb }

    public var hsl: HSL {
        if self._hsl == nil {
            let rgb = self._rgb
            self._hsl = apply(rgbToHsl, rgb)
        }
        return self._hsl!
    }

    public var hex: String {
        if self._hex == nil {
            let rgb = self._rgb
            self._hex = apply(rgbToHex, rgb)
        }
        return self._hex!
    }

    #if os(iOS)
    public var uiColor: UIColor {
        if self._uiColor == nil {
            let rgb = self._rgb
            self._uiColor = apply(rgbToUIColor, rgb)
        }
        return self._uiColor!
    }
    #elseif os(macOS)
    public var uiColor: NSColor {
        if self._uiColor == nil {
            let rgb = self._rgb
            self._uiColor = apply(rgbToUIColor, rgb)
        }
        return self._uiColor!
    }
    #endif

    public var color: SwiftUI.Color {
        if self._color == nil {
            let rgb = self._rgb
            self._color = apply(rgbToColor, rgb)
        }
        return self._color!
    }

    static func applyFilter(colors: [Swatch], filter: Filter)->[Swatch] {
        var colors = colors
        colors = colors.filter { (swatch) -> Bool in
            let r = swatch.r
            let g = swatch.g
            let b = swatch.b
            return filter.f(r, g, b, 255)
        }
        return colors
    }
    
    public var population: Int { self._population }

    
    func toDict()->[String: Any] {
        return [
            "rgb": self.rgb,
            "population": self.population
            ]
    }
    
    var toJSON = toDict

    private func getYiq()->Double {
        if self._yiq == nil {
            let (r,g,b) = self._rgb
            let mr = Int(r) * 299
            let mg = Int(g) * 598
            let mb = Int(b) * 114
            let mult = mr + mg + mb
            self._yiq =  Double(mult) / 1000
        }
        return self._yiq!
    }

    #if os(iOS)
    private var _titleTextColor: UIColor?
    #elseif os(macOS)
    private var _titleTextColor: NSColor?
    #endif

    #if os(iOS)
    private var _bodyTextColor: UIColor?
    #elseif os(macOS)
    private var _bodyTextColor: NSColor?
    #endif

    #if os(iOS)
    public var titleTextColor: UIColor {
        if self._titleTextColor == nil {
            self._titleTextColor = self.getYiq() < 200 ? .white : .black
        }
        return self._titleTextColor!
    }
    #elseif os(macOS)
    public var titleTextColor: NSColor {
        if self._titleTextColor == nil {
            self._titleTextColor = self.getYiq() < 200 ? .white : .black
        }
        return self._titleTextColor!
    }
    #endif

    #if os(iOS)
    public var bodyTextColor: UIColor {
        if self._bodyTextColor == nil {
            self._bodyTextColor = self.getYiq() < 150 ? .white : .black
        }
        return self._bodyTextColor!
    }
    #elseif os(macOS)
    public var bodyTextColor: NSColor {
        if self._bodyTextColor == nil {
            self._bodyTextColor = self.getYiq() < 150 ? .white : .black
        }
        return self._bodyTextColor!
    }
    #endif

    #if os(iOS)
    public func getTitleTextColor()->UIColor {
        return self.titleTextColor
    }
    #elseif os(macOS)
    public func getTitleTextColor()->NSColor {
        return self.titleTextColor
    }
    #endif

    #if os(iOS)
    public func getBodyTextColor()->UIColor {
        return self.bodyTextColor
    }
    #elseif os(macOS)
    public func getBodyTextColor()->NSColor {
        return self.bodyTextColor
    }
    #endif

    public static func == (lhs: Swatch, rhs: Swatch) -> Bool {
        return lhs.rgb == rhs.rgb
    }

    init(_ rgb: RGB, _ population: Int) {
        self._rgb = rgb
        self._population = population
    }


}
