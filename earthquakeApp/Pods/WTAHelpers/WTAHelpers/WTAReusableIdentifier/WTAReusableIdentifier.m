//
//  WTAReusableIdentifier.h
//  WTAHelpers
//
//  Created by Trung Tran on 2/25/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import "WTAReusableIdentifier.h"

@implementation UICollectionReusableView (WTAReusableIdentifier)

+ (NSString *)wta_reuseableIdentifier
{
    return NSStringFromClass([self class]);
}

@end

@implementation UITableViewCell (WTAReusableIdentifier)

+ (NSString *)wta_reuseableIdentifier
{
    return NSStringFromClass([self class]);
}

@end

@implementation UITableViewHeaderFooterView (WTAReusableIdentifier)

+ (NSString *)wta_reuseableIdentifier
{
    return NSStringFromClass([self class]);
}

@end
