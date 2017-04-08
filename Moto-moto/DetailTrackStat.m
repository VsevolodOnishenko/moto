//
//  DetailTrackStat.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 08.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "DetailTrackStat.h"

#import "Run.h"
#import "Location.h"
#import "TrackMap.h"
#import <MapKit/MapKit.h>
#import "MulticolorPolylineSegment.h"

@interface DetailTrackStat () <MKMapViewDelegate>
{
    MKCoordinateRegion region;
    NSMutableArray *points;
    UIImage *image;
    
    MKMapSnapshot *snapshot;
    
    MultiColorPolylineSegment *polyLine;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation DetailTrackStat

@synthesize lbl_time, lbl_dist, lbl_speed, lbl_date, mapDetail, imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocationManager];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setRun:(Run *)run {
    if (_run != run) {
        _run = run;
        [self configureView];
    }
}

- (void) initLocationManager {
    
    [_locationManager requestWhenInUseAuthorization];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_locationManager startUpdatingLocation];
}

- (MKCoordinateRegion)mapRegion
{
    points = [[NSMutableArray alloc] init];
    
    Location *initLoc = self.run.locations.firstObject;
    
    float minLat = initLoc.latitude.floatValue;
    float minLog = initLoc.langitude.floatValue;
    float maxLat = initLoc.latitude.floatValue;
    float maxLog = initLoc.langitude.floatValue;
    
    for (Location *loc in self.run.locations)
    {
        if (loc.latitude.floatValue < minLat)
        {
            minLat = loc.latitude.floatValue;
        }
        if (loc.latitude.floatValue > maxLat)
        {
            maxLat = loc.latitude.floatValue;
        }
        if (loc.langitude.floatValue < minLog)
        {
            minLog = loc.langitude.floatValue;
        }
        if (loc.langitude.floatValue > maxLog)
        {
            maxLog = loc.langitude.floatValue;
        }
        
        [points addObject:loc.latitude];
        [points addObject:loc.langitude];
    }
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLog + maxLog) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f;
    region.span.longitudeDelta = (maxLog - minLog) * 1.1f;
    
    return region;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MultiColorPolylineSegment class]]) {
        polyLine = (MultiColorPolylineSegment *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

- (MKPolyline *)polyLine
{
    CLLocationCoordinate2D coords[self.run.locations.count];
    
    for (int i = 0; i < self.run.locations.count; i++)
    {
        Location *location = [self.run.locations objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.langitude.doubleValue);
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:self.run.locations.count];
}

- (void)loadMap {
    
    if (self.run.locations.count > 0) {
        self.mapDetail.delegate = self;
        self.mapDetail.hidden = NO;
        [self.mapDetail setRegion:[self mapRegion]];
        NSArray *colorSegmentArray = [MathController colorSegmentsForLocations:self.run.locations.array];
        [self.mapDetail addOverlays:colorSegmentArray];
    } else {
        self.mapDetail.hidden = YES;
    }
}

- (void)configureView {
    self.lbl_dist.text = [MathController stringifyDistance:self.run.distance.floatValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.lbl_date.text = [dateFormatter stringFromDate:self.run.timestamp];
    
    self.lbl_time.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.run.duration.intValue usingLongFormat:YES]];
    
    self.lbl_speed.text = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    
    [self loadMap];
    [self initDurationImage];
    //[self img];
}

- (void) initDurationImage {
    
    [self.mapDetail setRegion:region animated:YES];
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapDetail.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = CGSizeMake(1000, 1000);
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot_0, NSError *error) {
        snapshot = snapshot_0;
        image = snapshot_0.image;
        imageView.image = image;
    }];
}

- (void) img {
    
    UIGraphicsBeginImageContext(snapshot.image.size);
    CGRect rectForImage = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    
    // Draw map
    [imageView.image drawInRect:rectForImage];
    
    // Get points in the snapshot from the snapshot
    int lastPointIndex = 0;
    int firstPointIndex = 0;
    BOOL isfirstPoint = NO;
    
    NSMutableArray *pointsToDraw = [NSMutableArray array];
    for (int i = 0; i < polyLine.pointCount; i++){
        MKMapPoint point = polyLine.points[i];
        CLLocationCoordinate2D pointCoord = MKCoordinateForMapPoint(point);
        CGPoint pointInSnapshot = [snapshot pointForCoordinate:pointCoord];
        if (CGRectContainsPoint(rectForImage, pointInSnapshot)) {
            [pointsToDraw addObject:[NSValue valueWithCGPoint:pointInSnapshot]];
            lastPointIndex = i;
            if (i == 0)
                firstPointIndex = YES;
            if (!isfirstPoint) {
                isfirstPoint = YES;
                firstPointIndex = i;
            }
        }
    }
    
    // Adding the first point on the outside too so we have a nice path
    if (lastPointIndex + 1 <= polyLine.pointCount) {
        MKMapPoint point = polyLine.points[lastPointIndex+1];
        CLLocationCoordinate2D pointCoord = MKCoordinateForMapPoint(point);
        CGPoint pointInSnapshot = [snapshot pointForCoordinate:pointCoord];
        [pointsToDraw addObject:[NSValue valueWithCGPoint:pointInSnapshot]];
    }
    // Adding the point before the first point in the map as well (if needed) to have nice path
    
    if (firstPointIndex != 0) {
        MKMapPoint point = polyLine.points[firstPointIndex-1];
        CLLocationCoordinate2D pointCoord = MKCoordinateForMapPoint(point);
        CGPoint pointInSnapshot = [snapshot pointForCoordinate:pointCoord];
        [pointsToDraw insertObject:[NSValue valueWithCGPoint:pointInSnapshot] atIndex:0];
    }
    
    // Draw that points
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    
    for (NSValue *point in points){
        CGPoint pointToDraw = [point CGPointValue];
        if ([pointsToDraw indexOfObject:point] == 0){
            CGContextMoveToPoint(context, pointToDraw.x, pointToDraw.y);
        } else {
            CGContextAddLineToPoint(context, pointToDraw.x, pointToDraw.y);
        }
    }
    CGContextStrokePath(context);
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.image = resultingImage;
}

@end
