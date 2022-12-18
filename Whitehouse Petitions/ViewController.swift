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
        let urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(tapCreditsButton))
                
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else  {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        makeRequest(url: urlString)
        
        
    }
    // make API request and parse JSON
    private func makeRequest(url: String) {
        let request = URLRequest(url: URL(string: url)!)
//        request.allHTTPHeaderFields = ["authToken": "nil"]
//        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.showAlert(with: error?.localizedDescription)
                }
                return }
            do {
                let jsonPetitions = try JSONDecoder().decode(Petitions.self, from: data)
                    self?.petitions = jsonPetitions.results
                // reload data in main thread
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
            } catch let error {
                print("Error: ", error.localizedDescription)
                self?.showAlert(with: error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func showAlert(with erorr: String?) {
        let ac = UIAlertController(title: erorr, message: "There was a promlem please try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func tapCreditsButton() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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
        // setup cell
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        content.secondaryTextProperties.numberOfLines = 1
        cell.contentConfiguration = content
        
        return cell
    }
    // transfer data to detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

