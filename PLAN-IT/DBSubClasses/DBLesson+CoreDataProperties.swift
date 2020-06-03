//
//  DBLesson+CoreDataProperties.swift
//  
//
//  Created by KiwiTech on 25/09/19.
//
//

import Foundation
import CoreData
extension DBLesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBLesson> {
        return NSFetchRequest<DBLesson>(entityName: "DBLesson")
    }

    @NSManaged public var lessonId: Int64
    @NSManaged public var lessonValue: NSData?
    @NSManaged public var courseName: String?
    @NSManaged public var index: Int64
    @NSManaged public var overSpentDescription: String?
    @NSManaged public var lessonToVideo: Set<DBLessonVideo>?
    @NSManaged public var budgetCategory: NSData?
    @NSManaged public var budgetCategoryId: Int64
    @NSManaged public var overSpentPercent: Float
    @NSManaged public var lessonSavedDate: Date?
}
