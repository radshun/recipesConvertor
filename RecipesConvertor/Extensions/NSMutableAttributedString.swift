//
//  NSMutableAttributedString.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 10/01/2021.
//

import UIKit

enum NSMutableAttributedStringFont {
    case normal, bold, black
}

extension NSMutableAttributedString {
    var normalFont: String { return "System" }
    var boldFont: String { return "System - Bold" }
    var blacklFont: String { return "System - Medium" }
    
    private func getFont(_ font: NSMutableAttributedStringFont = .normal, with fontSize: CGFloat = 17) -> UIFont {
        switch font {
        case .normal:
            return UIFont(name: normalFont, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        case .bold:
            return UIFont(name: boldFont, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        case .black:
            return UIFont(name: blacklFont, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        }
    }

    func bold(_ value: String, fontSize: CGFloat = 17, color: UIColor? = nil) -> NSMutableAttributedString {

        var attributes:[NSAttributedString.Key : Any] = [
            .font : getFont(.bold, with: fontSize)
        ]
        if color != nil { attributes[.foregroundColor] = color }
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value: String, fontSize: CGFloat = 17, color: UIColor? = nil) -> NSMutableAttributedString {

        var attributes:[NSAttributedString.Key : Any] = [
            .font : getFont(.normal, with: fontSize)
        ]
        if color != nil { attributes[.foregroundColor] = color }
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func black(_ value: String, fontSize: CGFloat = 17, color: UIColor? = nil) -> NSMutableAttributedString {

        var attributes:[NSAttributedString.Key : Any] = [
            .font : getFont(.black, with: fontSize)
        ]
        if color != nil { attributes[.foregroundColor] = color }
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value: String, font: NSMutableAttributedStringFont = .normal, fontSize: CGFloat = 17) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : getFont(font, with: fontSize),
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value: String, font: NSMutableAttributedStringFont = .normal, fontSize: CGFloat = 17, color: UIColor? = nil) -> NSMutableAttributedString {

        var attributes:[NSAttributedString.Key : Any] = [
            .font : getFont(font, with: fontSize),
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        if color != nil { attributes[.foregroundColor] = color }
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func image(_ value: String, width: Int, height: Int) -> NSMutableAttributedString {
        let imageAttachment = NSTextAttachment()
        guard let image = UIImage(named: value) else { return self }
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 24, height: 25)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        self.append(attachmentString)
        return self
    }
    
    func setFontSize(_ size: CGFloat) -> NSMutableAttributedString {
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            if let font = value as? UIFont {
                if let newFont = UIFont(name: font.fontName, size: size) {
                    self.addAttributes([.font: newFont], range: range)
                }
            }
        }
        return self
    }
}

extension NSAttributedString {
    static func attributedPlaceholder(name: String, color: UIColor) -> NSAttributedString {
        NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
