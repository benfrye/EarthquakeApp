//
//  UIView+WTANibLoading.m
//  WTAHelpers
//
//  Created by Matt Yohe on 2/25/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import "UIView+WTANibLoading.h"

@implementation UIView (WTANibLoading)

+ (UINib *)wta_nibNamed:(NSString *)nibName
{
    return [UINib nibWithNibName:nibName bundle:nil];
}

+ (UINib *)wta_nib
{
    return [self wta_nibNamed:NSStringFromClass([self class])];
}

+ (instancetype)wta_loadInstanceWithNib:(UINib *)nib
{
    UIView *result = nil;
    NSArray *topLevelObjects = [nib instantiateWithOwner:nil options:nil];
    for (id anObject in topLevelObjects)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    
    return result;
}

+ (instancetype)wta_loadInstanceFromNib
{
    return [self wta_loadInstanceWithNib:[self wta_nib]];
}

@end
