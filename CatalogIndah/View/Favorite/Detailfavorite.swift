//
//  Detailfavorite.swift
//  CatalogIndah
//
//  Created by Indah Nurindo on 02/09/21.
//

import SwiftUI

struct FavoriteGameDetailView: View {
    @State var isSaved = true
    var gameId : String
    var backgroundImage : String
    var isImageAvailable : Bool
    @ObservedObject var gameDetailViewModel = GameDetailViewModel()
    @ObservedObject var addFavoriteGameViewModel = AddFavorite()
    @ObservedObject var deleteFavoriteGameViewModel = DeleteFavorite()
    @ObservedObject var loadFavoriteGameByIdViewModel = FavoriteGameByIdViewModel()
    @ObservedObject var remoteImage : RemoteImage = RemoteImage()
    init(gameId : String, backgroundImage : String) {
        self.gameId = gameId
        self.backgroundImage = backgroundImage
        isImageAvailable = backgroundImage == "Unavailable!" ? false : true
    }
    var body: some View {
        VStack(alignment: .center){
            if loadFavoriteGameByIdViewModel.loading {
                VStack(alignment: .center){
                    LoadingView(color: Color.blue, size: 50)
                }
            }else{
                List {
                    VStack(alignment: .leading){
                        if isImageAvailable {
                            if remoteImage.loadDone {
                                if remoteImage.isValid {
                                    Image(uiImage: remoteImage.imageFromRemote())
                                        .resizable()
                                        .frame(height: 250.0)
                                } else {
                                    Image(systemName: "exclamtionmark.square.fill")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(height: 250.0)
                                }
                            } else {
                                LoadingView(color: Color.blue, size: 50)
                                    .frame(width: UIScreen.main.bounds.size.width, height: 250.0, alignment: .center)
                            }
                        } else {
                            Image(systemName: "exclamtionmark.square.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(height: 250.0)
                        }
                        VStack{
                            Text(loadFavoriteGameByIdViewModel.favoriteGame.gameName!)
                                .foregroundColor(.blue)
                                .bold()
                                .lineLimit(2)
                                .font(Font.system(size:24))
                                .frame(minWidth: 0, maxWidth: .infinity,  alignment: .leading)
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                            
                            HStack{
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 24.0, height: 24.0)
                                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0))
                                Text("\(loadFavoriteGameByIdViewModel.favoriteGame.gameRelease ?? "")")
                                    .font(Font.system(size:16))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                Text("⭐️")
                                    .frame(width: 24.0, height: 24.0)
                                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 0))
                                Text("\(loadFavoriteGameByIdViewModel.favoriteGame.gameRating!.format())")
                                    .font(Font.system(size:16))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            }.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                            .frame(minWidth: 0, maxWidth: .infinity,  alignment: .leading)
                        }
                        VStack(alignment: .leading){
                            Text("\(loadFavoriteGameByIdViewModel.favoriteGame.gameDescription ?? "")")
                                .multilineTextAlignment(.leading)
                                .font(Font.system(size:18))
                                .frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                        }
                    }
                }
                .padding(.leading, -20)
                .padding(.trailing, -20)
                
            }
        }.onAppear {
            self.loadFavoriteGameByIdViewModel.fetchFavoriteGameById(gameId: Int32(self.gameId)!)
            self.remoteImage.setUrl(urlString: self.backgroundImage)
            if self.isImageAvailable{
                self.remoteImage.getRemoteImage()
            }
        }.navigationBarTitle(Text(loadFavoriteGameByIdViewModel.favoriteGame.gameName!),displayMode: .inline)
        .navigationBarItems(trailing: self.isSaved == false ?
                                Button(action:{
                                    if self.loadFavoriteGameByIdViewModel.favoriteGame.gameId != 0 {
                                        self.addFavoriteGameViewModel.gameBackgroundImage = self.loadFavoriteGameByIdViewModel.favoriteGame.gameBackgroundImage!
                                        self.addFavoriteGameViewModel.gameBackgroundImageAdditional = self.loadFavoriteGameByIdViewModel.favoriteGame.gameBackgroundImageAdditional!
                                        self.addFavoriteGameViewModel.gameRating = self.loadFavoriteGameByIdViewModel.favoriteGame.gameRating!
                                        self.addFavoriteGameViewModel.gameId = self.loadFavoriteGameByIdViewModel.favoriteGame.gameId!
                                        self.addFavoriteGameViewModel.gameName = self.loadFavoriteGameByIdViewModel.favoriteGame.gameName!
                                        self.addFavoriteGameViewModel.gameRelease = self.loadFavoriteGameByIdViewModel.favoriteGame.gameRelease!
                                        let saved = self.addFavoriteGameViewModel.addFavoriteGame()
                                        if(saved){
                                            self.isSaved = saved
                                        }
                                    }
                                }){
                                    Image(systemName:"heart")
                                }
            : Button(action:{
                if self.loadFavoriteGameByIdViewModel.favoriteGame.gameId != 0 {
                    self.deleteFavoriteGameViewModel.gameId = self.loadFavoriteGameByIdViewModel.favoriteGame.gameId!
                    let removed = self.deleteFavoriteGameViewModel.deleteFavorite()
                    if(removed == true){
                        self.isSaved = false
                    }else{
                        self.isSaved = true
                    }
                }
            }){
                Image(systemName:"heart.fill")
            }
        )
    }
}

