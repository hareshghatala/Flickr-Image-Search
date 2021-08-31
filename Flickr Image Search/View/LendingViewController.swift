//
//  LendingViewController.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/30.
//

import UIKit

class LendingViewController: UIViewController {

    @IBOutlet weak var mainSearchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var searchHistoryTableView: UITableView! {
        didSet {
            searchHistoryTableView.layer.cornerRadius = 15
            searchHistoryTableView.layer.borderColor = UIColor(named: "Flickr-Blue")!.cgColor
            searchHistoryTableView.layer.borderWidth = 0.5
            searchHistoryTableView.tableFooterView = UIView()
        }
    }
    
    let viewModel = LendingViewModel()
    
    private var cellSize: Int = defaultCellWidth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bindImageFeedToController = { wipeData in
            self.dataBindingHandler(wipeData: wipeData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateCellSize(columns: 2)
    }

    private func calculateCellSize(columns: Int = 3) {
        let columns = columnSpace * (columns + 1)
        cellSize = (Int(view.frame.width) - columns) / 2
    }
    
    private func dataBindingHandler(wipeData: Bool) {
        if wipeData {
            if !mainCollectionView.visibleCells.isEmpty {
                mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
            }
        }
        mainCollectionView.reloadData()
    }

}

// MARK: - SearchBar Delegate methods

extension LendingViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = true
        searchBar.isSearchResultsButtonSelected = true
        searchHistoryTableView.isHidden = false
        viewModel.fetchSearchHistory()
        searchHistoryTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.isSearchResultsButtonSelected = false
        self.view.endEditing(true)
        searchHistoryTableView.isHidden = true
        performSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    private func performSearch() {
        guard let text = mainSearchBar.text, !text.isEmpty else {
            return
        }
        searchHistoryTableView.isHidden = true
        viewModel.searchOffset = 0
        viewModel.fetchImages(searchText: text, offset: viewModel.searchOffset)
    }
    
}

// MARK: - UICollectionView DataSource & Delegate methods

extension LendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: flickrFeedCellId, for: indexPath) as! FlickrImageCollectionViewCell
        
        cell.setupBackgroundColor(index: indexPath.item)
        if let imgUrl = viewModel.imageList[indexPath.item].generateImageURL() {
            cell.imageView.load(urlStr: imgUrl)
        }
        
        return cell
    }
}

extension LendingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// Cell animation
        cell.alpha = 0
        let dir = ((indexPath.item % 2) == 0) ? 150 : -150
        let transform = CATransform3DTranslate(CATransform3DIdentity, CGFloat(dir), 0, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
        
        /// Loading next page data
        print("willDisplay \(indexPath.item) \(indexPath.row) - \(indexPath.item == viewModel.imageList.count - 5)")
        if indexPath.item == viewModel.imageList.count - 5 {
            guard let text = mainSearchBar.text, !text.isEmpty else {
                return
            }
            viewModel.fetchImages(searchText: text, offset: viewModel.searchOffset)
        }
    }
    
}

extension LendingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - TableView DataSource & Delegate methods

extension LendingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: searchHistoryCellId) {
            cell = dequeueCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: searchHistoryCellId)
        }
        cell.backgroundColor = .clear
        cell.textLabel?.text = viewModel.searchHistory[indexPath.row]
        
        return cell
    }
    
}

extension LendingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainSearchBar.text = viewModel.searchHistory[indexPath.row]
        self.view.endEditing(true)
        performSearch()
    }
    
}
