//
//  FavoriteListView.swift
//  CatalogIndah
//
//  Created by Indah Nurindo on 02/09/21.
//

import SwiftUI

struct FavoriteListView: View {
    @ObservedObject private var favoriteGameListViewModel = FavoriteGameListViewModel()
    var body: some View {
        VStack(alignment: .center) {
            if favoriteGameListViewModel.loading {
                LoadingView(color: Color.blue, size: 50)
            } else {
                if (favoriteGameListViewModel.favoriteGame.count > 0) {
                    List(favoriteGameListViewModel.favoriteGame, id: \.gameId) { favoriteGame in
                        NavigationLink(destination: FavoriteGameDetailView(gameId: "\(favoriteGame.gameId)",backgroundImage: "\(favoriteGame.gameBackgroundImage)")){
                           FavoriteGameRow(game: favoriteGame)
                        }
                    }
                } else {
                    ErrorView(text: "Games")
                }
            }
        }
        .onAppear {
            self.favoriteGameListViewModel.fetchAllFavoriteGame()
        }
    }
}

struct FavoriteGameRow: View {
    var game : FavoriteViewModel
    var isImageAvailable : Bool
    @ObservedObject var remoteImage : RemoteImage = RemoteImage()
        init(game : FavoriteViewModel) {
        self.game = game
        isImageAvailable = game.favoriteGame.gameBackgroundImage == "Unavailable!" ? false : true
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if isImageAvailable {
                if remoteImage.loadDone {
                    if remoteImage.isValid {
                        Image(uiImage: remoteImage.imageFromRemote())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 120).cornerRadius(10)
                    }                } else {
                    LoadingView(color: Color.blue, size: 25)
                        .frame(width: 100, height: 120)
                }
            } 
            VStack(alignment: .leading) {
                HStack {
                    Text(verbatim: game.gameName)
                        .foregroundColor(.blue)
                        .lineLimit(2)
                        .padding(.top,16)
                }
                HStack(alignment: .center) {
                    Text("⭐️")
                        .frame(width: 20.0, height: 20.0)
                    Text(verbatim: game.gameRating.format())
                    
                    Image(systemName: "calendar")
                        .frame(width: 20.0, height: 20.0)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text(verbatim: game.gameRelease)
                }
            }
        }
        .cornerRadius(10)
        .frame(height: 130)
        .onAppear(){
            self.remoteImage.setUrl(urlString: game.favoriteGame.gameBackgroundImage ?? "")
            if self.isImageAvailable{
                self.remoteImage.getRemoteImage()
            }
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}

