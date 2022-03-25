//
//  Repository.swift
//  GithubSearchMVC
//
//  Created by 한지민 on 2022/03/17.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let node_id: String
    let full_name: String
    let description: String?
    let url: String
    let html_url: String
    let created_at: String
    let updated_at: String
}
