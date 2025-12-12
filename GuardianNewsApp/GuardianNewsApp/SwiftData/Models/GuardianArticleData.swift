//
//  GuardianArticleData.swift
//  GuardianNewsApp
//
//  Created by Interexy on 11.12.25.
//

import SwiftData
import Foundation

@Model
final class GuardianArticleData {
    @Attribute(.unique) var id: String
    var type: String
    var sectionId: String
    var sectionName: String
    var webPublicationDate: String
    var webUrl: String
    var webTitle: String
    
    var blocked: Bool? = false
    var favorite: Bool? = false
    
    init(with article: GuardianArticle) {
        self.id = article.id
        self.type = article.type
        self.sectionId = article.sectionId
        self.sectionName = article.sectionName
        self.webPublicationDate = article.webPublicationDate
        self.webUrl = article.webUrl
        self.webTitle = article.webTitle
        self.blocked = article.blocked
        self.favorite = article.favorite
    }

    func getBottomText() -> String {
        return "\(sectionName) • \(DateFormattingService.formatISOToDisplay(webPublicationDate) ?? "")"
    }
    
    func getStruct() -> GuardianArticle {
        return GuardianArticle(
            id: id,
            type: type,
            sectionId: sectionId,
            sectionName: sectionName,
            webPublicationDate: webPublicationDate,
            webTitle: webTitle,
            webUrl: webUrl,
            blocked: blocked,
            favorite: favorite
        )
    }
}
