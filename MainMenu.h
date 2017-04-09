//
//  MainMenu.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 31.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "LentaJSONObject.h"
#import "NotificationModel.h"

#import "NotificationCell.h"
#import "LentaCell.h"
#import "UserData.h"
#import "FDKeychain.h"

@interface MainMenu : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
