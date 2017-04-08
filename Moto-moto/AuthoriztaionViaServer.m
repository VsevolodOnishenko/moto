//
//  AuthoriztaionViaServer.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 16.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "AuthoriztaionViaServer.h"

@interface AuthoriztaionViaServer () <UITextFieldDelegate> {
    RKDropdownAlert *alert;
}

@end

@implementation AuthoriztaionViaServer

@synthesize textfield_email, textfield_password, activIndicator, MainView, SubView, subActiveIndicator, textfiled_remindpassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAlertViewObj];
    [self setTf_delegate];
    [self setAlphaUI];
    [self ApplyPlcaholderStyle];
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
    [textfield_password resignFirstResponder];
}

- (void) initAlertViewObj {
    alert = [[RKDropdownAlert alloc] init];
}

- (void) setAlphaUI {
    
    self.subActiveIndicator.alpha = 0;
    self.activIndicator.alpha = 0;
    self.SubView.alpha = 0;

}

- (void) setTf_delegate {
    
    self.textfield_email.delegate = self;
    self.textfield_password.delegate = self;
    self.textfiled_remindpassword.delegate = self;
}

- (void) ApplyPlcaholderStyle {
    
    NSAttributedString *loginPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
    self.textfield_email.attributedPlaceholder = loginPlaceholder;
    self.textfiled_remindpassword.attributedPlaceholder = loginPlaceholder;
    self.textfield_email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.textfiled_remindpassword.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"пароль" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
    self.textfield_password.attributedPlaceholder = passwordPlaceholder;
    self.textfield_password.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
}

- (IBAction)LogIn:(id)sender {
    
    if ([textfield_email.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
        
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Введите email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0]  textColor:[UIColor whiteColor] time:2];
        }

    } else if ([textfield_password.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Введите пароль" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
        
    } else {
        
        [self UserAuthorization];
    }
}

- (void) StartActivityIndicator {
    
    self.activIndicator.alpha = 1;
    [self.activIndicator startAnimating];
}

- (void) StopActivityIndicator {
    
    self.activIndicator.alpha = 0;
    [self.activIndicator stopAnimating];
}

- (void) StartSubActivityIndicator {
    
    self.subActiveIndicator.alpha = 1;
    [self.subActiveIndicator startAnimating];
}

- (void) StopSubActivityIndicator {
    
    self.subActiveIndicator.alpha = 0;
    [self.subActiveIndicator stopAnimating];
}

- (void) UserAuthorization {
    
    [self StartActivityIndicator];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            @"native", @"provider",
            textfield_email.text, @"email",
            textfield_password.text, @"password",
            
            nil];
    
    [manager POST:@"http://moto.2-wm.ru/apiv2/authorization.login" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if ([[responseObject valueForKey:@"errors"] valueForKey:@"provider_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"provider_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Не указан email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Проверьте email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"password_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Не указан пароль" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"password_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Проверьте введеный пароль" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"user_not_found"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Пользователь не найден" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else {
                  
                  NSError *error = nil;
                  [FDKeychain saveItem: [NSString stringWithFormat:@"%@", [[responseObject valueForKey:@"data"] valueForKey:@"token"]]
                                forKey: @"token"
                            forService: @"MotoMotoApp"
                                 error: &error];
                  
                  [FDKeychain saveItem: [[responseObject valueForKey:@"data"] valueForKey:@"id"]
                                forKey: @"id"
                            forService: @"MotoMotoApp"
                                 error: &error];
                  
                  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"isLogged"];
                
                  [self toController];
              }
              
               [self StopActivityIndicator];
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"%@", error);
    
              if (alert.isShowing == 0) {
             
                  [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
              }
         
              [self StopActivityIndicator];
     }];
}

- (void) toController {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

- (IBAction)lostPassword:(id)sender {
    
    self.SubView.alpha = 1;
    self.MainView.alpha = 0;
}

- (IBAction)backButton:(id)sender {
    [self toMainView];
}

- (void) toMainView {
    
    self.SubView.alpha = 0;
    self.MainView.alpha = 1;
}

- (IBAction)remindPassword:(id)sender {
    
    if ([textfiled_remindpassword.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Укажите email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }

    } else {
        
        [self StartSubActivityIndicator];
        [self remidPassword];
    }
}

- (void) remidPassword {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            textfiled_remindpassword.text, @"email",
            nil];
    
    [manager POST:@"http://moto.2-wm.ru/apiv2/authorization.resetPassword" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Не указан email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Проверьте email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"user_not_found"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Email не найден" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Успешно" message:@"Ссылка для восстановления пароля отправлена на ваш email" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
                  textfiled_remindpassword.text = @"";
                  
                  [self toMainView];
              }
              
              [self StopSubActivityIndicator];
          }
     
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
              if (alert.isShowing == 0) {
             
                  [alert title:@"" message:@"" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Ошибка" message:@"Ошибка восстановления пароля" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
              }
         
              [self StopSubActivityIndicator];
     }];
}

@end
