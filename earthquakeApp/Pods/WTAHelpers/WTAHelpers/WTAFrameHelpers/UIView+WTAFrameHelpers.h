//
//  UIView+WTAFrameHelpers.h
//  WTALayoutHelpers
//
//  Created by Trung Tran on 2/18/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 WTAFrameHelpers provides convenience methods for view placement and frame information.
 */
@interface UIView (WTAFrameHelpers)

///---------------------------------
/// @name Convenience Frame Getters
///---------------------------------

/**
 @return The frame size of the view.
 */
- (CGSize)wta_frameSize;

/**
 @return The frame width the view.
 */
- (CGFloat)wta_frameSizeWidth;

/**
 @return The frame height of the view.
 */
- (CGFloat)wta_frameSizeHeight;

/**
 @return The frame origin of the view.
 */
- (CGPoint)wta_frameOrigin;

/**
 @return The frame origin x of the view.
 */
- (CGFloat)wta_frameOriginX;

/**
 @return The frame origin y of the view.
 */
- (CGFloat)wta_frameOriginY;

///---------------------------------
/// @name Convenience Frame Setters
///---------------------------------

/**
 Sets the frame size of the view.
 
 @param size The new size of the view.
 */
- (void)wta_setFrameSize:(CGSize)size;

/**
 Sets the height of the view.
 
 @param height The new height of the view.
 */
- (void)wta_setFrameSizeHeight:(CGFloat)height;

/**
 Sets the width of the view.
 
 @param width The new width of the view.
 */
- (void)wta_setFrameSizeWidth:(CGFloat)width;

/**
 Sets the origin of the view.
 
 @param origin The new origin of the view.
 */
- (void)wta_setFrameOrigin:(CGPoint)origin;

/**
 Sets the x of the view.
 
 @param origin The new x of the view.
 */
- (void)wta_setFrameOriginX:(CGFloat)x;

/**
 Sets the y of the view.
 
 @param origin The new y of the view.
 */
- (void)wta_setFrameOriginY:(CGFloat)y;

///--------------------------------------------------
/// @name Convenience Objective-C CGRectGet* Methods
///--------------------------------------------------

/**
 Replaces the need to use CGRectGetMinX(frame) on the view's frame.
 
 @return The frame minimum x of the view.
 */
- (CGFloat)wta_frameMinX;

/**
 Replaces the need to use CGRectGetMinY(frame) on the view's frame.
 
 @return The frame minimum y of the view.
 */
- (CGFloat)wta_frameMinY;

/**
 Replaces the need to use CGRectGetMidX(frame) on the view's frame.
 
 @return The frame minimum y of the view.
 */
- (CGFloat)wta_frameMidX;

/**
 Replaces the need to use CGRectGetMidY(frame) on the view's frame.
 
 @return The frame minimum y of the view.
 */
- (CGFloat)wta_frameMidY;

/**
 Replaces the need to use CGRectGetMaxX(frame) on the view's frame.
 
 @return The frame maximum x of the view.
 */
- (CGFloat)wta_frameMaxX;

/**
 Replaces the need to use CGRectGetMaxY(frame) on the view's frame.
 
 @return The frame maximum y of the view.
 */
- (CGFloat)wta_frameMaxY;

///-----------------------------------------------
/// @name Edge Alignment Methods For a Given View
///-----------------------------------------------

/**
 Aligns the current view to the top of the supplied view with an offset from the edge. In most cases the view parameter will be the superview. Use `wta_topAlignInSuperviewOffset:` if the view has already been added a subview.
 
 @param view The view that the current view should be aligned in relation to.
 @param offset The padding from the top edge.
 */
- (void)wta_topAlignInView:(UIView *)view;
- (void)wta_topAlignInView:(UIView *)view offset:(CGFloat)offset;

/**
 Aligns the current view to the left of the supplied view with an offset from the edge. In most cases the view parameter will be the superview. Use `wta_leftAlignInSuperviewOffset:` if the view has already been added a subview.
 
 @param view The view that the current view should be aligned in relation to.
 @param offset The padding from the left edge.
 */
- (void)wta_leftAlignInView:(UIView *)view;
- (void)wta_leftAlignInView:(UIView *)view offset:(CGFloat)offset;

/**
 Aligns the current view to the bottom of the supplied view with an offset from the edge. In most cases the view parameter will be the superview. Use `wta_bottomAlignInSuperviewOffset:` if the view has already been added a subview.
 
 @param view The view that the current view should be aligned in relation to.
 @param offset The padding from the bottom edge.
 */
- (void)wta_bottomAlignInView:(UIView *)view;
- (void)wta_bottomAlignInView:(UIView *)view offset:(CGFloat)offset;

