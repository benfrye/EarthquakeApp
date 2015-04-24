//
//  ViewController.h
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WTAData/WTAData.h>

#import "FilterModalView.h"

@interface ViewController : UITableViewController  <FilterModalViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (nonatomic, retain) IBOutlet FilterModalView *filterView;

@end

