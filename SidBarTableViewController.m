//
//  SidBarTableViewController.m
//  DateApp
//
//  Created by Олег Малахов on 04.08.16.
//  Copyright © 2016 Владимир Малахов. All rights reserved.
//

#import "SidBarTableViewController.h"

@interface SidBarTableViewController () {
    
    NSArray *menuItems;
    NSString *data;
    NSString *token;
    
    User *user;
    
    int unreadCount;
    
    bool isLoaded;
    
    int frCount;
    int messageCount;
}

@end

@implementation SidBarTableViewController

@synthesize sidetableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableStyle];
    [self getUserData];
    [self userData];
    [self getData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self userData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableStyle {
    
    menuItems = @[@"Profile", @"Lenta", @"Map", @"Track", @"Contacts", @"Messages", @"Search", @"Settings", @"empty", @"LogOut"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 120;
    } else if (indexPath.row == 1) {
        return 60;
    } else if (indexPath.row == 8) {
        return 160;
    } else {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        ProfileCell *cell = (ProfileCell *)[sidetableView dequeueReusableCellWithIdentifier:@"Profile"];
        
        cell.name.hidden = true;
        cell.photo.hidden = true;
        
        if (isLoaded == true) {
            
            cell.name.hidden = false;
            cell.photo.hidden = false;
            
            cell.name.text = [NSString stringWithFormat:@"%@ %@", user.fname, user.lname];
            
            cell.photo.layer.cornerRadius = 20;
            cell.photo.clipsToBounds = YES;
            cell.backgroundColor = [UIColor clearColor];
            
            [cell.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_profile.jpg"]]];
        }
    
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[menuItems objectAtIndex:indexPath.row] forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
        
        if (indexPath.row == 5) {
            
            if (messageCount > 0) {
                
                UIView *view = [[UIView alloc] init];
                view.frame = CGRectMake(CGRectGetMaxX([cell bounds]) * 0.7, CGRectGetMaxY([cell bounds]) * 0.30, 20, 20);
                view.backgroundColor = [UIColor colorWithRed:1.00 green:0.47 blue:0.00 alpha:1.0];
                view.layer.cornerRadius = 10;
                view.clipsToBounds = true;
                
                UILabel *lbl = [[UILabel alloc] init];
                lbl.frame = CGRectMake(0, 0, 20, 20);
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.text = [NSString stringWithFormat:@"%d", messageCount];
                lbl.textColor = [UIColor whiteColor];
                lbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
                [view addSubview:lbl];
                
                [cell.contentView addSubview:view];
            }
        }
        
        if (indexPath.row == 4) {
            
            if (frCount > 0) {
                
                UIView *view = [[UIView alloc] init];
                view.frame = CGRectMake(CGRectGetMaxX([cell bounds]) * 0.7, CGRectGetMaxY([cell bounds]) * 0.30, 20, 20);
                view.backgroundColor = [UIColor colorWithRed:1.00 green:0.47 blue:0.00 alpha:1.0];
                view.layer.cornerRadius = 10;
                view.clipsToBounds = true;
                
                UILabel *lbl = [[UILabel alloc] init];
                lbl.frame = CGRectMake(0, 0, 20, 20);
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.text = [NSString stringWithFormat:@"%d", frCount];
                lbl.textColor = [UIColor whiteColor];
                lbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
                [view addSubview:lbl];
                
                [cell.contentView addSubview:view];
            }
        }
        
        return cell;
    }
  
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:true] forKey:@"isNativeUser"];
    }
    
    if (indexPath.row == 9) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Внимание"
                                                                       message:@"Вы уверены, что хотите выйти?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self logOut];
                                                              [self toInitilController];
                                                          }];
        
        UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:yesAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void) logOut {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"isLogged"];
}

- (void) toInitilController {

    UIViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoggedIn"];
    SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ident" source:self destination:toViewController];
    [segue perform];
}

- (void) getUserData {
    
    NSError *error = nil;
    
    data = [FDKeychain itemForKey: @"id"
                       forService: @"MotoMotoApp"
                            error: &error];
    
    token = [FDKeychain itemForKey: @"token"
                        forService: @"MotoMotoApp"
                             error: &error];
}

- (void) userData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/users.get?id=%@&fields=image,first_name,last_name", data];
    [manager GET:url parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             user = [[User alloc] initUserWithImageURL:[[responseObject valueForKey:@"data"] valueForKey:@"image"]
                                             fname:[[responseObject valueForKey:@"data"] valueForKey:@"first_name"]
                                             lname:[[responseObject valueForKey:@"data"] valueForKey:@"last_name"]
                                                ID:nil
                     ];
             
             isLoaded = true;
         
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void) getData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            token, @"token",
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/notifications.getCounts" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              frCount = [[[responseObject valueForKey:@"data"] valueForKey:@"incoming_friend_request_count"] intValue];
              messageCount = [[[responseObject valueForKey:@"data"] valueForKey:@"unread_message_count"] intValue];
              
              [self.tableView reloadData];
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error: %@", error);
          }];
}

@end
