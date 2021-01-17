//
//  CodableImage.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 17/01/2021.
//

import UIKit

public struct CodableImage: Codable {
    public let image: UIImage?
    
    public enum CodingKeys: String, CodingKey {
        case image
    }
    
    public init(image: UIImage?) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        self.image = UIImage(data: data) ?? UIImage()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = image?.pngData() ?? Data()
        try container.encode(data, forKey: CodingKeys.image)
    }
}
