//
//  ManagerCoreData.swift
//  CatalogIndah
//
//  Created by Indah Nurindo on 02/09/21.
//

import Foundation
import CoreData

class ManagerCoreData{
    static let shared = ManagerCoreData(managedObjectContext: NSManagedObjectContext.current)
    var managedObjectContext: NSManagedObjectContext
    private init(managedObjectContext: NSManagedObjectContext){
        self.managedObjectContext = managedObjectContext
    }
    
    func addFavortiteGame(favoriteGame: FavoriteGame) throws {
        self.managedObjectContext.insert(favoriteGame)
        try self.managedObjectContext.save()
    }
    
    func deleteFavoriteGame(gameId: Int32) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGame")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount
        do {
            try self.managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }

    func getFavoriteGameById(_ gameId: Int32, completion: @escaping(FavoriteGameModel?) -> ()) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteGame")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId)")
        do {
            if let result = try self.managedObjectContext.fetch(fetchRequest).first{
                let favoriteGame = FavoriteGameModel(
                    gameId: result.value(forKeyPath: "gameId") as? Int32,
                    gameName: result.value(forKeyPath: "gameName") as? String,
                    gameRating: result.value(forKeyPath: "gameRating") as? Float, gameRelease: result.value(forKeyPath: "gameRelease") as? String,
                    gameBackgroundImage: result.value(forKeyPath: "gameBackgroundImage") as? String,
                    gameBackgroundImageAdditional: result.value(forKeyPath: "gameBackgroundImageAdditional")  as? String,
                    gameDescription: result.value(forKey: "gameDescription") as? String)
                DispatchQueue.main.async {
                    completion(favoriteGame)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getAllFavoriteGame() -> [FavoriteGame] {
        var favoriteGame = [FavoriteGame]()
        let postRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        do {
            favoriteGame = try self.managedObjectContext.fetch(postRequest)
        } catch let error as NSError {
            print(error)
        }
        return favoriteGame
    }
}
