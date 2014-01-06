//
//  MEDocumentManager.m
//  KnowYourJobs
//
//  Created by Ingo Wiederoder on 04.02.13.
//  Copyright (c) 2013 Ingo Wiederoder. All rights reserved.
//

#import "MEDocumentManager.h"

@implementation MEDocumentManager


- (id)init
{
    self = [super init];
    if (self) {
        //doso
    }
    return self;
}

+ (MEDocumentManager* )sharedManager
{
    static MEDocumentManager *sharedDocumentManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDocumentManager = [[MEDocumentManager alloc] init];
    });
    return sharedDocumentManager;
}


- (UIManagedDocument *)dbDocument
{
    if (_dbDocument) return _dbDocument;
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:DOCUMENTNAME];
    _dbDocument = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([_dbDocument documentState] == UIDocumentStateClosed) {
        [_dbDocument openWithCompletionHandler:^(BOOL success) {
            if (!success) {
                [self setupDatabaseFile];
            }
            if (success) {
                [self.documentDelegate documentDidOpen:_dbDocument];
            }
        }];
    }
    if ([_dbDocument documentState] == UIDocumentStateEditingDisabled) {
        NSLog(@"Editing disabled!");
    }
    if ([_dbDocument documentState] == UIDocumentStateInConflict) {
        NSLog(@"Conflict");
    }
    return _dbDocument;
}


- (void)setupDatabaseFile
{
    [self.dbDocument saveToURL:self.dbDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            [self.documentDelegate documentDidSaveOnDevice:_dbDocument];
        }
    }];
}

@end
