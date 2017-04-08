//
//  Authorization.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "Authorization.h"

@interface Authorization () <VKSdkDelegate> {
    
    UIView *viewGradiend;
    
    RKDropdownAlert *alert;
}

@end

@implementation Authorization

@synthesize image_background, viewMain, viewAnimLog, segmend, viewLoader, headerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyNavBarStyle];
    [self ApplySegmentControllStyle];
    [self ApplyViewStyle];
    [self initGestRecognize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    image_background.hidden = NO;
    viewMain.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    image_background.hidden = YES;
    viewMain.hidden = YES;
}

- (void)didReceiveMemoryWarnin {
    [super didReceiveMemoryWarning];
}

- (void) ApplyViewStyle {
    
    viewAnimLog.hidden = YES;
    
    viewGradiend = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX([self.view bounds]), CGRectGetMaxY([self.view bounds]))];
    [self.view insertSubview:viewGradiend atIndex:2];
}

- (void) ApplyNavBarStyle {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

}

- (void) ApplySegmentControllStyle {
    
    segmend.tintColor = [UIColor clearColor];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5]} forState:UIControlStateNormal];
}

- (void) initGestRecognize {
    
    UISwipeGestureRecognizer *Swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedown:)];
    Swiperight.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:Swiperight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.headerView addGestureRecognizer:tap];
}

- (void)swipedown:(UISwipeGestureRecognizer*)gestureRecognizer {
    [self hideAuthRegistrView];
}

- (void)tap:(UITapGestureRecognizer*)gestureRecognizer {
    [self hideAuthRegistrView];
}

- (void) hideAuthRegistrView {
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    animation.duration = 0.4;
    [viewAnimLog.layer addAnimation:animation forKey:nil];
    viewAnimLog.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        viewGradiend.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.0];
    }];
}

- (IBAction)registration:(id)sender {
    
    segmend.selectedSegmentIndex = 1;
    
    self.containerLogIn.alpha = 1;
    self.containerLogOn.alpha = 0;
    
    [self pushAuthRegistrView];
    [self showGradientView];
}

- (IBAction)logIn:(id)sender {
    
    segmend.selectedSegmentIndex = 0;
    
    self.containerLogIn.alpha = 0;
    self.containerLogOn.alpha = 1;
    
    [self pushAuthRegistrView];
    [self showGradientView];
}

- (void) pushAuthRegistrView {
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.2;
    [viewAnimLog.layer addAnimation:animation forKey:nil];
    viewAnimLog.hidden = NO;
}

- (void) showGradientView {
    
    [UIView animateWithDuration:0.5 animations:^{
        viewGradiend.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.7];
    }];
}

- (IBAction)logInFacebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions: @[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
         if (error) {
             NSLog(@"Process error");
             [RKDropdownAlert title:@"" message:@"Ошибка авторизации" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:10];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             [self logFB];
         }
     }];
}

- (void) logFB {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [FBSDKAccessToken currentAccessToken].tokenString , @"provider_token",
            @"facebook", @"provider",
            nil];
    
    NSString *url = @"http://moto.2-wm.ru/apiv2/authorization.login";
    [manager POST:url parameters:dict progress:nil
     
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
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"provider_token_not_specified"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"provider_token_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"device_os_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
              
              else if ([[responseObject valueForKey:@"errors"] valueForKey:@"device_token_invalid"]) {
                  
                  if (alert.isShowing == 0) {
                      
                      [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                
              } else {
                  
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
              }
     }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error: %@", error);
     }];
}

- (IBAction)logInVK:(id)sender {
    
    VKSdk *vkinstance = [VKSdk initializeWithAppId:@"5963565"];
    [vkinstance registerDelegate:self];
 
    [VKSdk authorize:@[]];
}

- (void)vkSdkUserAuthorizationFailed {
    
    if (alert.isShowing == 0) {
        
        [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
        [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
    }
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    
    if (result.token) {
        
        [[[VKApi users] get:@{ VK_API_FIELDS : @"id,first_name,last_name,photo_max_orig"}]
         executeWithResultBlock:^(VKResponse *response) {
             
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
             
             dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"vk", @"provider",
                     result.token.accessToken, @"provider_token",
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
                       
                       else if ([[responseObject valueForKey:@"errors"] valueForKey:@"provider_token_not_specified"]) {
                           
                           if (alert.isShowing == 0) {
                               
                               [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                               [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                           }
                       }
                       
                       else if ([[responseObject valueForKey:@"errors"] valueForKey:@"provider_token_invalid"]) {
                           
                           if (alert.isShowing == 0) {
                               
                               [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                               [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                           }
                       }
                       
                       else if ([[responseObject valueForKey:@"errors"] valueForKey:@"device_os_invalid"]) {
                           
                           if (alert.isShowing == 0) {
                               
                               [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                               [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                           }
                       }
                       
                       else if ([[responseObject valueForKey:@"errors"] valueForKey:@"device_token_invalid"]) {
                           
                           if (alert.isShowing == 0) {
                               
                               [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                               [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                           }
                           
                       } else {
                           
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
                   }
              
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"error: %@", error);
              }];
             
         } errorBlock:^(NSError *error) {
             
             if (alert.isShowing == 0) {
                 
                 [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                 [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
             }
         }];
        
    } else if (result.error) {
        
        if (alert.isShowing == 0) {
            
            [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
            [RKDropdownAlert title:@"Ошибка" message:@"Ошибка авторизации" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
        }
    }
}

- (IBAction)segmentDidAction:(id)sender {
    
    if (segmend.selectedSegmentIndex == 0) {
        
        self.containerLogIn.alpha = 0;
        self.containerLogOn.alpha = 1;
    } else {
        
        self.containerLogIn.alpha = 1;
        self.containerLogOn.alpha = 0;
    }
}

- (void) toController {
    
    UIViewController *registrtion = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    
    registrtion.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    registrtion.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:registrtion animated:YES completion:nil];
}

- (IBAction)usernotifications:(id)sender {
}


@end
