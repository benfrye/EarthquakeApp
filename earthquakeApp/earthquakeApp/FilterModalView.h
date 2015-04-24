//
//  FilterModalView.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/23/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FilterModalView;

@protocol FilterModalViewDelegate <NSObject>
- (void)finishingView:(int)minimumMagnitude;
@end

@interface FilterModalView : UIView

@property (weak, nonatomic) id <FilterModalViewDelegate> delegate;
@property (weak, nonatomic) UIView *touchBlocker;
@property (weak, nonatomic) IBOutlet UISlider *magnitudeSlider;
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;

@property int minimumMagnitude;

- (IBAction)filterButtonPressed:(id)sender;
- (IBAction)magnitudeSliderChanged:(id)sender;
- (void)updateView;

@end
