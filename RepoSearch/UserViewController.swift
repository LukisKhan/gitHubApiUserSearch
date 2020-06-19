//
//  UserViewController.swift
//  RepoSearch
//
//  Created by Rave BizzDev on 6/15/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import SwiftUI

// avatar image, username, number of followers, number of following, biography, email, location, join date, and a list of public repositories with a search bar at the top.

struct UserViewController: View {
    var user: User!
    let unknownString = "Unknown"
    let authentication = "&client_id=d4f7b65a8fb3d90bc9a5&client_secret=d7570c42b9d1ad581689270307d09ac167c166a4"
    @State var reposArray: [Repo] = []
    @State var searchText = ""
    let array = ["", "", "",""]
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: user.avatar_url)!))!)
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
                VStack {
                    Text(user.login)
                    Text("Followers: \(user.followers ?? 0)")
                    Text("Following: \(user.following ?? 0)")
                    Text("Email: \(user.email ?? unknownString)")
                    Text("Location: \(user.location ?? unknownString)")
                    Text("Created at: \(user.created_at ?? unknownString)")
                }
            }
            Text("Biography: \(user.bio ?? unknownString)")
            SearchBar(text: $searchText)
            List(self.reposArray.filter({ searchText.isEmpty ? true: $0.name.lowercased().contains(searchText.lowercased())}), id: \.self.id) { repo in
                HStack {
                    Text(repo.name)
                    Spacer()
                    VStack {
                        Text("Forks: \(repo.forks)")
                        Text("Stars: \(repo.stargazers_count)")
                    }
                }
            }
        }
        .onAppear(){
            URLSession.shared.dataTask(with: URL(string: self.user.repos_url+"?q=&per_page=1000"+self.authentication)!) { (data, response, error) in
                do {
                    let dataObject = try JSONDecoder().decode([Repo].self, from: data!)
                    let dataArray = dataObject
                    DispatchQueue.main.async {
                        self.reposArray = dataArray
                    }
                }
                catch {
                    print("Error downloading from repos url: \(error)")
                }
            }.resume()
        }
    }
}

struct UserViewController_Previews: PreviewProvider {
    static var previews: some View {
        UserViewController()
    }
}
