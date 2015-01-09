 //
//  DocumentManager.swift
//  KnowYourPulse
//
//  Created by Ingo Wiederoder on 17.07.14.
//  Copyright (c) 2014 Ingo Wiederoder. All rights reserved.
//

import UIKit
 
 
let dbName = "sceneDB"

@objc protocol DocumentManagerDelegate {
    func documentDidOpen()
    optional
    func documentDidSaveOnDevice()
}
 

class DocumentManager: NSObject {
    
    var delegate: DocumentManagerDelegate?

    var dbDocument: UIManagedDocument?  
    
    class var sharedInstance : DocumentManager {
    struct Static {
        static let instance : DocumentManager = DocumentManager()
        }
        return Static.instance
    }
    
    //---------------------------  init  -----------------------------------
    override init() {
        super.init()
         dbDocument = getDBDocument() // wenn Optional dann ist die Initialisierung nach super.init
    }

    // MARK: dbDocument
    
    private func setupDatabaseFile() {
        if let databaseDoc = dbDocument {
        databaseDoc.saveToURL(databaseDoc.fileURL, forSaveOperation: .ForCreating, completionHandler: ({
            (let success: Bool) in //Closure wie oben.
            if success == true {
                println("Document saved")
                self.delegate?.documentDidSaveOnDevice?()
            }
            else {
                println("it doesn't work")
            }
        }))
       }
    }

    
    func getDBDocument() -> UIManagedDocument! {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as NSArray // da Methode AnyObject zurück gibt
        var url: NSURL! = urls.lastObject as NSURL
        url = url.URLByAppendingPathComponent(dbName)
        //println("url: \(url)")
        let dbDoc = UIManagedDocument(fileURL: url)
        let dbState = dbDoc.documentState
        switch dbState {
        case UIDocumentState.Closed: // DocumentState ist eine Struct
            dbDoc.openWithCompletionHandler({
                (let success: Bool) in // Closure mit Bool als Argument ohne Rückhabewert. success ist frei gewählt.
                if success == true {
                    println("open Document")
                    self.delegate?.documentDidOpen()
                }
                else {
                    self.setupDatabaseFile()
                }
            })
        case UIDocumentState.EditingDisabled:
            println("Editing disabled")
        case UIDocumentState.InConflict:
            println("There is a conflict. How to solve?")
        default:
            println("Everything seems OK")
        }
        return dbDoc
    }
    
}
