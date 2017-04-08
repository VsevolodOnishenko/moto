//
//  Registration.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 16.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "Registration.h"

@interface Registration () <UITextFieldDelegate> {
    RKDropdownAlert *alert;
    NSString *ID;
}

@end

@implementation Registration

@synthesize textfield_name, textfield_email, textfield_password, textfield_confirmpassword, textfield_activAccount, mainView, subView, activeIndicator;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTextFieldDelegte];
    [self ApplePlaceHolderStyle];
    [self AlphaActivityIndicator];
    [self initAlertViewObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initAlertViewObj {
    alert = [[RKDropdownAlert alloc] init];
}

- (void) initTextFieldDelegte {
    
    self.textfield_name.delegate = self;
    self.textfield_email.delegate = self;
    self.textfield_password.delegate = self;
    self.textfield_confirmpassword.delegate = self;
}

- (void) AlphaActivityIndicator {
    
    self.activeIndicator.alpha = 0;
    self.activeIndicator_subView.alpha = 0;
}

- (void) ApplePlaceHolderStyle {
    
    NSAttributedString *namePlaceholder = [[NSAttributedString alloc] initWithString:@"имя" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
    self.textfield_name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.textfield_name.attributedPlaceholder = namePlaceholder;
    
    NSAttributedString *emailPlaceholder = [[NSAttributedString alloc] initWithString:@"example@email.ru" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
    self.textfield_email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.textfield_email.attributedPlaceholder = emailPlaceholder;
    
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"пароль" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5]}];
    self.textfield_password.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.textfield_password.attributedPlaceholder = passwordPlaceholder;
    
    NSAttributedString *confirmpasswordPlaceholder = [[NSAttributedString alloc] initWithString:@"повторите пароль" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
    self.textfield_confirmpassword.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.textfield_confirmpassword.attributedPlaceholder = confirmpasswordPlaceholder;
    
    NSAttributedString *activeAccountPlaceholder = [[NSAttributedString alloc] initWithString:@"код подтверждения" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
    self.textfield_activAccount.textAlignment = NSTextAlignmentCenter;
    self.textfield_activAccount.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.textfield_activAccount.attributedPlaceholder = activeAccountPlaceholder;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [textfield_name resignFirstResponder];
    [textfield_email resignFirstResponder];
    [textfield_password resignFirstResponder];
    [textfield_confirmpassword resignFirstResponder];
}

- (IBAction)registration:(id)sender {
    
    if ([textfield_name.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Введите имя" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
        
    } else if ([textfield_email.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Введите email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
        
    } else if ([textfield_password.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Введите пароль" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
        
    } else if ([textfield_confirmpassword.text isEqualToString:@""]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Введите подтверждение пароля" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
        
    } else if (![textfield_password.text isEqualToString:textfield_confirmpassword.text]) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Пароли не совпадают" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
    
    } else {
        
        [self creatAccount];
    }
}

- (void) creatAccount {
    
    [self StartActivityIndicator];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
        textfield_confirmpassword.text, @"password",
        textfield_email.text, @"email",
        textfield_name.text, @"first_name",
            
            nil];
    
    [manager POST:@"http://moto.2-wm.ru/apiv2/authorization.register" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Пустое имя пользователя" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Недопустимые символы в имени" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_short"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      NSString *messageError = [NSString stringWithFormat:@"Минимальная длина имени состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_short"] valueForKey:@"min_length"]];
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_long"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      NSString *messageError = [NSString stringWithFormat:@"Максимальная длина имени состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_long"] valueForKey:@"max_length"]];
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Данный email не существует" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Отсутствует email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Проверьте корректность указанного email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"password_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Пароль отсутствует" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"password_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Пароль содержит пробелы" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"password_too_short"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      NSString *messageError = [NSString stringWithFormat:@"Минимальная длина пароля состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"password_too_short"] valueForKey:@"min_length"]];
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"password_too_long"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      NSString *messageError = [NSString stringWithFormat:@"Максимальная длина пароля состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"password_too_long"] valueForKey:@"max_length"]];
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"user_already_registered"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Пользователь уже существует" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              } else {
                  
                  [RKDropdownAlert title:@"Успешно" message:@"Вы зарегистрировались" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:5];
                  
                  ID = [[responseObject valueForKey:@"data"] valueForKey:@"registration_id"];
                  
                  [self activeAccount_UI];
                  [self StopActivityIndicator];
              }
              
              [self StopActivityIndicator];
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              if (alert.isShowing == 0) {
                  
                  [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Ошибка" message:@"Ошибка регистрации" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
              }
            
         [self StopActivityIndicator];
     }];
}

- (void) StartActivityIndicator {
    
    self.activeIndicator.alpha = 1;
    [self.activeIndicator startAnimating];
}

- (void) StopActivityIndicator {
    
    self.activeIndicator.alpha = 0;
    [self.activeIndicator stopAnimating];
}

- (void) StartActivityIndicator_Sub {
    
    self.activeIndicator_subView.alpha = 1;
    [self.activeIndicator_subView startAnimating];
}

- (void) StopActivityIndicator_Sub {
    
    self.activeIndicator_subView.alpha = 0;
    [self.activeIndicator_subView stopAnimating];
}


- (void) activeAccount_UI {
    
    self.mainView.alpha = 0;
    self.subView.alpha = 1;
}

- (IBAction)cancel_activeAccount:(id)sender {
    
    self.mainView.alpha = 1;
    self.subView.alpha = 0;
}

- (IBAction)activAccount_action:(id)sender {
    
    [self StartActivityIndicator_Sub];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            textfield_email.text, @"email",
            textfield_activAccount.text, @"activation_code",
            ID, @"registration_id",
            
            nil];
    
    [manager POST:@"http://moto.2-wm.ru/apiv2/authorization.activate" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Отсутствует email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"email_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Некорректный email" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"registration_id_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Отсутствует данные о регистрации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"registration_id_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Отсутствует данные о регистрации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"registration_id_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Отсутствует данные о регистрации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"activation_code_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Отсутствует код активации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"activation_code_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Некорректный код активации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"activation_code_incorrect"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Неверный код активации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"user_already_activated"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Код уже активирован" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"user_not_registered"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Пользователь не зарегестрирован" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
              } else {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Успешно" message:@"Аккаунт активирован" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
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
              
              [self StopActivityIndicator_Sub];
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
              if (alert.isShowing == 0) {
                  
                  [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Ошибка" message:@"Ошибка активации аккаунта" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
              }
              
              [self StopActivityIndicator_Sub];
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

@end
