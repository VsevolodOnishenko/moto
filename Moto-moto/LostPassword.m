//
//  LostPassword.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 01.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "LostPassword.h"

@interface LostPassword () <UITextFieldDelegate>

@end

@implementation LostPassword

@synthesize textfield_email;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAttributedString *loginPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.textfield_email.attributedPlaceholder = loginPlaceholder;
    self.textfield_email.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textfield_email isFirstResponder];
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [textfield_email resignFirstResponder];
}

- (IBAction)OK:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *email = textfield_email.text;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            email, @"email",
            nil];
    
    [manager POST:@"http://motomoto.2-wm.ru/apiv1/authenticate/remember-password" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if ([[responseObject valueForKey:@"status"] isEqualToString:@"success"]) {
             [RKDropdownAlert title:@"Успешно" message:@"Проверьте свой email" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:10];
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error: %@", error);
     }];
}

@end
