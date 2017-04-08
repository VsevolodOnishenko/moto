//
//  LostPassword.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 01.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "RKDropdownAlert.h"

@interface LostPassword : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield_email;

- (IBAction)OK:(id)sender;

@end
