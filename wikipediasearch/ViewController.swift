//
//  ViewController.swift
//  wikipediasearch
//
//  Created by sachin singh on 06/08/21.
//

import UIKit


extension UIImageView {
        func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    }






class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    let searchbar = UISearchBar()
    
    
    @IBOutlet var Tblview: UITableView!
    
    
 
    
    var wiki2: Model2?
    
    var wiki1: Model1?
    
    var pageNumber:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        print(5)
         
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top , width: view.frame.size.width - 20, height: 50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wiki2?.query?.pages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: detailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "search") as! detailTableViewCell
        cell.lbl1.text = wiki2?.query?.pages?[indexPath.row].title
        
        if let str = wiki2?.query?.pages?[indexPath.row].thumbnail?.source
        {
            if let urlstring = URL(string: str) {
                cell.img1.downloaded(from: urlstring)
            }
    
            
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pageNumber = wiki2?.query?.pages?[indexPath.row].pageid
        
        if let number = pageNumber {
            
            openwiki(id: number) {
                
                let vc:searchUIViewController = self.storyboard?.instantiateViewController(identifier: "second") as! searchUIViewController
                
                vc.txt = self.wiki1?.query?.pages?.seven?.pagelanguage
                
                
                self.present(vc, animated: true)
                
               
                
            }
        }
        
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchbar.text {
            GetDataFromApi ( query:text) {
                
               
                self.Tblview.reloadData()
                
            }
        }
    }
    
    
    func GetDataFromApi( query:String , completion1 : @escaping () -> Void) {
        
        let urlstring = URL(string: "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10&gpssearch=\(query)&gpsoffset=0")!
        
        let Task = URLSession.shared.dataTask(with: urlstring) { data, response, error in
            guard let data = data else {return}
            
            do{
                self.wiki2 =  try JSONDecoder().decode(Model2.self, from: data)
                DispatchQueue.main.async {
                    completion1()
                }

            }
            catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func openwiki( id:Int , completion2 : @escaping () -> Void) {
        
        let urlstring = URL(string: "https://en.wikipedia.org/w/api.php?action=query&prop=info&inprop=url&format=json&pageids=\(id)")!
        
        let Task = URLSession.shared.dataTask(with: urlstring) { data, response, error in
            guard let data = data else {return}
            
            do{
                self.wiki1 =  try JSONDecoder().decode(Model1.self, from: data)
                DispatchQueue.main.async {
                    completion2()
                }

            }
            catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
        
    }

}

