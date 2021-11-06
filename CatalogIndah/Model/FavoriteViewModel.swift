//
//  FavoriteViewModel.swift
//  CatalogIndah
//
//  Created by Indah Nurindo on 02/09/21.
//

import Foundation


class FavoriteViewModel {
    var favoriteGame: FavoriteGame
    init(favoriteGame: FavoriteGame) {
        self.favoriteGame = favoriteGame
    }
    var gameId: Int32 {
        self.favoriteGame.gameId
    }
    var gameName: String {
        self.favoriteGame.gameName ?? ""
    }
    
    var gameRating: Float {
        self.favoriteGame.gameRating
    }
    var gameRelease: String {
        self.favoriteGame.gameRelease ?? ""
    }
    var gameBackgroundImage: String {
        self.favoriteGame.gameBackgroundImage ?? ""
    }
    var gameBackgroundImageAdditional: String {
        self.favoriteGame.gameBackgroundImageAdditional ?? ""
    }
    
    var gameDescription: String {
        self.favoriteGame.gameDescription ?? ""
    }
}

//add Game Favorite
class AddFavorite: ObservableObject {
    var gameId: Int32 = 0
    var gameName: String = ""
    var gameRating: Float = 0.0
    var gameBackgroundImage: String = ""
    var gameBackgroundImageAdditional: String = ""
    var gameRelease: String = ""
    var gameDescription: String = ""
    
    private var favoriteGame: FavoriteGame {
        let favoriteGame = FavoriteGame(context: ManagerCoreData.shared.managedObjectContext)
        favoriteGame.gameId = gameId
        favoriteGame.gameName = gameName
        favoriteGame.gameRating = gameRating
        favoriteGame.gameBackgroundImage = gameBackgroundImage
        favoriteGame.gameBackgroundImageAdditional = gameBackgroundImageAdditional
        favoriteGame.gameRelease = gameRelease
        favoriteGame.gameDescription = gameDescription
        return favoriteGame
    }
    
    func addFavoriteGame() -> Bool {
        do {
            try ManagerCoreData.shared.addFavortiteGame(favoriteGame: favoriteGame)
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }

}
//delete
class DeleteFavorite: ObservableObject {
    var gameId: Int32 = 0
    func deleteFavorite() -> Bool {
        do {
            try ManagerCoreData.shared.deleteFavoriteGame(gameId: gameId)
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}

class FavoriteGameByIdViewModel: ObservableObject {
    
    @Published
    var favoriteGame = FavoriteGameModel(gameId: 0, gameName: "", gameRating: 0.0, gameRelease: "", gameBackgroundImage: "", gameBackgroundImageAdditional: "", gameDescription: "")
    @Published var loading : Bool = false
    func fetchFavoriteGameById(gameId: Int32) {
        self.loading = true
        ManagerCoreData.shared.getFavoriteGameById(gameId){
            favoriteGame in
            self.loading = false
            guard let favoriteGame = favoriteGame else{
                return
            }
            self.favoriteGame = favoriteGame
        }
    }
}





