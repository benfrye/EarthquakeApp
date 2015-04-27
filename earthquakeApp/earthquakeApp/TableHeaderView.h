//
//  TableHeaderView.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/27/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLongitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
