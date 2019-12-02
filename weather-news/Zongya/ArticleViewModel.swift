//
//  ArticleViewModel.swift
//  NewsAppMVVM
//
//  Created by Mohammad Azam on 3/13/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class ArticleListViewModel {
    var articlesVM = [ArticleViewModel]()
    let disposeBag = DisposeBag()
}

extension ArticleListViewModel {
    
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesVM[index]
    }
    
    func populateNews(completionHandler : (()->())?) {
        
        RxAlamofire.requestJSON(.get, "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(APIKey.populateNewsAPIKey)").subscribe(onNext: { (r, json) in
            var dataArray : NSArray
            var articleArray = [Article]()
            if let jsonDict = json as? NSDictionary{
                dataArray = jsonDict["articles"] as! NSArray

                for item in dataArray{
                    let value = item as! NSDictionary

                    let article = Article(title: value["title"]! as! String, description: value["description"] as? String, imageURL: value["urlToImage"] as? String, content: value["content"] as? String, url: value["url"] as? String)
                    
                    articleArray.append(article)
                }
                self.articlesVM = articleArray.compactMap(ArticleViewModel.init)
                completionHandler!()
            }
          }, onError: { (error) in
            //error
          }, onCompleted: {
            //completed
          }) {
            //dispose
          }.disposed(by: disposeBag)
    }
    
    func searchNews(searchword: String ,completionHandler : (()->())?) {
         
        RxAlamofire.requestJSON(.get, "https://newsapi.org/v2/everything?q=\(searchword)&apiKey=\(APIKey.searchNewsAPIKey)").subscribe(onNext: { (r, json) in
             var dataArray : NSArray
             var articleArray = [Article]()
             if let jsonDict = json as? NSDictionary{
                 dataArray = jsonDict["articles"] as! NSArray

                 for item in dataArray{
                     let value = item as! NSDictionary

                     let article = Article(title: value["title"]! as! String, description: value["description"] as? String, imageURL: value["urlToImage"] as? String, content: value["content"] as? String, url: value["url"] as? String)
                     
                     articleArray.append(article)
                 }
                 self.articlesVM = articleArray.compactMap(ArticleViewModel.init)
                 completionHandler!()
             }
           }, onError: { (error) in
             //error
           }, onCompleted: {
             //completed
           }) {
             //dispose
           }.disposed(by: disposeBag)
     }
}

struct ArticleViewModel {
    
    let article: Article
    
    init(_ article: Article) {
        self.article = article
    }
}

extension ArticleViewModel {
    
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    var imageURL: Observable<String> {
        return Observable<String>.just(article.imageURL ?? "")
    }
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
    var content: Observable<String> {
        return Observable<String>.just(article.content ?? "")
    }
    var url: Observable<String> {
        return Observable<String>.just(article.url ?? "")
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
