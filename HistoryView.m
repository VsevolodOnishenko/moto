//
//  HistoryView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 13.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "HistoryView.h"

@interface HistoryView () <GMSMapViewDelegate> {
    
    GMSMapView *mapView;
    
    NSNumber *start_lat;
    NSNumber *start_lng;
    NSNumber *end_lat;
    NSNumber *end_lng;
    
    NSUInteger route;
}

@end

@implementation HistoryView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self getIndRoute];
    //[self loadData];
    
    [self getTrackData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"История";
}

- (void) getIndRoute {
    
   NSNumber *ind = [[NSUserDefaults standardUserDefaults] objectForKey:@"ind"];
   route = ind.unsignedIntegerValue;
}

- (void) loadData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"https://drive.google.com/uc?export=download&id=0BzEFC7r_La7PYUlSWFJZY1FMdzQ" parameters:nil progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         start_lat = [[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"start_latitude"] objectAtIndex:route];
         start_lng = [[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"start_longitude"] objectAtIndex:route];
         end_lat = [[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"end_latitude"] objectAtIndex:route];
         end_lng = [[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"end_longitude"] objectAtIndex:route];
         
         [self initMap];
         [self setStartEndPoints];
         [self setPolylineRoute];
         
         NSLog(@"success!");
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error: %@", error);
     }];
}

- (void) initMap {
    
    GMSCameraPosition *userLocation = [GMSCameraPosition cameraWithLatitude:start_lat.floatValue
                                                                  longitude:start_lng.floatValue
                                                                       zoom:13
                                       ];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, CGRectGetWidth([self.view bounds]), CGRectGetHeight([self.view bounds])) camera:userLocation];
    
    mapView.delegate = self;
    
    mapView.myLocationEnabled = YES;
    mapView.indoorEnabled = NO;
    mapView.accessibilityElementsHidden = NO;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
    NSError *error;
    
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    
    mapView.mapStyle = style;
    [self.view insertSubview:mapView atIndex:1];
}

- (void) setStartEndPoints {
    
    GMSMarker *markerStart = [[GMSMarker alloc] init];
    markerStart.position = CLLocationCoordinate2DMake(start_lat.floatValue, start_lng.floatValue);
    markerStart.appearAnimation = kGMSMarkerAnimationPop;
    markerStart.map = mapView;
    
    GMSMarker *markerEnd = [[GMSMarker alloc] init];
    markerEnd.position = CLLocationCoordinate2DMake(end_lat.floatValue, end_lng.floatValue);
    markerEnd.appearAnimation = kGMSMarkerAnimationPop;
    markerEnd.map = mapView;
}

- (void) setPolylineRoute {
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(start_lat.floatValue, start_lng.floatValue)];
    [path addCoordinate:CLLocationCoordinate2DMake(end_lat.floatValue, end_lng.floatValue)];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    
    polyline.map = mapView;
}

- (void) getTrackData {
    
}

@end
