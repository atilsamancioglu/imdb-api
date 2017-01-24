//
//  ViewController.swift
//  IMDB Api Project
//
//  Created by Atıl Samancıoğlu on 24/01/2017.
//  Copyright © 2017 Atıl Samancıoğlu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        searchBar.delegate = self
        
        self.movieImage.layer.cornerRadius = self.movieImage.frame.size.width / 2
        self.movieImage.clipsToBounds = true
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchIMDB(title: searchBar.text!)
        searchBar.text = ""
        
    }
    
    func searchIMDB(title:String) {
        
        if let movie = title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            
            let url = URL(string: "http://www.omdbapi.com/?t=\(movie)")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                
                } else {
                    
                    
                    if data != nil {
                        
                        do
                            
                        {
                            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,String>
                            DispatchQueue.main.async{
                                
                                self.titleLabel.text = jsonResult["Title"]
                                self.ratingLabel.text = jsonResult["imdbRating"]
                                self.directorLabel.text = jsonResult["Director"]
                                self.actorsLabel.text = jsonResult["Actors"]
                                
                                if let posterExists = jsonResult["Poster"]{
                                    
                                    let posterUrl = URL(string:posterExists)
                                    if let posterData = try? Data(contentsOf: posterUrl!) {
                                        
                                        self.movieImage.image = UIImage(data:posterData)
                                    
                                    }
                                    

                                }
                                
                            }
                            
                            
                        } catch {
                            
                        }

                    }
                    
                    
                }
                
                
            })
            
             task.resume()
            
        }
    }
    
    
}

