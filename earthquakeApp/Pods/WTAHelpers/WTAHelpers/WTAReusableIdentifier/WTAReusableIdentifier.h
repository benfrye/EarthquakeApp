//
//  WTAReusableIdentifier.h
//  WTAHelpers
//
//  Created by Trung Tran on 2/25/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This category adds a method to `UICollectionReusableView` to make reusableIdentifiers easier.
 */
@interface UICollectionReusableView (WTAReusableIdentifier)

/**
 @return String of the class's name.
 */
+ (NSString *)wta_reuseableIdentifier;

@end

/**
 This category adds a method to `UITableViewCell` to make reusableIdentifiers easier.
 */
@interface UITableViewCell (WTAReusableIdentifier)

/**
 @return String of the class's name.
 */
+ (NSString *)wta_reuseableIdentifier;

@end

/**
 This category adds a method to `UITableViewHeaderFooterView` to make reusableIdentifiers easier.
 */
@interface UITableViewHeaderFooterView (WTAReusableIdentifier)

/**
 @return String of the class's name.
 */
+ (NSString *)wta_reuseableIdentifier;

@end
