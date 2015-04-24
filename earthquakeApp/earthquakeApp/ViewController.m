//
//  ViewController.m
//  earthquakeApp
//
//  Created by Ben Frye on 4/20/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"
#import "SearchEarthquakeParameters.h"
#import "Epicenter.h"
#import "EpicenterCell.h"
#import "WTAReusableIdentifier.h"

#import "NSObject+Injectable.h"
#import "APIService+Search.h"

#import <NSManagedObject+WTAData.h>
#import <UIView+WTAAutoLayoutHelpers.h>

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *_latestEarthquakes;
    int _minimumMagnitude;
    UITapGestureRecognizer *_magnitudeTap;
    UITapGestureRecognizer *_timeTap;
}


-(void)viewWillAppear:(BOOL)animated
{
    if ([_latestEarthquakes count] == 0) {
        WTAData *dataService = [WTAData injected];
        NSError *error;
        
        _latestEarthquakes = [[NSMutableArray alloc] initWithArray:[Epicenter fetchInContext:[dataService mainContext] error:&error]];
        if (error)
        {
            NSLog(@"Error fetching cached Earthquakes. %@", error);
        }
    }
    
    if ([_latestEarthquakes count] == 0) {
        _latestEarthquakes = [[NSMutableArray alloc] initWithCapacity:5];
        [self getEarthquakes];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getEarthquakes) forControlEvents:UIControlEventValueChanged];
    
    [[NSBundle mainBundle] loadNibNamed:@"FilterModal" owner:self options:nil];
    
    _magnitudeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    _timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getEarthquakes
{
    SearchEarthquakeParameters *defaultParameters = [SearchEarthquakeParameters initWithDefaults];
    [self getEarthquakes:defaultParameters];
}

