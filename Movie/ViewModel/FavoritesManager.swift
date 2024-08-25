//
//  FavoritesManager.swift
//  Movie
//
//  Created by Bishwajit Yadav on 26/08/24.
//

import Foundation

class FavoritesManager {
    private let favoritesKey = "Favorites"
    private let defaults = UserDefaults.standard
    
    init() {
        if let savedFavorites = defaults.array(forKey: favoritesKey) as? [String] {
            self.favorites = Set(savedFavorites)
        } else {
            self.favorites = Set()
        }
    }
    
    private(set) var favorites: Set<String>
    
    func isFavorite(movieID: String) -> Bool {
        return favorites.contains(movieID)
    }
    
    func toggleFavorite(movieID: String) {
        if favorites.contains(movieID) {
            favorites.remove(movieID)
        } else {
            favorites.insert(movieID)
        }
        save()
    }
    
    private func save() {
        defaults.set(Array(favorites), forKey: favoritesKey)
    }
}

