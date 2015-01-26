 //
//  DocumentManager.swift
//  KnowYourPulse
//
//  Created by Ingo Wiederoder on 17.07.14.
//  Copyright (c) 2014 Ingo Wiederoder. All rights reserved.
//

import UIKit
 
 
 let dbName = "docName"
 
 @objc protocol DocumentManagerDelegate {
    func documentDidOpen()
    optional
    func documentDidSaveOnDevice()
 }
 
 
 class DocumentManager: NSObject {
    
    var delegate: DocumentManagerDelegate?
    
    //var dbDocument: UIManagedDocument?
    
    
    lazy var dbDocument: UIManagedDocument?  = {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as NSArray // da Methode AnyObject zurück gibt
        var url: NSURL! = urls.lastObject as NSURL
        url = url.URLByAppendingPathComponent(dbName)
        //println("url: \(url)")
        let dbDoc = UIManagedDocument(fileURL: url)
        let dbState = dbDoc.documentState
        switch dbState {
        case UIDocumentState.Closed:
            dbDoc.openWithCompletionHandler({
                (let success: Bool) in
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
        }()
    
    
    class var sharedInstance : DocumentManager {
        struct Static {
            static let instance : DocumentManager = DocumentManager()
        }
        return Static.instance
    }
    
    //---------------------------  init  -----------------------------------
    override init() {
        super.init()
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
 }