//
//  NSLayoutConstraint+WTAAutoLayoutHelpers.h
//  WTAHelpers
//
//  Created by Trung Tran on 2/25/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (WTAAutoLayoutHelpers)

///---------------------------------
/// @name Edge Creating Constraints
///---------------------------------

+ (NSLayoutConstraint *)wta_topConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;
+ (NSLayoutConstraint *)wta_leadingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;
+ (NSLayoutConstraint *)wta_bottomConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;
+ (NSLayoutConstraint *)wta_trailingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;

+ (NSLayoutConstraint *)wta_topConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation;
+ (NSLayoutConstraint *)wta_leadingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation;
+ (NSLayoutConstraint *)wta_bottomConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation;
+ (NSLayoutConstraint *)wta_trailingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation;

///----------------------------------------
/// @name Side-by-Side separation Constraints
///----------------------------------------

+ (NSLayoutConstraint *)wta_trailingToLeadingConstraintWithTrailingView:(UIView *)trailingView leadingView:(UIView *)leadingView separation:(CGFloat)separation;
+ (NSLayoutConstraint *)wta_bottomToTopConstraintWithTopView:(UIView *)topView bottomView:(UIView *)bottomView separation:(CGFloat)separation;

+ (NSLayoutConstraint *)wta_trailingToLeadingConstraintWithTrailingView:(UIView *)trailingView leadingView:(UIView *)leadingView separation:(CGFloat)separation relation:(NSLayoutRelation)relation;
+ (NSLayoutConstraint *)wta_bottomToTopConstraintWithTopView:(UIView *)topView bottomView:(UIView *)bottomView separation:(CGFloat)separation relation:(NSLayoutRelation)relation;

///------------------------------
/// @name Centering Constraints
///------------------------------

+ (NSLayoutConstraint *)wta_horizontallyCenterConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;
+ (NSLayoutConstraint *)wta_verticallyCenterConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;

///------------------------
/// @name Size Constraints
///------------------------

+ (NSLayoutConstraint *)wta_heightConstraintWithView:(UIView *)view height:(CGFloat)height;
+ (NSLayoutConstraint *)wta_widthConstraintWithView:(UIView *)view width:(CGFloat)width;

+ (NSLayoutConstraint *)wta_heightConstraintWithView:(UIView *)view height:(CGFloat)height relation:(NSLayoutRelation)relation;
+ (NSLayoutConstraint *)wta_widthConstraintWithView:(UIView *)view width:(CGFloat)width relation:(NSLayoutRelation)relation;

@end
