//
//  SettingProfile.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingProfileCell.h"
#import "SettingYearCell.h"

#import "User.h"

#import "FDKeychain.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "RKDropdownAlert.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface SettingProfile : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *SettingProfileTableView;

- (IBAction)editProfile:(id)sender;

@end
