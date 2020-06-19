//
//  Repo.swift
//  RepoSearch
//
//  Created by Rave BizzDev on 6/15/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import Foundation

struct Repo: Codable {
    var id: Int
    var name: String
    var html_url: String
    var forks: Int
    var stargazers_count: Int
}
