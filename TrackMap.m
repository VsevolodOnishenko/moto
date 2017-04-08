//
//  TrackMap.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "TrackMap.h"

#import "Run.h"
#import "Location.h"
#import <MapKit/MapKit.h>

@class Run;

static NSString * const detailSegueName = @"DetailView";

@interface TrackMap () <UITabBarControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
    UIViewController *TrackDuration;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Run *run;

@property int seconds;
@property float distance;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TrackMap

@synthesize lbl_time, lbl_distance, timeView, distanceView, lbl_speed, bottomView, mapView, testImage;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocationManager];
    [self initMap];
    
    [self hideUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initMap {
    
    mapView.delegate = self;
    [mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    mapView.tintColor = [UIColor blueColor];
}

- (void) initLocationManager {
    
    [_locationManager requestWhenInUseAuthorization];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_locationManager startUpdatingLocation];
}

- (void) hideUI {
    
    //btn_stop.hidden = YES;
    lbl_speed.hidden = YES;
    lbl_time.hidden = YES;
    lbl_distance.hidden = YES;
    timeView.hidden = YES;
    distanceView.hidden = YES;
}

- (void)eachSecond {
    
    _seconds++;
    self.timeView.text = [NSString stringWithFormat:@"%@",  [MathController stringifySecondCount:_seconds usingLongFormat:NO]];
    self.distanceView.text = [NSString stringWithFormat:@"%@", [MathController stringifyDistance:_distance]];
    self.lbl_speed.text = [NSString stringWithFormat:@"%@",  [MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
}

- (void)startLocationUpdates {
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    self.locationManager.distanceFilter = 10;
    
    [self.locationManager startUpdatingLocation];
}

- (IBAction)strartTracking:(id)sender {
    lbl_speed.hidden = NO;
    lbl_time.hidden = NO;
    lbl_distance.hidden = NO;
    timeView.hidden = NO;
    distanceView.hidden = NO;
    
    _seconds = 0;
    _distance = 0;
    self.locations = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                selector:@selector(eachSecond) userInfo:nil repeats:YES];
    [self startLocationUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        [[segue destinationViewController] setRun:self.run];
}

- (IBAction)testStop:(id)sender {
    [self saveRun];
    [self performSegueWithIdentifier:detailSegueName sender:nil];
    [self setRun:self.run];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *newLocation in locations)
    {
        NSDate *eventDate = newLocation.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20)
        {
            if (self.locations.count > 0)
            {
                self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
        
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                
                [self.mapView setRegion:region animated:YES];
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locations addObject:newLocation];
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveRun
{
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run"
                                                inManagedObjectContext:self.managedObjectContext];
    
    newRun.distance = [NSNumber numberWithFloat:self.distance];
    newRun.duration = [NSNumber numberWithInt:self.seconds];
    newRun.timestamp = [NSDate date];
    
    NSMutableArray *locationArray = [NSMutableArray array];
    for (CLLocation *location in self.locations)
    {
        Location *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                              inManagedObjectContext:self.managedObjectContext];
        
        newLocation.langitude = [NSNumber numberWithFloat:location.coordinate.longitude];
        newLocation.latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
        newLocation.timstamp = location.timestamp;
        
        [locationArray addObject:newLocation];
    }
    
    newRun.locations = [NSOrderedSet orderedSetWithArray:locationArray];
    self.run = newRun;
    NSLog(@"%@", newRun);
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresloved error %@ %@", error, [error userInfo]);
        abort();
    }
}

@end
