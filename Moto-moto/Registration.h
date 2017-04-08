//
//  Registration.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 16.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RKDropdownAlert.h"
#import "AFNetworking.h"
#import "RKDropdownAlert.h"
#import "FDKeychain.h"

@interface Registration : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield_name;
@property (weak, nonatomic) IBOutlet UITextField *textfield_email;
@property (weak, nonatomic) IBOutlet UITextField *textfield_password;
@property (weak, nonatomic) IBOutlet UITextField *textfield_confirmpassword;
@property (weak, nonatomic) IBOutlet UITextField *textfield_activAccount;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeIndicator_subView;

- (IBAction)registration:(id)sender;
- (IBAction)usernotification:(id)sender;

- (IBAction)cancel_activeAccount:(id)sender;
- (IBAction)activAccount_action:(id)sender;


@end
