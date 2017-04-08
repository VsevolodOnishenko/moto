//
//  SmallEvent.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 10.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "SmallEventCell.h"
#import "SmallEventButton.h"

#import "FDKeychain.h"
#import "UserData.h"

#import "RKDropdownAlert.h"

@interface SmallEvent : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *SmallEventTableView;

@end
