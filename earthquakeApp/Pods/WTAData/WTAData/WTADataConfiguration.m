//
//  WTADataConfiguration.m
//  WTADataExample
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

#import "WTADataConfiguration.h"
#import <CoreData/CoreData.h>

@implementation WTADataConfiguration

+ (instancetype)defaultConfigurationWithModelNamed:(NSString *)modelName
{
    WTADataConfiguration *configuration = [WTADataConfiguration new];
    
    // Set the managed object model file url
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    if (modelURL == nil)
    {
        modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"mom"];
    }
    [configuration setManagedObjectModelFileURL:modelURL];
    
    // Set the default persistent store based on the model name
    NSString *bundleName = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    NSString *storeName = [NSString stringWithFormat:@"%@.sqlite", modelName];
    NSURL *persistentStoreFileURL = [self applicationSupportDirectoryURL];
    persistentStoreFileURL = [persistentStoreFileURL URLByAppendingPathComponent:bundleName];
    persistentStoreFileURL = [persistentStoreFileURL URLByAppendingPathComponent:storeName];
    [configuration setPersistentStoreFileURL:persistentStoreFileURL];
    [configuration setPersistentStoreCoordinatorOptions:[self defaultPersistentStoreCoordinatorOptions]];
    
    return configuration;
}

+ (NSDictionary *)defaultPersistentStoreCoordinatorOptions
{
    return @{
             NSMigratePersistentStoresAutomaticallyOption: @(YES),
             NSInferMappingModelAutomaticallyOption: @(YES)
             };
}

+ (NSURL *)applicationSupportDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)deleteExistingStoreFile:(NSError **)error
{
    NSParameterAssert(self.persistentStoreFileURL);
    BOOL success = NO;
    if (self.persistentStoreFileURL)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:self.persistentStoreFileURL.relativePath])
        {
            NSURL *fileStoreURL = self.persistentStoreFileURL;
            NSURL *fileStoreShmURL = [NSURL URLWithString:[[fileStoreURL absoluteString] stringByAppendingString:@"-shm"]];
            NSURL *fileStoreWalURL = [NSURL URLWithString:[[fileStoreURL absoluteString] stringByAppendingString:@"-wal"]];
            
            NSError *fileError = nil;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtURL:fileStoreURL error:&fileError];
            [fileManager removeItemAtURL:fileStoreShmURL error:nil];
            [fileManager removeItemAtURL:fileStoreWalURL error:nil];
            
            success = (fileError == nil);
            if (error)
            {
                *error = fileError;
            }
        }
    }
    return success;
}

- (NSString *)description
{
    NSString *description = [super description];
    NSArray *propertyKeys = @[NSStringFromSelector(@selector(managedObjectModelFileURL)),
                              NSStringFromSelector(@selector(persistentStoreFileURL)),
                              NSStringFromSelector(@selector(persistentStoreCoordinatorOptions)),
                              NSStringFromSelector(@selector(shouldDeleteStoreFileOnModelMismatch)),
                              NSStringFromSelector(@selector(shouldDeleteStoreFileOnIntegrityErrors)),
                              NSStringFromSelector(@selector(shouldUseInMemoryStore))];
    NSDictionary *dictionaryValue = [self dictionaryWithValuesForKeys:propertyKeys];
    return [description stringByAppendingFormat:@"\n%@", dictionaryValue];
}

@end
