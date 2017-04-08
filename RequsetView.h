//
//  RequsetView.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 04.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "OutcomeReqObj.h"
#import "IncomeReqObj.h"

#import "UserData.h"
#import "FDKeychain.h"

#import "InComeReqCell.h"
#import "OutComeReqCell.h"

#import "fabriqStyleView.h"

#import "RKDropdownAlert.h"

@interface RequsetView : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableViewRequest;

@end
