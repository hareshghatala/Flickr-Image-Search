//
//  LendingViewModelTests.swift
//  Flickr Image SearchTests
//
//  Created by Haresh Ghatala on 2021/08/31.
//

import XCTest
@testable import Flickr_Image_Search

class LendingViewModelTests: XCTestCase {
    
    var mockService: MockService!
    
    var mockphotoItem1: PhotoItem!
    var mockphotoItem2: PhotoItem!
    var mockphotoItem3: PhotoItem!
    var mockPhotoItem: [PhotoItem]!
    var mockPhotoDetails: PhotoDetails!
    var mockData: SearchDetails!
    
    override func setUpWithError() throws {
        mockService = MockService.mockShared
        
        mockphotoItem1 = PhotoItem(id: "Id-1", owner: "Owner-1", secret: "Secret-1", server: "Server-1", farm: 11, title: "Sample Title 1", ispublic: 1, isfriend: 0, isfamily: 1)
        mockphotoItem2 = PhotoItem(id: "Id-2", owner: "Owner-2", secret: "Secret-2", server: "Server-2", farm: 22, title: "Sample Title 2", ispublic: 0, isfriend: 1, isfamily: 0)
        mockphotoItem3 = PhotoItem(id: "Id-3", owner: "Owner-3", secret: "Secret-3", server: "Server-3", farm: 33, title: "Sample Title 3", ispublic: 1, isfriend: 0, isfamily: 1)
        mockPhotoItem = [mockphotoItem1, mockphotoItem2, mockphotoItem3]
        mockPhotoDetails = PhotoDetails(page: 1, pages: 1230, perpage: 3, total: 3750, photo: mockPhotoItem)
        mockData = SearchDetails(photos: mockPhotoDetails, stat: "ok")
    }
    
    override func tearDownWithError() throws {
        mockService = nil
        mockphotoItem1 = nil
        mockphotoItem2 = nil
        mockphotoItem3 = nil
        mockPhotoItem = nil
        mockPhotoDetails = nil
        mockData = nil
    }
    
    func testViewModelInitialsCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.noData
        
        let obj = LendingViewModel()
        obj.serviceSession = mockService
        XCTAssertNotNil(obj)
    }
    
    func testFetchImagesRetrievesDataCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = LendingViewModel()
        obj.serviceSession = mockService
        
        obj.fetchImages(searchText: "Sample", offset: 1)
        
        XCTAssertEqual(obj.imageList, mockPhotoItem)
        XCTAssertEqual(obj.imageList.count, 3)
        XCTAssertEqual(obj.searchOffset, 2)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchImagesPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = LendingViewModel()
        obj.serviceSession = mockService
        
        obj.fetchImages(searchText: "Sample", offset: 1)
        obj.fetchImages(searchText: "Sample", offset: 2)
        
        XCTAssertEqual(obj.imageList.count, 6)
        XCTAssertEqual(obj.searchOffset, 3)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchImagesOverPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = LendingViewModel()
        obj.serviceSession = mockService
        
        obj.fetchImages(searchText: "Sample", offset: 1)
        obj.fetchImages(searchText: "Sample", offset: 2)
        
        XCTAssertEqual(obj.imageList.count, 6)
        XCTAssertEqual(obj.searchOffset, 3)
        
        obj.fetchImages(searchText: "Sample", offset: 1231)
        XCTAssertEqual(obj.imageList.count, 6)
        XCTAssertEqual(obj.searchOffset, 3)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchImagesFailureHandledCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.invalidResponse
        
        let obj = LendingViewModel()
        obj.serviceSession = mockService
        
        obj.fetchImages(searchText: "Sample", offset: 1)
        
        XCTAssertTrue(obj.imageList.isEmpty)
        XCTAssertEqual(obj.searchOffset, 1)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchSearchHistoryRetrievesDataCorrectly() throws {
        let obj = LendingViewModel()
        obj.fetchSearchHistory()
        
        XCTAssertGreaterThan(obj.searchHistory.count, 0)
    }
    
    func testSaveSearchHistoryWorksCorrectly() throws {
        let obj = LendingViewModel()
        obj.saveSearchHistory()
        obj.fetchSearchHistory()
        
        XCTAssertGreaterThan(obj.searchHistory.count, 0)
    }
}
