//
//  FavoriteGameListViewModel.swift
//  CatalogIndah
//
//  Created by Indah Nurindo on 03/09/21.
//

import Foundation

class FavoriteGameListViewModel: ObservableObject {
    
    @Published
    var favoriteGame = [FavoriteViewModel]()
    @Published var loading : Bool = false
    init() {
        fetchAllFavoriteGame()
    }
    func fetchAllFavoriteGame() {
        self.loading = true
        DispatchQueue.main.async {
            self.loading = false
            self.favoriteGame = ManagerCoreData.shared.getAllFavoriteGame().map(FavoriteViewModel.init)        }
    }
}
