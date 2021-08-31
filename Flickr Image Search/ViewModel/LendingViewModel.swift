//
//  LendingViewModel.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/30.
//

import Foundation

class LendingViewModel {
    
    private var searchData: PhotoDetails?
    
    private(set) var imageList: [PhotoItem] = []
    private(set) var searchHistory: [String] = []
    
    var serviceSession = Service.shared
    var bindImageFeedToController: ((Bool) -> ()) = { wipeData in }
    var searchOffset = 1
    
    init() {
        fetchSearchHistory()
        fetchImages(searchText: "", offset: searchOffset)
    }
    
    // MARK: -  Network calls
    
    func fetchImages(searchText: String, offset: Int) {
        print("Searching Offset: \(offset)")
        if offset != 1 && offset > (searchData?.pages ?? 0) {
            return
        }
        
        ProgressHUD.show()
        var searchStr = searchHistory.isEmpty ? defaultSearchTerm : searchHistory[0]
        if !searchText.isEmpty {
            searchStr = searchText.capitalized
        }
        insertSearchHistory(text: searchStr)
        
        serviceSession.SearchImages(searchText: searchStr, offset: offset) { (result: Result<SearchDetails, ServiceError>) in
            switch result {
            case .success(let searchList):
                self.handleSuccess(response: searchList, wipeData: (offset == 0))
                
            case .failure(let error):
                self.handleFailure(error: error)
            }
            ProgressHUD.dismiss()
        }
    }
    
    private func handleSuccess(response: SearchDetails, wipeData: Bool = false) {
        searchData = response.photos
        guard let photoList = searchData?.photo else {
            return
        }
        
        if wipeData {
            imageList.removeAll()
        }
        imageList.append(contentsOf: photoList)
        searchOffset += 1
        print("Response: Page-\(searchData?.page ?? 0) TotalPages-\(searchData?.pages ?? 0)")
        updateDataToView(wipeData: wipeData)
    }
    
    private func handleFailure(error: ServiceError) {
        switch error {
        case .invalidEndpoint:
            ProgressHUD.show(errorMsgInvalidEndpoint, icon: .failed, interaction: true)
        case .invalidResponse, .decodeError:
            ProgressHUD.show(errorMsgInvalidResponse, icon: .failed, interaction: true)
        default:
            ProgressHUD.show(errorMsgUnknown, icon: .failed, interaction: true)
        }
    }
    
    // MARK: - Helper methods
    
    func fetchSearchHistory() {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let plistPath = docPath.appendingPathComponent(searchHistoryPlistFile).path
        
        guard let xml = FileManager.default.contents(atPath: plistPath),
              let history = try? PropertyListDecoder().decode([String].self, from: xml) else {
            return
        }
        searchHistory = history
    }
    
    func saveSearchHistory() {
        var plistPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        plistPath.appendPathComponent(searchHistoryPlistFile)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        do {
            let data = try encoder.encode(searchHistory)
            try data.write(to: plistPath)
        } catch {
            print(error)
        }
        
    }
    
    // MARK: -  Private methods
    
    private func updateDataToView(wipeData: Bool) {
        DispatchQueue.main.async {
            self.bindImageFeedToController(wipeData)
        }
    }
    
    private func insertSearchHistory(text: String) {
        if let indx = searchHistory.firstIndex(of: text) {
            searchHistory.remove(at: indx)
        }
        searchHistory.insert(text, at: 0)
        
        if searchHistory.count > searchHistoryLimit {
            searchHistory.removeLast()
        }
        saveSearchHistory()
    }
    
}
