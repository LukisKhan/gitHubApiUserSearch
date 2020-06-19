//
//  ContentView.swift
//  RepoSearch
//
//  Created by Rave BizzDev on 6/15/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
//    let urlApi = "https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000"
    
    let baseUrl = "https://api.github.com/search/users?q="
    var array = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    @State var usersArray: [User]?
    @State var filteredItems: [String] = []
    @State private var searchText = ""
    @ObservedObject var viewModel = UsersSearchBarViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search Users", text: $viewModel.searchText).font(.system(size: 24))
                    Text("\(viewModel.usersArray.count) Results")
                }
                if viewModel.hasValues {
                    List(viewModel.usersArray, id: \.self.id) { user in
                        NavigationLink(destination: UserViewController(user: user)) {
                            HStack(spacing: 20) {
                                Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: user.avatar_url)!))!)
                                    .resizable()
                                    .frame(width: 150, height: 150, alignment: .leading)
                                    .aspectRatio(contentMode: .fit)
                                Text(user.login)
                                Text(String(user.public_repos!) + " repos")
                            }
                        }
                    }
                } else {
                    List(self.array, id: \.self) { item in
                        Text("")
                    }
                }
            }
            .navigationBarTitle("Github API Search")
            .padding(20)
            .onAppear() {
                print("Appeared")
            }
        }
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
