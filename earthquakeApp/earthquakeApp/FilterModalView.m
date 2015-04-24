//
//  FilterModalView.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/23/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "FilterModalView.h"

@implementation FilterModalView

-(void)updateView
{
    self.magnitudeSlider.value = self.minimumMagnitude;
    self.magnitudeLabel.text = [NSString stringWithFormat:@"%d", self.minimumMagnitude];
}

- (IBAction)filterButtonPressed:(id)sender {
    [self.delegate finishingView:self.minimumMagnitude];
}

- (IBAction)magnitudeSliderChanged:(id)sender {
    self.minimumMagnitude = (int)self.magnitudeSlider.value;
    [self.magnitudeLabel setText:[NSString stringWithFormat:@"%d", self.minimumMagnitude]];
}
@end
