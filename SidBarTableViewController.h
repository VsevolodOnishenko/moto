//
//  SidBarTableViewController.h
//  DateApp
//
//  Created by Олег Малахов on 04.08.16.
//  Copyright © 2016 Владимир Малахов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCell.h"
#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
#import "CoreData/CoreData.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "FDKeychain.h"

@interface SidBarTableViewController : UITableViewController <UITableViewDelegate , UITableViewDataSource, RESideMenuDelegate>

@property (strong, nonatomic) IBOutlet UITableView *sidetableView;

@end
