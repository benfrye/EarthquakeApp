//
//  WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTree, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "WTADataConfiguration.h"

/**
 WTAData provides a simplified interface to setting up an asynchronous CoreData stack.  WTAData 
 utilizes two NSManagedObjectContexts: a main context generally used by UI binding and a background
 context that is used to import data from an API for example.  The main context listens for
 notifications of changes on the background context and will update when the background context
 saves.  In most cases, saves will generally be done on the background context and the main context 
 is used for reading the data and responding to changes.
 */
@interface WTAData : NSObject

/// The current managed object model
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

/// Context used with concurency type NSMainQueueConcurrencyType. This context is typically used
/// for pulling data from the store and fetch requests.
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

/// Context used with the concurrency type NSPrivateQueueConcurrencyType. This context is used for
/// background saving of items in the store. This is the context used by the background saving
/// functions.
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;

/// Coordinator used by the stack
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/// The stack configuration
@property (nonatomic, strong, readonly) WTADataConfiguration *configuration;

/**
 Initialize a data stack using the specified configuration.
 
 @param configuration the configuration defining resource disk location and options
 
 @return instance of the WTAData class
 */
- (instancetype)initWithConfiguration:(WTADataConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object.
 
 @param modelName name of the managed object model to load
 
 @return instance of the WTAData class
 */
- (instancetype)initWithModelNamed:(NSString *)modelName;

/**
 Initialize an in-memory data stack using the specified model.
 
 @param modelName name of the managed object model to load
 
 @return instance of the WTAData class
 */
- (instancetype)initInMemoryStackWithModelNamed:(NSString *)modelName;

/**
 Shuts down the core data stack and cleans up all objects.  This should be called on application
 shutdown.
 */
- (void)invalidateStack;

/**
 Perform save in the background using the backgroundContext. Changes are then propagated to 
 the main context.
 
 @param work the block that operates on the managed objects to save
 @param completion block called when the save is complete
 */
-(void)saveInBackground:(void (^)(NSManagedObjectContext *context))work
             completion:(void (^)(BOOL savedChanges, NSError *error))completion;

/**
 Perform save in the background using the backgroundContext and wait for completion. Changes are 
 then propagated to the main context.
 
 @param work the block that operates on the managed objects to save

 @return YES if the save was successful
 */
-(BOOL)saveInBackgroundAndWait:(void (^)(NSManagedObjectContext *context))work error:(NSError **)error;

/**
 Perform save in the specified context.
 
 @param context the context to save on
 @param wait YES if the operation is blocking, NO for non-blocking
 @param work the block that operates on the managed objects to save
 @param completion block called when the save is complete
 */
- (void)deleteAllDataWithCompletion:(void (^)(NSError *))completion;

@end
