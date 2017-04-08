//
//  ProfileView.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 22.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"
#import "FDKeychain.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "SWRevealViewController.h"

#import "JTSImageInfo.h"
#import "JTSImageViewController.h"

#import "ProfileInfoCell.h"

#import "ListCell.h"
#import "ListImageCell.h"

@interface ProfileView : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *ProfileTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideBarButton;

- (IBAction)editProflile:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editProfileButton;


@end
