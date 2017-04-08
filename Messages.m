//
//  Messages.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 20.12.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "Messages.h"

@interface Messages () <UITableViewDelegate, UITableViewDataSource> {
    
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *spinner;
    
    UserData *userData;
    UserAtDialog *user;
    Dialog *dialog;
}

@end

@implementation Messages

@synthesize sideBarButton, tableMessage, isEmptyMessageList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableViewStyle];
    [self setRevealSlideMenu];
    [self setRefreshConst];
    [self initActivityIndicatorView];
    
    [self getUserData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Сообщения";
    
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableViewStyle {
    
    tableMessage.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    tableMessage.separatorColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    tableMessage.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initActivityIndicatorView {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxY([self.view bounds]), 40)];
    
    [spinner setCenter:CGPointMake(CGRectGetMidX([self.view bounds]),20)];
    [activityView addSubview:spinner];
    
    [spinner startAnimating];
    
    self.tableMessage.tableHeaderView = activityView;
}

- (void) hideActivityIndicatorView {
    [spinner stopAnimating];
    self.tableMessage.tableHeaderView = nil;
}

- (void) setRevealSlideMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
}

- (void) setRefreshConst {
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [self.tableMessage addSubview:refreshControl];
    
    [refreshControl addTarget:self
                       action:@selector(LatestData)
             forControlEvents:UIControlEventValueChanged];
}

- (void) LatestData {
    
    [self getData];
    [refreshControl endRefreshing];
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

- (void) getData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            userData.token, @"token",
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/messages.getDialogs" parameters:dict progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             dialog = [[Dialog alloc] initDialogWithLastMessageText:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"last_message"] valueForKey:@"text"]
                                                    lastMessageDate:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"last_message"] valueForKey:@"time"]
                                                        unreadCount:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"unread_count"]
                       ];
             
             
             user = [[UserAtDialog alloc] initUserWithImageURL:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"image"]
                                                         fname:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"first_name"]
                                                         lname:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"last_name"]
                                                            ID:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"id"]
                     ];
             
             if (dialog.lastMessageText.count == 0) {
                 isEmptyMessageList.hidden = false;
             }
             
             [self.tableMessage reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
             [self hideActivityIndicatorView];
     }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error: %@", error);
     }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dialog.lastMessageText.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = (MessageCell *)[tableMessage dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.view.layer.cornerRadius = 10;
    cell.view.clipsToBounds = true;
    
    if ([dialog.unreadCount objectAtIndex:indexPath.row] > 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:0.3];
    }

    cell.photo.layer.cornerRadius = 25;
    cell.photo.clipsToBounds = YES;
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [user.fname objectAtIndex:indexPath.row], [user.lname objectAtIndex:indexPath.row]];
    [cell.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [user.image_url objectAtIndex:indexPath.row], @"_list.jpg"]]];
    
    double timeInterval = [[dialog.lastMessageDate objectAtIndex:indexPath.row] doubleValue];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd MMM"];
    NSString *date = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    cell.date.text = [NSString stringWithFormat:@"%@", date];
    cell.last_message.text = [NSString stringWithFormat:@"%@", [dialog.lastMessageText objectAtIndex:indexPath.row]];
    cell.unread.text = [NSString stringWithFormat:@"%@", [dialog.unreadCount objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSUserDefaults standardUserDefaults] setObject:[user.ID objectAtIndex:indexPath.row] forKey:@"user.id"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

@end
