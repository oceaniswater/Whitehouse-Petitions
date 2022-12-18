//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Марк Голубев on 16.12.2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        makeRequest(url: urlString)
        
    
    }
//    func fetchDataFromApi() {
//
//        guard let gitUrl = URL(string: "https://api.dev.ucheba.space/v1/institutions") else { return }
//
//        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
//
//            guard let data = data else { return }
//
//            do {
//                let decoder = JSONDecoder()
//                let gitData = try decoder.decode(Institutions.self, from: data)
//                    print(gitData.items ?? "Empty Name")
//
//            } catch let error {
//                print("Error: ", error)
//            }
//        }.resume()
        
//    }
    
    private func makeRequest(url: String) {
        var request = URLRequest(url: URL(string: url)!)
//        request.allHTTPHeaderFields = ["authToken": "nil"]
//        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data, let jsonPetitions = try? JSONDecoder().decode(Petitions.self, from: data) {
                print(jsonPetitions.results[0]) // тут уже нет ничего
                self.petitions = jsonPetitions.results
                print(self.petitions)
            }
        }
        task.resume()
    }
    
    func parse(json: Data?) {
        let decoder = JSONDecoder()


        if let json = json, let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            print(jsonPetitions.results[0])
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        cell.contentConfiguration = content
        
        return cell
    }


}