/**
 Aligns the current view to the right of the supplied view with an offset from the edge. In most cases the view parameter will be the superview. Use `wta_rightAlignInSuperviewOffset:` if the view has already been added a subview.
 
 @param view The view that the current view should be aligned in relation to.
 @param offset The padding from the right edge.
 */
- (void)wta_rightAlignInView:(UIView *)view;
- (void)wta_rightAlignInView:(UIView *)view offset:(CGFloat)offset;

///---------------------------------------------
/// @name Edge Alignment Methods For Superview
///---------------------------------------------

/**
 Aligns the current view to the top its superview with an offset from the edge.
 
 @param offset The padding from the top edge;
 */
- (void)wta_topAlignInSuperview;
- (void)wta_topAlignInSuperviewOffset:(CGFloat)offset;

/**
 Aligns the current view to the left its superview with an offset from the edge.
 
 @param offset The padding from the left edge;
 */
- (void)wta_leftAlignInSuperview;
- (void)wta_leftAlignInSuperviewOffset:(CGFloat)offset;

/**
 Aligns the current view to the bottom its superview with an offset from the edge.
 
 @param offset The padding from the bottom edge;
 */
- (void)wta_bottomAlignInSuperview;
- (void)wta_bottomAlignInSuperviewOffset:(CGFloat)offset;

/**
 Aligns the current view to the right its superview with an offset from the edge.
 
 @param offset The padding from the right edge;
 */
- (void)wta_rightAlignInSuperview;
- (void)wta_rightAlignInSuperviewOffset:(CGFloat)offset;

///-----------------------------------
/// @name Centering Methods in a View
///-----------------------------------

/**
 Centers the view horizontally and vertically in a provided view. In most cases the provided view will become the current view's superview.
 
 @param view The view that the current view should be centered in relation to.
 @param offset The x and y offset from the center.
 */
- (void)wta_centerAlignInView:(UIView *)view;
- (void)wta_centerAlignInView:(UIView *)view offset:(CGPoint)offset;

/**
 Centers the view vertically in a provided view. In most cases the provided view will become the current view's superview.
 
 @param view The view that the current view should be centered in relation to.
 @param offset The y offset from the center.
 */
- (void)wta_centerAlignVerticallyInView:(UIView *)view;
- (void)wta_centerAlignVerticallyInView:(UIView *)view offset:(CGFloat)offset;

/**
 Centers the view horizontally in a provided view. In most cases the provided view will become the current view's superview.
 
 @param view The view that the current view should be centered in relation to.
 @param offset The x offset from the center.
 */
- (void)wta_centerAlignHorizontallyInView:(UIView *)view;
- (void)wta_centerAlignHorizontallyInView:(UIView *)view offset:(CGFloat)offset;

///-------------------------------------------
/// @name Centering Methods in its Superview
///-------------------------------------------

/**
 Centers the view horizontally and vertically in its superview.
 @param offset The x and y offset from the center.
 */
- (void)wta_centerAlignInSuperview;
- (void)wta_centerAlignInSuperviewOffset:(CGPoint)offset;

/**
 Centers the view vertically in its superview.
 @param offset The y offset from the center.
 */
- (void)wta_centerAlignVerticallyInSuperview;
- (void)wta_centerAlignVerticallyInSuperviewOffset:(CGFloat)offset;

/**
 Centers the view horizontally in its superview.
 @param offset The x offset from the center.
 */
- (void)wta_centerAlignHorizontallyInSuperview;
- (void)wta_centerAlignHorizontallyInSuperviewOffset:(CGFloat)offset;

///-------------------------------------------
/// @name Placing Views Next to Sibling Views
///-------------------------------------------

/**
 Places current current view to the right of a view.
 
 @param view to be placed beside.
 @param offset from the view.
 */
- (void)wta_setFrameOriginXRightOfView:(UIView *)view;
- (void)wta_setFrameOriginXRightOfView:(UIView *)view offset:(CGFloat)offset;

/**
 Places current current view to the left of a view.
 
 @param view to be placed beside.
 @param offset from the view.
 */
- (void)wta_setFrameOriginXLeftOfView:(UIView *)view;
- (void)wta_setFrameOriginXLeftOfView:(UIView *)view offset:(CGFloat)offset;

/**
 Places current current view to the below of a view.
 
 @param view to be placed beside.
 @param offset from the view.
 */
- (void)wta_setFrameOriginYBelowView:(UIView *)view;
- (void)wta_setFrameOriginYBelowView:(UIView *)view offset:(CGFloat)offset;

/**
 Places current current view to the above of a view.
 
 @param view to be placed beside.
 @param offset from the view.
 */
- (void)wta_setFrameOriginYAboveView:(UIView *)view;
- (void)wta_setFrameOriginYAboveView:(UIView *)view offset:(CGFloat)offset;

@end
