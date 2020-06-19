//
//  UsersSearchBarViewModel.swift
//  RepoSearch
//
//  Created by Rave BizzDev on 6/15/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//


import SwiftUI
import Combine

class UsersSearchBarViewModel: ObservableObject {
    
    let baseUrl = "https://api.github.com/search/users?q="
    let authentication = "&client_id=d4f7b65a8fb3d90bc9a5&client_secret=d7570c42b9d1ad581689270307d09ac167c166a4"
    let queryStart = "?q="
    let pageLimit = "&per_page=10"
    
    @Published var hasValues = false
    @Published var usersArray: [User] = []
    
    @Published var searchText = "" {
        didSet {
            print("set \(searchText)")
            let path = self.searchText
            let searchUrl = self.baseUrl + path + authentication
            URLSession.shared.dataTask(with: URL(string: searchUrl)!) { (data, response, error) in
                do {
                    print(searchUrl)
                    let dataObject = try JSONDecoder().decode(UserWithParameters.self, from: data!)
                    let dataArray = dataObject.items
                    DispatchQueue.main.async() {
                        self.usersArray = []
                    }
                    for user in dataArray {
                        URLSession.shared.dataTask(with: URL(string: user.url+self.queryStart+self.pageLimit+self.authentication)!) { (data, response, error) in
                            do {
                                let dataUser = try JSONDecoder().decode(User.self, from: data!)
                                DispatchQueue.main.async() {
                                    self.usersArray.append(dataUser)
                                    self.hasValues = true
                                }
                            } catch {
                                print("Error at user/:username")
                            }
                        }.resume()
                    }
                }
                catch {
                    print("Error downloading from url: \(error)")
                }
            }.resume()
        }
    }
}
