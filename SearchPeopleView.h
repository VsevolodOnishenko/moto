//
//  SearchPeopleView.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 29.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "ContactCell.h"

#import "ContactUser.h"

@interface SearchPeopleView : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
