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
#import <UIView+WTANibLoading.h>

@interface ViewController ()

@end

@implementation ViewController
{
    int _minimumMagnitude;
    NSFetchedResultsController *_earthquakeResultsController;
    NSDateFormatter *_dateFormatter;
    UITapGestureRecognizer *_magnitudeTap;
    UITapGestureRecognizer *_timeTap;
}


-(void)viewWillAppear:(BOOL)animated
{
    _earthquakeResultsController = [self fetchedResultsController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getEarthquakes) forControlEvents:UIControlEventValueChanged];
    
    [self setFilterView:[FilterModalView wta_loadInstanceFromNib]];
    [self setTableHeaderView:[TableHeaderView wta_loadInstanceFromNib]];
    _magnitudeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [self.tableHeaderView.magnitudeLabel addGestureRecognizer:_magnitudeTap];
    _timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [self.tableHeaderView.timeLabel addGestureRecognizer:_timeTap];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MM/dd HH:mm:ss"];
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
                              [Epicenter fromAPIResults:feature inContext:context];
                          }
                      } error:&error];
                     
                     [self.refreshControl endRefreshing];
                     [self.tableView reloadData];
                 }
             }];

        }
    }];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (!_earthquakeResultsController) {
        NSFetchRequest *fetchRequest = [Epicenter fetchRequest];
        fetchRequest.sortDescriptors = @[];
        _earthquakeResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                           managedObjectContext:[[WTAData injected] mainContext]
                                                                             sectionNameKeyPath:nil
                                                                                      cacheName:nil];
        [_earthquakeResultsController performFetch:nil];
    }
    return _earthquakeResultsController;
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
    return [[[_earthquakeResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(void)headerTap:(id)sender
{
    //Magnitude label clicked
    if ([(UIGestureRecognizer*)sender isEqual:_magnitudeTap])
    {
        [_earthquakeResultsController.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"magnitude" ascending:YES]]];
    }
    //Time label clicked
    else if ([(UIGestureRecognizer*)sender isEqual:_timeTap])
    {
        [_earthquakeResultsController.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]]];
    }
    [_earthquakeResultsController performFetch:nil];
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableHeaderView;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [EpicenterCell wta_reuseableIdentifier];
    EpicenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Epicenter *toAdd = [_earthquakeResultsController objectAtIndexPath:indexPath];
    cell.magnitudeLabel.text = [NSString stringWithFormat:@"%d", [toAdd.magnitude intValue]];
    cell.latitudeLongitudeLabel.text = [NSString stringWithFormat:@"%.2f/%.2f", [toAdd.latitude floatValue], [toAdd.longitude floatValue]];
    
    //convert from milliseconds to seconds
    NSDate* time = [[NSDate alloc] initWithTimeIntervalSince1970:[toAdd.time doubleValue]/1000];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", [_dateFormatter stringFromDate:time]];
    
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

    NSError *error;
    NSPredicate *magnitudePredicate = [NSPredicate predicateWithFormat:@"magnitude >= %d", minimumMagnitude];
    
    [_earthquakeResultsController.fetchRequest setPredicate:magnitudePredicate];
    [_earthquakeResultsController performFetch:&error];
    if (error)
    {
        NSLog(@"Error fetching cached Earthquakes. %@", error);
    }
    
    [self.tableView reloadData];
}
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *controller = (MapViewController *)[segue destinationViewController];
    NSArray *allEpicenters;
    if ([[segue identifier] isEqualToString:@"showSingle"])
    {
        allEpicenters = [[NSArray alloc] initWithObjects:[[_earthquakeResultsController fetchedObjects] objectAtIndex:[[self.tableView indexPathForSelectedRow] row]], nil];
    }
    else if ([[segue identifier] isEqualToString:@"showAll"])
    {
        allEpicenters = [_earthquakeResultsController fetchedObjects];
    }
    
    controller.allEpicenters = allEpicenters;
}

@end
