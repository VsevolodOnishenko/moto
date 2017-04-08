//
//  Messages.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 20.12.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "SWRevealViewController.h"
#import "MessageCell.h"
#import "FDKeychain.h"

#import "UserData.h"
#import "Dialog.h"
#import "UserAtDialog.h"


@interface Messages : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableMessage;
@property (weak, nonatomic) IBOutlet UIView *isEmptyMessageList;

@end
