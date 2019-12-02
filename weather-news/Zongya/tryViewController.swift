//
//  tryViewController.swift
//  containerExpand
//
//  Created by Zongya Chen on 12/1/19.
//  Copyright © 2019 Zongya. All rights reserved.
//

import UIKit
import expanding_collection
import RxSwift

class tryViewController: ExpandingViewController,SideMenuProtocol {

    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var confirmSearch: UIButton!
    let disposeBag = DisposeBag()
    lazy var articleListViewModel = ArticleListViewModel()
    var refresher : UIRefreshControl!

    override func viewDidLoad() {
        itemSize = CGSize(width: 231, height: 600) //IMPORTANT!!! Height of open state cell
        super.viewDidLoad()

        // register cell
        let nib = UINib(nibName: String(describing: NewsCollectionViewCell.self), bundle: nil)
//        let nib = UINib(nibName: "NibName", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing:NewsCollectionViewCell.self))
        
        addGesture(to: collectionView!)
        
        articleListViewModel.populateNews {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func refresh(){
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.isHidden = true
        confirmSearch.isHidden = true
    }
    
    fileprivate func addGesture(to view: UIView) {

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)

    }

    @objc func respondToSwipeGesture(gesture : UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? NewsCollectionViewCell else { return }
        let open = gesture.direction == .up ? true : false
        cell.cellIsOpen(open)
    }
    
    

    @IBAction func showActionSheet(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Search", style: .default , handler:{ (UIAlertAction)in
            self.searchBtn()
        }))

        alert.addAction(UIAlertAction(title: "Refresh", style: .default , handler:{ (UIAlertAction)in
            self.refresh()
        }))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .default , handler:{ (UIAlertAction)in
            self.resetBtn()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @IBAction func onConfirmSearch(_ sender: UIButton) {
        searchBtn()
    }
    
    func searchBtn() {
        if self.searchTextField.isHidden == true {
            self.searchTextField.isHidden = false
            self.confirmSearch.isHidden = false
        } else if self.searchTextField.isHidden == false && self.searchTextField.text == ""{
            self.searchTextField.isHidden = true
            self.confirmSearch.isHidden = true
            print("close textfield")
        } else{
            guard let searchword = searchTextField.text else{return}
            articleListViewModel.searchNews(searchword: searchword) {
                self.searchTextField.isHidden = true
                self.confirmSearch.isHidden = true
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.searchTextField.text = ""
                }
            }
        }
    }
    
    func resetBtn() {
        articleListViewModel.populateNews {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
}

extension tryViewController {
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return articleListViewModel.articlesVM.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing:NewsCollectionViewCell.self), for: indexPath) as? NewsCollectionViewCell else {
           fatalError("ArticleTableViewCell is not found")
       }
       let articleVM = self.articleListViewModel.articleAt(indexPath.row)
        
        articleVM.title.asObservable().subscribe(onNext: { (text) in
            cell.title.text = text
        }).disposed(by: disposeBag)
        
        articleVM.description.asObservable().subscribe(onNext: { (text) in
            cell.newsDescription.text = text
        }).disposed(by: disposeBag)
        
        articleVM.imageURL.asObservable().subscribe(onNext: { (text) in
            cell.image.downloaded(from: text)
            cell.image.contentMode = .scaleAspectFill
        }).disposed(by: disposeBag)
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell
            , currentIndex == indexPath.row else { return }

        if cell.isOpened == false {
            cell.cellIsOpen(true)

        } else {
            print("already opened")
//            cell.gapConstraint.constant = 0
            let vc = UIStoryboard.init(name: "Zongya", bundle: nil).instantiateViewController(withIdentifier: "tryTableViewController") as! tryTableViewController
            pushToViewController(vc)
            let articleVM = self.articleListViewModel.articleAt(indexPath.row)
            articleVM.title.asObservable().subscribe(onNext: { (text) in
                vc.titleLabel.text = text
            }).disposed(by: disposeBag)
            articleVM.description.asObservable().subscribe(onNext: { (text) in
                vc.descriptionLabel.text = text
            }).disposed(by: disposeBag)
            articleVM.content.asObservable().subscribe(onNext: { (text) in
                vc.contentLabel.text = text
            }).disposed(by: disposeBag)
            articleVM.url.asObservable().subscribe(onNext: { (text) in
                vc.newsUrl = text
            }).disposed(by: disposeBag)
        }
    }
    
    
}
