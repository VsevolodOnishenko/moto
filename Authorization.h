//
//  Authorization.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "RKDropdownAlert.h"

#import "FBSDKLoginKit/FBSDKLoginKit.h"
#import "FBSDKCoreKit/FBSDKCoreKit.h"
#import "Bolts.h"
#import "VKSdk.h"

#import "AFNetworking.h"
#import "FDKeychain.h"

@interface Authorization : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image_background;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIView *viewAnimLog;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmend;
@property (weak, nonatomic) IBOutlet UIView *viewLoader;

@property (weak, nonatomic) IBOutlet UIView *containerLogIn;
@property (weak, nonatomic) IBOutlet UIView *containerLogOn;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) UIWindow *window;

- (IBAction)registration:(id)sender;
- (IBAction)logIn:(id)sender;
- (IBAction)logInFacebook:(id)sender;
- (IBAction)logInVK:(id)sender;
- (IBAction)segmentDidAction:(id)sender;
- (IBAction)usernotifications:(id)sender;

@end
