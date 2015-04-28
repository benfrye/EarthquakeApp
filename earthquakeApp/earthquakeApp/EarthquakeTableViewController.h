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
#import "TableHeaderView.h"

@interface EarthquakeTableViewController: UITableViewController  <FilterModalViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) FilterModalView *filterView;
@property (strong, nonatomic) TableHeaderView *tableHeaderView;

@end

