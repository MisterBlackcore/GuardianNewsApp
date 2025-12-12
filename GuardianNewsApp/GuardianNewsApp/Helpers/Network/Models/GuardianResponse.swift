//
//  GuardianResponse.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

struct GuardianResponse: Decodable {
    let response: GuardianResponseContent
}

struct GuardianResponseContent: Decodable {
    let results: [GuardianArticle]
}

struct GuardianArticle: Decodable {
    let id: String
    let type: String
    let sectionId: String
    let sectionName: String
    let webPublicationDate: String
    let webTitle: String
    let webUrl: String
    
    var blocked: Bool?
    var favorite: Bool?
    
    func getBottomText() -> String {
        return "\(sectionName) • \(DateFormattingService.formatISOToDisplay(webPublicationDate) ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, sectionId, sectionName, webPublicationDate, webTitle, webUrl, blocked, favorite
    }
    
    init(id: String,
         type: String,
         sectionId: String,
         sectionName: String,
         webPublicationDate: String,
         webTitle: String,
         webUrl: String,
         blocked: Bool?,
         favorite: Bool?) {
        self.id = id
        self.type = type
        self.sectionId = sectionId
        self.sectionName = sectionName
        self.webPublicationDate = webPublicationDate
        self.webTitle = webTitle
        self.webUrl = webUrl
        self.blocked = blocked
        self.favorite = favorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        sectionId = try container.decode(String.self, forKey: .sectionId)
        sectionName = try container.decode(String.self, forKey: .sectionName)
        webPublicationDate = try container.decode(String.self, forKey: .webPublicationDate)
        webTitle = try container.decode(String.self, forKey: .webTitle)
        webUrl = try container.decode(String.self, forKey: .webUrl)
        blocked = try container.decodeIfPresent(Bool.self, forKey: .blocked) ?? false
        favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite) ?? false
    }
}
