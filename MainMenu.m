//
//  MainMenu.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 31.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "MainMenu.h"

@interface MainMenu () {
    
    UIActivityIndicatorView *spinnerActivityIndicator;
    UISegmentedControl *segmentControl;
    
    LentaJSONObject *lentaObject;
    NotificationModel *notification;
    UserData *userData;
    
    bool isSelected;
}

@end

@implementation MainMenu

@synthesize sideBarButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadLentaData];
    [self loadNotificationData];
    
    [self initSegmentControl];
    [self initRevealMenu];
    [self ApplyTableStyle];
    [self initActivityIndicatorView];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.hidesBarsOnSwipe = false;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = @"Мото - мото";
    self.navigationController.hidesBarsOnSwipe = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableStyle {
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void) initRevealMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
}

- (void) initActivityIndicatorView {
    
    spinnerActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxY([self.view bounds]), 40)];
    
    [spinnerActivityIndicator setCenter:CGPointMake(CGRectGetMidX([self.view bounds]), 20)];
    [activityView addSubview:spinnerActivityIndicator];
    
    [spinnerActivityIndicator startAnimating];
    
    self.tableView.tableHeaderView = activityView;
}

- (void) hideActivityIndicatorHeaderView {
    
    [spinnerActivityIndicator stopAnimating];
    self.tableView.tableHeaderView = nil;
}

- (void) initSegmentControl {
    
    segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"ЛЕНТА", @"УВЕДОМЛЕНИЯ"]];
    segmentControl.tintColor = [UIColor clearColor];
    segmentControl.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
    segmentControl.selectedSegmentIndex = 0;
    
    [segmentControl addTarget:self
                       action:@selector(tapSegmentControl:)
             forControlEvents:UIControlEventValueChanged];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0]} forState:UIControlStateNormal];
}

- (void) loadLentaData {
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     [manager GET: @"http://moto.2-wm.ru/apiv2/bigEvents.getList" parameters:nil progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             
             NSLog(@"%@", responseObject);
             
             lentaObject = [[LentaJSONObject alloc] initLentaObjectWithID:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"id"]
                                                                image_url:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"image"]
                                                                    title:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"title"]
                            ];
           

             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
             [self hideActivityIndicatorHeaderView];
        }
     
        failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
        }];
}

- (void) getUserData {
    
    NSError *error = nil;
    userData = [[UserData alloc] initUserDataWithToken:[FDKeychain itemForKey: @"token"
                                                                   forService: @"MotoMotoApp"
                                                                        error: &error]
                
                                                    ID:[FDKeychain itemForKey: @"id"
                                                                   forService: @"MotoMotoApp"
                                                                        error: &error]
                ];
}



- (void) loadNotificationData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/smallEvents.get?id=%d&fields=user_id,start_time", [userData.ID intValue]];
    [manager GET: url parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             if ([[[responseObject valueForKey:@"data"] valueForKey:@"erorr"] isEqualToString:@"not_found"]) {
                 
             } else {
                 
                 notification = [[NotificationModel alloc] initNotificationWithUserID:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user_id"]
                                                                                   ID:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"id"]
                                                                                 time:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"start_time"]
                                 ];
             }
             
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
        
    } else {
        
        if (isSelected == true) {
            return notification.ID.count;
        } else {
            return lentaObject.ID.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 40;
        
    } else {
        
        if (isSelected == true) {
            return 50;
        } else {
            return 210;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0: {
            
            UITableViewCell *cell = (UITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            
            segmentControl.frame = CGRectMake(0, 0, CGRectGetWidth([cell bounds]), 40);
            [cell.contentView addSubview:segmentControl];
            
            return cell;
        }
            break;
            
        case 1: {
            
            if (isSelected == true) {
                
                NotificationCell *cell = (NotificationCell *)[self.tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
                if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.backgroundColor = [UIColor clearColor];
                
                double timeInterval = [[notification.time objectAtIndex:indexPath.row] doubleValue] - 10800;
                NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
                [dateformat setDateFormat:@"dd MMM HH:mm"];
                cell.time.text = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
                
                //cell.title.text = [NSString stringWithFormat:@"%@ %@ создал(а) событие", [fnameArray objectAtIndex:indexPath.row], [lnameArray objectAtIndex:indexPath.row]];
                
                cell.image.layer.cornerRadius = 21.5;
                cell.image.clipsToBounds = YES;
                
                //[cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://motomoto.2-wm.ru/apiv1%@", [imageArray objectAtIndex:indexPath.row]]]];
                
                return cell;
                
            } else {
                
                LentaCell *cell = (LentaCell *)[self.tableView dequeueReusableCellWithIdentifier:@"LentaCell"];
                if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LentaCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.backgroundColor = [UIColor clearColor];
                
                cell.title.text = [NSString stringWithFormat:@"%@", [lentaObject.title objectAtIndex:indexPath.row]];
                //cellLenta.subtitle.text = [NSString stringWithFormat:@"%@", [location objectAtIndex:indexPath.row]];
                [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://motomoto.2-wm.ru/apiv1",[lentaObject.image_url objectAtIndex:indexPath.row]]]];
                cell.image.layer.cornerRadius = 5;
                cell.image.clipsToBounds = YES;
                
                return cell;
            }
        }
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isSelected == true) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[notification.ID objectAtIndex:indexPath.row] forKey:@"se.ID"];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"smallEventView"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:[lentaObject.ID objectAtIndex:indexPath.row] forKey:@"bigEvent"];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"Place"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
    }
}

- (void)tapSegmentControl:(id)sender {
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        isSelected = false;
        [self.tableView reloadData];
        
    } else {
        
        isSelected = true;
        [self.tableView reloadData];
    }
}

@end
