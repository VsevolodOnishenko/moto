//
//  AuthoriztaionViaServer.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 16.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RKDropdownAlert.h"
#import "AFNetworking.h"
#import "FDKeychain.h"

@interface AuthoriztaionViaServer : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield_email;
@property (weak, nonatomic) IBOutlet UITextField *textfield_password;

- (IBAction)LogIn:(id)sender;
- (IBAction)lostPassword:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *subActiveIndicator;

@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *SubView;

- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textfiled_remindpassword;
- (IBAction)remindPassword:(id)sender;

@end
