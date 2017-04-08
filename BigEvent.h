//
//  BigEvent.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 20.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "EventViewInfoCell.h"
#import "EventViewHeaderCell.h"
#import "EventTitleCell.h"

#import "BigEventModel.h"

@interface BigEvent : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *BigEventTableView;

@end
