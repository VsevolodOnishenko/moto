//
//  SettingApp.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

#import "SettingAppAppCell.h"
#import "SettingAppSupCell.h"

@interface SettingApp : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *SettingAppTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
