//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Марк Голубев on 16.12.2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRequest(url: urlString)
        //        print(petitions.count)
        
        
    }
    
    private func makeRequest(url: String) {
        let request = URLRequest(url: URL(string: url)!)
//        request.allHTTPHeaderFields = ["authToken": "nil"]
//        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            do {
                let jsonPetitions = try JSONDecoder().decode(Petitions.self, from: data)
                    self?.petitions = jsonPetitions.results
                    print((self?.petitions[0].title)! as String)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
            } catch let error {
                print("Error: ", error)
            }
        }
        task.resume()
    }
    
//    func parse(json: Data?) {
//        let decoder = JSONDecoder()
//
//        if let json = json, let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
//            petitions = jsonPetitions.results
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        content.secondaryTextProperties.numberOfLines = 3
        cell.contentConfiguration = content
        
        return cell
    }


}

