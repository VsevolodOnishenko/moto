//
//  ContactView.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 20.12.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"
#import "ContactCell.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "FDKeychain.h"

#import "ContactUser.h"
#import "UserData.h"

#import "OutcomeReqObj.h"
#import "IncomeReqObj.h"

#import "InComeReqCell.h"

@interface ContactView : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewContact;
@property (weak, nonatomic) IBOutlet UIView *containerViewRequset;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;



@end
