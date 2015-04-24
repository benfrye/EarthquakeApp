//
//  UIView+WTANibLoading.h
//  WTAHelpers
//
//  Created by Matt Yohe on 2/25/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This category adds a method to `UIView` to make nib loading easier.
 */
@interface UIView (WTANibLoading)

/**
 Method to load a nib with the nib name.
 
 @param nibName File name of the nib to be loaded.
 @return The loaded nib.
 */
+ (UINib *)wta_nibNamed:(NSString *)nibName;

/**
 Method to load a nib with the view's class name.
 
 @return The loaded nib.
 */
+ (UINib *)wta_nib;

/**
 Instantiates the first occurence of the view's class in the nib.
 
 @param nib to load the view from.
 @return The newly instantiated view.
 */
+ (instancetype)wta_loadInstanceWithNib:(UINib *)nib;

/**
 Instantiates the first occurence of the view's class in the nib. This method loads the nib with the name equal to the view's class.
 
 @return The newly instantiated view.
 */
+ (instancetype)wta_loadInstanceFromNib;

@end
