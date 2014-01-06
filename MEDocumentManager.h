//
//  MEDocumentManager.h
//  KnowYourJobs
//
//  Created by Ingo Wiederoder on 04.02.13.
//  Copyright (c) 2013 Ingo Wiederoder. All rights reserved.
//

#define DOCUMENTNAME

#import <Foundation/Foundation.h>

@protocol MEDocumentManagerDelegate <NSObject>

- (void)documentDidOpen:(UIManagedDocument *)document;
@optional
- (void)documentDidSaveOnDevice:(UIManagedDocument *)document;

@end

@interface MEDocumentManager : NSObject


@property (nonatomic, strong) UIManagedDocument *dbDocument;
@property (nonatomic, weak) id <MEDocumentManagerDelegate> documentDelegate;
+ (MEDocumentManager *)sharedManager;


@end
