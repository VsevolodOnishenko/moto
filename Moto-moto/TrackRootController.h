//
//  TrackRootController.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 12.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"

@interface TrackRootController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UIView *containerTrack;
@property (weak, nonatomic) IBOutlet UIView *containerTrackList;
@property (weak, nonatomic) IBOutlet UIView *containerTrackHistory;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

- (IBAction)segment:(id)sender;

@end
