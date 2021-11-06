//
//  NSManagedObject.swift
//  CatalogIndah
//
//  Created by Indah Nurindo on 02/09/21.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    static var current: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
