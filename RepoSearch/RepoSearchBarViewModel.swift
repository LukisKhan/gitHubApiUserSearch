//
//  RepoSearchBarViewModel.swift
//  RepoSearch
//
//  Created by Rave BizzDev on 6/15/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import SwiftUI
import Combine

class RepoSearchBarViewModel: ObservableObject {
    
    let baseUrl = "https://api.github.com/search/repo?q="
    let authentication = "&client_id=d4f7b65a8fb3d90bc9a5&client_secret=d7570c42b9d1ad581689270307d09ac167c166a4"
    
    @Published var hasValues = false
    @Published var reposArray: [Repo]!
    @Published var searchText = "" {
        didSet {
            print("set \(searchText)")
            let path = self.searchText
            let searchUrl = self.baseUrl + path + authentication
            URLSession.shared.dataTask(with: URL(string: searchUrl)!) { (data, response, error) in
                do {
                    let dataObject = try JSONDecoder().decode([Repo].self, from: data!)
                    let dataArray = dataObject
                    DispatchQueue.main.async {
                        self.hasValues = true
                        self.reposArray = dataArray
                    }
                    if dataArray.count > 0 {
                        print(dataArray[0], dataArray.count)
                    } else {
                        print("No repos found with that name")
                        self.hasValues = false
                        self.reposArray = []
                    }
                }
                catch {
                    print("Error downloading from url: \(error)")
                }
            }.resume()
        }
    }
}
