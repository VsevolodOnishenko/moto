//
//  MotoMap.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"

#import "XXXRoundMenuButton.h"

#import <CoreLocation/CoreLocation.h>

#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <GoogleMaps/GoogleMaps.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "POIItem.h"
#import "User_object.h"
#import "Event_object.h"

#import <QuartzCore/QuartzCore.h>

#import "fabriqStyleView.h"
#import "fabriqAnimation.h"

#import "FDKeychain.h"

#import "EventTitleCell.h"

#import "UserObjJSON.h"
#import "PlaceObjectJSON.h"
#import "EventObjectJSON.h"

@interface MotoMap : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)sideBarButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewTitle;

- (void) ButtonClicked;
- (void) ButtonUnClicked;

@property (weak, nonatomic) IBOutlet UIView *launchPlaceView;
@property (weak, nonatomic) IBOutlet UILabel *launchPlaceView_title;

@property (weak, nonatomic) IBOutlet UIView *addingSmallEventView;
@property (weak, nonatomic) IBOutlet UILabel *addingSmallEvent_lbl;
@property (weak, nonatomic) IBOutlet UIButton *addingSmallEvent_btn;

- (IBAction)addingSmallEvent:(id)sender;
- (IBAction)rightBarButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

