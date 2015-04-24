//
//  WTAData.m
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

#import "WTAData.h"

#import "NSManagedObjectContext+WTAData.h"
#import "NSManagedObject+WTAData.h"

@interface WTAData ()

@property (nonatomic, strong, readwrite) WTADataConfiguration *configuration;
@property (nonatomic, readwrite, setter=setInvalidated:) BOOL isInvalidated;

@end

@implementation WTAData

- (instancetype)initWithModelNamed:(NSString *)modelName
{
    WTADataConfiguration *configuration = [WTADataConfiguration defaultConfigurationWithModelNamed:modelName];
    return [self initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(WTADataConfiguration *)configuration
{
    self = [super init];
    if (self)
    {
        self.configuration = configuration;
        [self setupContexts];
        
        if (configuration.shouldUseInMemoryStore) {
            [self setupPersistentStoreInMemory];
        }
        else {
            [self setupPersistentStore];
        }
    }
    
    return self;
}

- (instancetype)initInMemoryStackWithModelNamed:(NSString*)modelName
{
    WTADataConfiguration *configuration = [WTADataConfiguration defaultConfigurationWithModelNamed:modelName];
    [configuration setShouldUseInMemoryStore:YES];
    return [self initWithConfiguration:configuration];
}

- (void)setupContexts
{
    NSParameterAssert(self.configuration.managedObjectModelFileURL);
    
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.configuration.managedObjectModelFileURL];
    
    NSAssert(self.managedObjectModel, @"Could not locate model %@", self.configuration.managedObjectModelFileURL.path);

    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    self.backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    // register mainContext to listen and marge in changes from the background context
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundContextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.backgroundContext];
    
}

- (void)setupPersistentStoreInMemory
{
    NSMutableDictionary *options = [NSMutableDictionary new];
    if (self.configuration.persistentStoreCoordinatorOptions)
    {
        [options setValuesForKeysWithDictionary:self.configuration.persistentStoreCoordinatorOptions];
    }
    
    // Disable auto-migration for in memory stores
    [options setObject:@(NO) forKey:NSMigratePersistentStoresAutomaticallyOption];
    
    NSError *error;
    NSPersistentStore *persistentStore = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSInMemoryStoreType
                                                                                         configuration:nil
                                                                                                   URL:nil
                                                                                               options:options
                                                                                                 error:&error];
    if (!persistentStore) {
        if (error) {
            abort();
        }
    }
}

- (void)setupPersistentStore
{
    NSParameterAssert(self.configuration.persistentStoreFileURL);
    
    // Create the target directory if it does not exist
    NSURL *targetDirectory = [[[self configuration] persistentStoreFileURL] URLByDeletingLastPathComponent];
    [WTAData createDirectoryAtPathIfNeeded:targetDirectory.relativePath];
    
    NSMutableDictionary *options = [NSMutableDictionary new];
    if (self.configuration.persistentStoreCoordinatorOptions)
    {
        [options setValuesForKeysWithDictionary:self.configuration.persistentStoreCoordinatorOptions];
    }
    
    if (self.configuration.shouldDeleteStoreFileOnIntegrityErrors)
    {
        [options addEntriesFromDictionary:@{
                                            @"NSSQLitePragmasOption": @{@"integrity_check": @YES}
                                            }];
    }
    
    // Add sqlite store to coordinator
    NSError *error;
    NSPersistentStore *persistentStore = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                                                         configuration:nil
                                                                                                   URL:self.configuration.persistentStoreFileURL
                                                                                               options:options
                                                                                                 error:&error];
    if (!persistentStore)
    {
        BOOL shouldDeleteStoreAndRetry = NO;
        
        // Check for SQL integrity error recovery
        if (self.configuration.shouldDeleteStoreFileOnIntegrityErrors)
        {
            shouldDeleteStoreAndRetry = ([error userInfo][NSSQLiteErrorDomain] != nil);
        }
        
        // Check for model version mismatch recovery
        if (shouldDeleteStoreAndRetry == NO && self.configuration.shouldDeleteStoreFileOnModelMismatch)
        {
            shouldDeleteStoreAndRetry = ([[error domain] isEqualToString:NSCocoaErrorDomain] &&
                                         ([error code] == NSPersistentStoreIncompatibleVersionHashError ||
                                          [error code] == NSMigrationMissingSourceModelError));
        }
        
        if (shouldDeleteStoreAndRetry)
        {
            // Remove old database
            [[self configuration] deleteExistingStoreFile:&error];
#ifdef DEBUG
            NSLog(@"Removed incompatible persistent store: %@", self.configuration.persistentStoreFileURL);
#endif
            
            // Try one more time to create the store
            NSPersistentStore *store = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                                                       configuration:nil
                                                                                                 URL:self.configuration.persistentStoreFileURL
                                                                                             options:options
                                                                                               error:&error];
            if (store)
            {
                // If we successfully added a store, remove the error that was initially created
                error = nil;
            }
        }
        
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
        if (error)
        {
            abort();
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)invalidateStack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mainContext = nil;
    self.backgroundContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    self.isInvalidated = YES;
}

- (void)backgroundContextDidSave:(NSNotification*)notification
{
    [self.mainContext performBlock:^{
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

- (void)saveInBackground:(void (^)(NSManagedObjectContext *context))work
              completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    NSAssert1(!self.isInvalidated, @"Attempted to invoke %s on an invalidated core data stack.", __PRETTY_FUNCTION__);
    [self.backgroundContext saveBlock:work completion:completion];
}

-(BOOL)saveInBackgroundAndWait:(void (^)(NSManagedObjectContext *context))work error:(NSError **)error;
{
    NSAssert1(!self.isInvalidated, @"Attempted to invoke %s on an invalidated core data stack.", __PRETTY_FUNCTION__);
   return [self.backgroundContext saveBlockAndWait:work error:error];
}

- (void)deleteAllDataWithCompletion:(void (^)(NSError*))completion
{
    NSAssert1(!self.isInvalidated, @"Attempted to invoke %s on an invalidated core data stack.", __PRETTY_FUNCTION__);
    [self.backgroundContext saveBlock:^(NSManagedObjectContext *context) {
        
        NSArray *entityNames = [[self.managedObjectModel entities] valueForKey:@"name"];
        for (NSString *entityName in entityNames) {
            Class class = NSClassFromString(entityName);
            [class deleteAllInContext:context];
        }
        
    } completion:^(BOOL savedChanges, NSError *error) {
      
        if (completion)
        {
            completion(error);
        }
        
    }];
}

#pragma mark - File Helpers

+ (void)createDirectoryAtPathIfNeeded:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        return;
    }
    
    NSError* error;
    BOOL fileCreated = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
    if (!fileCreated) {
#ifdef DEBUG
        NSLog(@"%@", error.localizedDescription);
#endif
        abort();
    }
}

#pragma mark - Description

- (NSString *)description
{
    NSString *description = [super description];
    NSArray *propertyKeys = @[NSStringFromSelector(@selector(configuration)),
                              NSStringFromSelector(@selector(isInvalidated)),
                              NSStringFromSelector(@selector(managedObjectModel)),
                              NSStringFromSelector(@selector(persistentStoreCoordinator)),
                              NSStringFromSelector(@selector(backgroundContext)),
                              NSStringFromSelector(@selector(mainContext))];
    NSDictionary *dictionaryValue = [self dictionaryWithValuesForKeys:propertyKeys];
    return [description stringByAppendingFormat:@"\n%@", dictionaryValue];
}

@end
