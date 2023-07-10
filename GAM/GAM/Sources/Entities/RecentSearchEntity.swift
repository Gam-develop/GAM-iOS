//
//  RecentSearchEntity.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import Foundation

struct RecentSearchEntity: Hashable, Codable {
    var id: Int
    var title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    static func setUserDefaults(data: [RecentSearchEntity], forKey: UserDefaults.Keys) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.setValue(encoded, forKey: forKey.rawValue)
        }
    }
    
    static func getUserDefaults(forKey: UserDefaults.Keys) -> [RecentSearchEntity]? {
        if let savedData = UserDefaults.standard.object(forKey: forKey.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([RecentSearchEntity].self, from: savedData) {
                return savedObject
            } else { return nil }
        } else {
            return nil
        }
    }
}
