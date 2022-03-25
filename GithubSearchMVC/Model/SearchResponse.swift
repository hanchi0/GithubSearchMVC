//
//  SearchResponse.swift
//  GithubSearchMVC
//
//  Created by 한지민 on 2022/03/17.
//

import Foundation

struct SearchResponse: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
}
