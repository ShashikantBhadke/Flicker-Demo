//
//  CoreDataHelper.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 23/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataHelper {
    
    // MARK:- Private Methods
    class private func getContext()-> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK:- Public Methods
    class func getLastData(_ table: CoreDataTable, _ complection: @escaping((Result<Data>)->())) {
        
        let context = getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: table.rawValue)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context?.fetch(request)
            if let firstObj = result?.first as? NSManagedObject, let dataObj = firstObj.value(forKey: CoreDataTableKeys.data.rawValue) as? Data, !dataObj.isEmpty {
                complection(.success(dataObj))
            } else {
                complection(.error("No data found inside CoreDB"))
            }
        } catch let coreDataErr {
            complection(.error(coreDataErr.localizedDescription))
        }
    }
    
    class func saveData(_ dataObj: Data, table: CoreDataTable) {
        guard let context = getContext() else { return }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: table.rawValue)
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.isEmpty {
                let newEntity = NSEntityDescription.insertNewObject(forEntityName: table.rawValue, into: context)
                newEntity.setValue(dataObj, forKey: CoreDataTableKeys.data.rawValue)
                newEntity.setValue(Date(), forKey: CoreDataTableKeys.lastDate.rawValue)
                
                try context.save()
                
            } else if let firstObj = result.first as? NSManagedObject {
                firstObj.setValue(dataObj, forKey: CoreDataTableKeys.data.rawValue)
                firstObj.setValue(Date(), forKey: CoreDataTableKeys.lastDate.rawValue)
                
                try context.save()
            }
        } catch let coreDataErr {
            print(coreDataErr.localizedDescription)
        }
    }
    
} //class
