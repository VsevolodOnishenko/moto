//
//  DetailTrackStat.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 08.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MathController.h"
#import "TrackMap.h"

#import <CoreLocation/CoreLocation.h>
#import "MapKit/MapKit.h"

@class Run;

@interface DetailTrackStat : UIViewController

@property (strong, nonatomic) Run *run;

@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dist;
@property (weak, nonatomic) IBOutlet UILabel *lbl_speed;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;

@property (weak, nonatomic) IBOutlet MKMapView *mapDetail;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
