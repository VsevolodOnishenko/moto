//
//  TrackMap.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "MapKit/MapKit.h"

#import "MathController.h"

#import "SWRevealViewController.h"

@interface TrackMap : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *lbl_distance;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *distanceView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_speed;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)strartTracking:(id)sender;
- (IBAction)testStop:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *testImage;

@end
