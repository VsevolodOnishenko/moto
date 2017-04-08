//
//  TrackHistory.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 13.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "HistoryCell.h"

@interface TrackHistory : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableTrackHistory;

@end
