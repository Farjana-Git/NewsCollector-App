//
//  CategoryModel.swift
//  MidVersion01
//
//  Created by Bjit on 12/1/23.
//

import Foundation

class Category {
    enum Categories: String, CaseIterable{
        case All = "All", Business = "Business", Entertainment = "Entertainment", General = "General", Health = "Health", Science = "Science", Sports = "Sports", Technology = "Technology"
    }
}

struct Welcome: Decodable, Encodable {
    let status: String?
    let totalResults: Int?
    var articles: [Article]?
}

struct Article: Decodable, Encodable {
    let author: String?
    let title: String?
    let description: String?
    let content: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: Source?
}

struct Source:  Decodable, Encodable {
    let name: String?
    let id: String?
}
