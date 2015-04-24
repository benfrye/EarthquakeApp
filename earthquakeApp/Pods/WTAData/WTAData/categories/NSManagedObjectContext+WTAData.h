//
//  NSManagedObjectContext+WTAData.h
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

/** 
 The NSManagedObjectContext category provides additional functionality for saving the managed 
 contexts and for performing saves in the background.
 */
@interface NSManagedObjectContext (WTAData)

/**
 Saves the current managed object context synchronously.
 */
- (void)saveContext;

/**
 Saves the current context.
 
 @param error the error object to return if an error occurs.
 
 @return YES if the context saved properly.
 */
- (BOOL)saveContext:(NSError **)error;

/**
 Asynchronously saves the current context in the background, first performing the specified work
 block, and calling with the specified completion block once the save is complete.
 
 @param work block of work to perform on the current context before performing the save.
 @param completion completion block called when the save is complete. Indicates if the changes were
 saved and returns any errors encountered during the save.
 */
- (void)saveBlock:(void (^)(NSManagedObjectContext *context))work
       completion:(void (^)(BOOL savedChanges, NSError *error))completion;

/**
 Synchronously saves the current context in the background, first performing the specified work
 block, and calling with the specified completion block once the save is complete.
 
 @param work block of work to perform on the current context before performing the save.
 @param error error object that is populated if an error occurs
 
 @return YES if the save was successful
 */
- (BOOL)saveBlockAndWait:(void (^)(NSManagedObjectContext *context))work error:(NSError **)error;

@end
