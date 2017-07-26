//
//  Models.swift
//  testPol
//
//  Created by Pavel Boryseiko on 26/7/17.
//  Copyright © 2017 GRIDSTONE. All rights reserved.
//

import UIKit
import MPOLKit

class TestSource: EntitySource {
    var localizedBadgeTitle: String = "Test"
    var localizedBarTitle: String = "Test"
    var serverSourceName: String = "TestServer"
}

class TestParams: Parameterisable {
    var parameters: [String : Any] = [String: Any]()
}

class TestViewModel: SearchViewModel {
    var recentViewModel: SearchRecentsViewModel = TestRecentViewModel()
    var dataSources: [DataSourceable] = [SomeEntityDataSource()]
}

class TestRecentViewModel: SearchRecentsViewModel {

    private var internalRecentlyViewed: [TestEntity] = [TestEntity]()

    var title: String = "TEST"
    var recentlyViewed: [MPOLKitEntity] {
        get {
            return internalRecentlyViewed
        }
        set {
            guard let entities = newValue as? [TestEntity] else { return }
            internalRecentlyViewed = entities
        }
    }

    func decorate(cell: EntityCollectionViewCell, at indexPath: IndexPath) {

    }

    func summaryIcon(for searchable: Searchable) -> UIImage? {
        guard let type = searchable.type else { return nil }
        switch type {
        case "Hello":
            return .personOutline
        case "I'm a title":
            return .carOutline
        default:
            return nil
        }
    }
}

class TestFilter: Filtering {

    var filter1: String?
    var filter2: String?

    var numberOfFilters: Int = 2

    func defaultValue(at index: Int) -> String {
        switch index {
        default:
            return "Any"
        }
    }

    func title(at index: Int) -> String {
        switch index {
        case 0:
            return "Hello"
        case 1:
            return "I'm a title"
        default:
            return "Bleh"
        }
    }

    func value(at index: Int) -> String? {
        switch index {
        case 0:
            return filter1
        case 1:
            return String(describing: filter2)
        default:
            return nil
        }
    }
}

struct TestPickable: Pickable {
    var title: String? = "TestMe"
    var subtitle: String? = "SubMe"
}

class TestEntitySearchRequest: SearchRequest {
    override func searchOperation(forSource source: EntitySource, params: Parameterisable, completion: (([MPOLKitEntity]?, Error?) -> ())?) throws -> (searchOperation: GroupOperation, updateDataOperation: BlockOperation)? {

        guard let params = params as? TestParams else { return nil }

        let searchOperation = APIManager().searchEntityOperation(from: source, with: params)

        let updateDataOperation = BlockOperation {
            let response = searchOperation.response
            let entities = response?.result.value?.results
            let error = response?.result.error

            completion?(entities, error)
        }

        return (searchOperation, updateDataOperation)
    }
}

class SomeEntityDataSource: DataSourceable {

    private var internalEntities: [TestEntity] = [TestEntity]()

    static var autoCapitalizationType: UITextAutocapitalizationType = .allCharacters
    static var keyboardType: UIKeyboardType = .default

    var entities: [MPOLKitEntity]? {
        get {
            return internalEntities
        }

        set {
            guard let entities = newValue as? [TestEntity] else { return }
            internalEntities = entities
        }
    }

    var sortedEntities: [MPOLKitEntity]? {
        get {
            return internalEntities.sorted(by: { (entity, entity2) -> Bool in
                return entity.name! < entity2.name!
            })
        }
        set {}
    }

    var filteredEntities: [MPOLKitEntity]? {
        get {
            return internalEntities.filter{$0.username == "Bret"}
        }
        set{}
    }

    var filter: Filtering = TestFilter()

    var updatingDelegate: SearchDataSourceUpdating?

    var localizedDisplayName: String = "Test"
    var localizedSourceBadgeTitle: String = "Test"

    func updateController(forFilterAt index: Int) -> UIViewController? {
        guard let filter = filter as? TestFilter else { return nil }
        var viewController = UIViewController()

        switch index {
        case 0:
            let values = Array(repeating: TestPickable(), count: 4)
            let picker = PickerTableViewController(style: .plain, items: values)
            picker.selectionUpdateHandler = { [weak self] (_, selectedIndexes) in
                guard let `self` = self, let selectedTypeIndex = selectedIndexes.first else { return }
                filter.filter1 = values[selectedTypeIndex].title
                self.updatingDelegate?.searchDataSource(self, didUpdateFilterAt: index)
            }
            viewController = picker
        case 1:
            let values = Array(repeating: TestPickable(), count: 2)
            let picker = PickerTableViewController(style: .plain, items: values)
            picker.selectionUpdateHandler = { [weak self] (_, selectedIndexes) in
                guard let `self` = self, let selectedTypeIndex = selectedIndexes.first else { return }
                filter.filter2 = values[selectedTypeIndex].subtitle
                self.updatingDelegate?.searchDataSource(self, didUpdateFilterAt: index)
            }
            viewController = picker

        default:
            break
        }

        return PopoverNavigationController(rootViewController: viewController)
    }

    func searchOperation(searchable: Searchable, completion: ((Bool, Error?) -> ())?) throws -> (searchOperation: GroupOperation, updateDataOperation: BlockOperation)? {
        guard let searchTerm = searchable.searchText else { return nil }
        let request = TestEntitySearchRequest()
        return try request.searchOperation(forSource: TestSource(), params: TestParams()) { [weak self] entities, error in
            self?.entities = entities
            completion?(entities != nil, error)
        }
    }

    func decorate(cell: EntityCollectionViewCell, at indexPath: IndexPath, style: EntityCollectionViewCell.Style) {

    }

    func decorateAlert(cell: EntityCollectionViewCell, at indexPath: IndexPath, style: EntityCollectionViewCell.Style) {
        
    }
    
    func decorateList(cell: EntityListCollectionViewCell, at indexPath: IndexPath) {
        
    }
}
