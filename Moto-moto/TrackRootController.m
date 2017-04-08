//
//  TrackRootController.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 12.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "TrackRootController.h"

@interface TrackRootController ()

@end

@implementation TrackRootController

@synthesize segment, sideBarButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRevealMenu];
    [self initSegmentMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Трек";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initRevealMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
}

- (void) initSegmentMenu {
    
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor clearColor];
    segment.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5]} forState:UIControlStateNormal];
}

- (IBAction)segment:(id)sender {
    
    if (segment.selectedSegmentIndex == 0) {
        
        self.containerTrack.alpha = 1;
        self.containerTrackList.alpha = 0;
        self.containerTrackHistory.alpha = 0;
    } else if (segment.selectedSegmentIndex == 1) {
        
        self.containerTrack.alpha = 0;
        self.containerTrackList.alpha = 0;
        self.containerTrackHistory.alpha = 1;
    } else if (segment.selectedSegmentIndex == 2) {
        
        self.containerTrack.alpha = 0;
        self.containerTrackList.alpha = 1;
        self.containerTrackHistory.alpha = 0;
    }
}

@end
