//
//  SearchViewController.swift
//  GithubSearchMVC
//
//  Created by 한지민 on 2022/03/16.
//

import UIKit

class SearchViewController: UIViewController {
    var repositories: [Repository] = [Repository]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SearchDetailViewController, let data = sender as? Repository {
            destinationVC.repository = data
        }
    }
    
    func setup() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    func fetchRepositories(text: String?, completion: @escaping(Result<SearchResponse, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: text)
        ]
        
        URLSession.shared.dataTask(with: (urlComponents?.url)!) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    completion(.failure(error))
                    print("error")
                }
            }
        }.resume()
    }
    
    func fetchRepositoriesCompletion(result: Result<SearchResponse, Error>) -> Void {
        switch result {
        case .success(let response):
            self.repositories = response.items
        case .failure(let error):
            print("error : \(error.localizedDescription)")
            self.repositories = [Repository]()
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self.repositories[indexPath.row])
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else {
                  return UITableViewCell()
              }
        let data = self.repositories[indexPath.row]
        cell.setData(data: data)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchRepositories(text: searchBar.text, completion: self.fetchRepositoriesCompletion(result:))
    }
}
