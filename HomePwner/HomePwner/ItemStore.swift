//
//  ItemStore.swift
//  HomePwner
//
//  Created by sean on 4/4/17.
//  Copyright © 2017 sean. All rights reserved.
//

import UIKit

class ItemStore {

  // MARK: - Properties

  var allItems = [Item]()

  let itemArchiveURL: URL = {
    return Helpers.getDocumentsDirectory(forKey: "items.archive")
  }()

  // MARK: - Initializers

  init() {
    if let archivedItems = getArchivedItems() {
      allItems = archivedItems
    }
  }

  // MARK: - Public API

  @discardableResult public func createItem() -> Item {
    let newItem = Item(random: true)
    allItems.append(newItem)
    return newItem
  }

  public func removeItem(_ item: Item) {
    if let index = allItems.index(of: item) {
      allItems.remove(at: index)
    }
  }

  public func moveItem(from fromIndex: Int, to toIndex: Int) {
    guard fromIndex != toIndex else {
      return
    }

    let movedItem = allItems[fromIndex]
    allItems.remove(at: fromIndex)
    allItems.insert(movedItem, at: toIndex)
  }

  public func saveChanges() -> Bool {
    print("[DEBUG] Saving items to: \(itemArchiveURL)")
    return NSKeyedArchiver.archiveRootObject(
      allItems,
      toFile: itemArchiveURL.path
    )
  }

  // MARK: - Private

  private func getArchivedItems() -> [Item]? {
    // TODO: how to safely handle crashes with corrupted archives
    return NSKeyedUnarchiver.unarchiveObject(
      withFile: itemArchiveURL.path
    ) as? [Item]
  }
}