-(void)getEarthquakes:(SearchEarthquakeParameters*) parameters
{
    WTAData *dataService = [WTAData injected];
    
    [[APIService injected] searchEarthquakes:parameters
                                  completion:^(NSError *error, SearchEarthquakeResults *result)
    {
        if (!error) {
            [_latestEarthquakes removeAllObjects];
            [dataService deleteAllDataWithCompletion:^(NSError *error)
             {
                 if (error)
                 {
                     NSLog(@"Error clearing context for new save: %@", error);
                 }
                 else
                 {
                     [dataService saveInBackgroundAndWait:^(NSManagedObjectContext *context)
                      {
                          for (EarthquakeFeatures *feature in result.features)
                          {
                              [_latestEarthquakes addObject:[Epicenter fromAPIResults:feature inContext:context]];
                          }
                      } error:&error];
                     
                     [self.refreshControl endRefreshing];
                     [self.tableView reloadData];
                 }
             }];

        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_latestEarthquakes count];
}

-(void)headerTap:(id)sender
{
    //Magnitude label clicked
    if ([(UIGestureRecognizer*)sender isEqual:_magnitudeTap])
    {
        [_latestEarthquakes sortUsingComparator:^NSComparisonResult(Epicenter *a, Epicenter *b)
         {
             return [a.magnitude compare:b.magnitude];
         }];
    }
    //Time label clicked
    else if ([(UIGestureRecognizer*)sender isEqual:_timeTap])
    {
        [_latestEarthquakes sortUsingComparator:^NSComparisonResult(Epicenter *a, Epicenter *b)
         {
             return [a.time compare:b.time];
         }];
    }
    
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    //Init magnitude label
    UILabel *magnitudeLabel = [UILabel wta_autolayoutView];
    magnitudeLabel.text = @"Mag";
    magnitudeLabel.userInteractionEnabled = YES;
    [magnitudeLabel addGestureRecognizer:_magnitudeTap];
    
    //Init latitude/longitude label
    UILabel *latitudeLongitudeLabel = [UILabel wta_autolayoutView];
    latitudeLongitudeLabel.text = @"Lat/Long";
    
    //Init time label
    UILabel *timeLabel = [UILabel wta_autolayoutView];
    timeLabel.text = @"Time";
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.userInteractionEnabled = YES;
    [timeLabel addGestureRecognizer:_timeTap];
    
    //Add labels to view
    [headerView addSubview:magnitudeLabel];
    [headerView addSubview:latitudeLongitudeLabel];
    [headerView addSubview:timeLabel];
    
    //Extend magnitudeLabel to make easier to click
    [magnitudeLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [headerView addConstraint:[magnitudeLabel wta_addTrailingConstraintToView:latitudeLongitudeLabel offset:0]];

    //Extend timeLabel to make easier to click
    [timeLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [headerView addConstraint:[timeLabel wta_addLeadingConstraintToView:latitudeLongitudeLabel offset:0]];
    
    //Off-Center latitude/longitude label
    [headerView addConstraint:[latitudeLongitudeLabel wta_addHorizontallyCenterConstraintToSuperviewOffset:-38.0]];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[magnitudeLabel]-(>=8@699)-[latitudeLongitudeLabel]-(>=8@699)-[timeLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(magnitudeLabel, latitudeLongitudeLabel, timeLabel)]];
    
    return headerView;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [EpicenterCell wta_reuseableIdentifier];
    EpicenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Epicenter *toAdd = [_latestEarthquakes objectAtIndex:indexPath.row];
    cell.magnitudeLabel.text = [NSString stringWithFormat:@"%d", [toAdd.magnitude intValue]];
    cell.latitudeLongitudeLabel.text = [NSString stringWithFormat:@"%.2f/%.2f", [toAdd.latitude floatValue], [toAdd.longitude floatValue]];
    
    //convert from milliseconds to seconds
    NSDate* time = [[NSDate alloc] initWithTimeIntervalSince1970:[toAdd.time doubleValue]/1000];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm:ss"];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:time]];
    
     return cell;
 }

 #pragma mark - Navigation

- (IBAction)filterButtonPressed:(id)sender {
    //Setup Touch Blocker View
    UIView *touchBlocker = [[UIView alloc] initWithFrame:self.view.frame];
    touchBlocker.backgroundColor = [UIColor blackColor];
    touchBlocker.alpha = 0.0;
    touchBlocker.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelFilterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popFilterView)];
    [touchBlocker addGestureRecognizer:cancelFilterTap];
    [self.navigationController.view addSubview:touchBlocker];

    //Setup Filter View
    self.filterView.delegate = self;
    self.filterView.touchBlocker = touchBlocker;
    self.filterView.minimumMagnitude = _minimumMagnitude;
    [self.filterView updateView];
    self.filterView.center = self.view.center;
    self.filterView.alpha = 0.0;
    
    //Animate bringing them to light
    [self.navigationController.view addSubview:self.filterView];
    [UIView animateWithDuration:0.2
                     animations:^{
                         touchBlocker.alpha = .2;
                         self.filterView.alpha = 1.0;
                     }
                     completion:nil];
}

-(void)popFilterView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.filterView.touchBlocker.alpha = 0.0;
                         self.filterView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.filterView.touchBlocker removeFromSuperview];
                         [self.filterView removeFromSuperview];
                     }];
}

- (void)finishingView:(int)minimumMagnitude
{
    [self popFilterView];
    
    _minimumMagnitude = minimumMagnitude;
    
    WTAData *dataService = [WTAData injected];
    NSError *error;
    
    NSPredicate *magnitudePredicate = [NSPredicate predicateWithFormat:@"magnitude >= %d", minimumMagnitude];
    
    [_latestEarthquakes removeAllObjects];
    [_latestEarthquakes addObjectsFromArray:[Epicenter fetchInContext:[dataService mainContext] predicate:magnitudePredicate error:&error]];
    if (error)
    {
        NSLog(@"Error fetching cached Earthquakes. %@", error);
    }
    [self.tableView reloadData];
}
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *controller = (MapViewController *)[segue destinationViewController];
    NSMutableArray *allEpicenters;
    if ([[segue identifier] isEqualToString:@"showSingle"])
    {
        allEpicenters = [[NSMutableArray alloc] initWithObjects:[_latestEarthquakes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]], nil];
    }
    else if ([[segue identifier] isEqualToString:@"showAll"])
    {
        allEpicenters = _latestEarthquakes;
    }
    
    controller.allEpicenters = allEpicenters;
}

@end
