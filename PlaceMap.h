//
//  PlaceMap.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 10.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "PlaceMapModel.h"

#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <GoogleMaps/GoogleMaps.h>

#import "EventTitleCell.h"
#import "EventViewInfoCell.h"
#import "ImagePlaceCell.h"
#import "PlaceSheduleCell.h"

#import <sys/sysctl.h>

@interface PlaceMap : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *PlaceMapTableView;

@end
