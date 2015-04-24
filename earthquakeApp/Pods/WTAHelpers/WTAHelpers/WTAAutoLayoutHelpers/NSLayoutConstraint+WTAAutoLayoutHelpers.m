//
//  NSLayoutConstraint+WTAAutoLayoutHelpers.m
//  WTAHelpers
//
//  Created by Trung Tran on 2/25/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import "NSLayoutConstraint+WTAAutoLayoutHelpers.h"

@implementation NSLayoutConstraint (WTAAutoLayoutHelpers)

#pragma mark - Edge Creating Constraints

+ (NSLayoutConstraint *)wta_leadingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset
{
    return [self wta_leadingConstraintWithView:withView toView:toView offset:offset relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_leadingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:relation
                                                                     toItem:toView
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:offset];
    return constraint;
}

+ (NSLayoutConstraint *)wta_trailingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset
{
    return [self wta_trailingConstraintWithView:withView toView:toView offset:offset relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_trailingConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:relation
                                                                     toItem:toView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:-offset];
    return constraint;
}

+ (NSLayoutConstraint *)wta_topConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset
{
    return [self wta_topConstraintWithView:withView toView:toView offset:offset relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_topConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:toView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:offset];
    return constraint;
}

+ (NSLayoutConstraint *)wta_bottomConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset
{
    return [self wta_bottomConstraintWithView:withView toView:toView offset:offset relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_bottomConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:relation
                                                                     toItem:toView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:-offset];
    return constraint;
}

#pragma mark - Side-by-Side separation Constraints

+ (NSLayoutConstraint *)wta_trailingToLeadingConstraintWithTrailingView:(UIView *)trailingView leadingView:(UIView *)leadingView separation:(CGFloat)separation
{
    return [self wta_trailingToLeadingConstraintWithTrailingView:trailingView leadingView:leadingView separation:separation relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_trailingToLeadingConstraintWithTrailingView:(UIView *)trailingView leadingView:(UIView *)leadingView separation:(CGFloat)separation relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:trailingView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:relation
                                                                     toItem:leadingView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:separation];
    return constraint;
}

+ (NSLayoutConstraint *)wta_bottomToTopConstraintWithTopView:(UIView *)topView bottomView:(UIView *)bottomView separation:(CGFloat)separation
{
    return [self wta_bottomToTopConstraintWithTopView:topView bottomView:bottomView separation:separation relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_bottomToTopConstraintWithTopView:(UIView *)topView bottomView:(UIView *)bottomView separation:(CGFloat)separation relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:bottomView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:relation
                                                                     toItem:topView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:separation];
    return constraint;
}

#pragma mark - Centering Constraints

+ (NSLayoutConstraint *)wta_horizontallyCenterConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:toView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:offset];
    return constraint;
}

+ (NSLayoutConstraint *)wta_verticallyCenterConstraintWithView:(UIView *)withView toView:(UIView *)toView offset:(CGFloat)offset;
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:toView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                   constant:offset];
    return constraint;
}

#pragma mark - Size Constraints


+ (NSLayoutConstraint *)wta_heightConstraintWithView:(UIView *)view height:(CGFloat)height
{
    return [self wta_heightConstraintWithView:view height:height relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_heightConstraintWithView:(UIView *)view height:(CGFloat)height relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:relation
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:height];
    return constraint;
}

+ (NSLayoutConstraint *)wta_widthConstraintWithView:(UIView *)view width:(CGFloat)width
{
    return [self wta_widthConstraintWithView:view width:width relation:NSLayoutRelationEqual];
}

+ (NSLayoutConstraint *)wta_widthConstraintWithView:(UIView *)view width:(CGFloat)width relation:(NSLayoutRelation)relation
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:relation
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:width];
    return constraint;
}

@end
