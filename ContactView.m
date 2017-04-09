//
//  ContactView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 20.12.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "ContactView.h"

@interface ContactView () <UITableViewDataSource, UITableViewDelegate> {
    
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *loader;
    
    ContactUser *contactUser;
    OutcomeReqObj *outcomeReqObj;
    IncomeReqObj *incomeReqObj;
    
    UserData *data;
    
    bool isLoaded;
}

@end

@implementation ContactView

@synthesize slideBarButton, containerViewRequset, tableViewContact, segmentControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initActivityIndicatorView];
    
    [self getUserData];
    
    [self getFriendListData];
    
    [self ApplyTableViewStyle];
    [self ApplySegmentControlStyle];
    
    [self setRevealSlideMenu];
    [self setRefreshConst];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Контакты";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableViewStyle {
    
    self.tableViewContact.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableViewContact.separatorColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    self.tableViewContact.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initActivityIndicatorView {
    
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxY([self.view bounds]), 40)];
    
    [loader setCenter:CGPointMake(CGRectGetMidX([self.view bounds]),20)];
    [activityView addSubview:loader];
    
    [loader startAnimating];
    
    self.tableViewContact.tableHeaderView = activityView;
}

- (void) hideActivityIndicatorView {
    
    [loader stopAnimating];
    self.tableViewContact.tableHeaderView = nil;
}

- (void) setRefreshConst {
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [self.tableViewContact addSubview:refreshControl];
    
    [refreshControl addTarget:self
                       action:@selector(LatestData)
             forControlEvents:UIControlEventValueChanged];
}

- (void) LatestData {
    [self getFriendListData];
    [refreshControl endRefreshing];
}

- (void) setRevealSlideMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    slideBarButton.target = self.revealViewController;
    slideBarButton.action = @selector(revealToggle:);
}

- (void) ApplySegmentControlStyle {
    
    self.segmentControl.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
    self.segmentControl.tintColor = [UIColor clearColor];
    self.segmentControl.selectedSegmentIndex = 0;
    
    CGRect frame = self.segmentControl.frame;
    [self.segmentControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40)];
    
    [self.segmentControl addTarget:self
                        action:@selector(selected:)
              forControlEvents:UIControlEventValueChanged];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0]} forState:UIControlStateNormal];
}

- (void) getUserData {
    
    NSError *error = nil;
    
    data = [[UserData alloc] initUserDataWithToken:[FDKeychain itemForKey: @"token"
                                                               forService: @"MotoMotoApp"
                                                                    error: &error]
            
                                                ID:[FDKeychain itemForKey: @"id"
                                                               forService: @"MotoMotoApp"
                                                                    error: &error]
            ];
}

- (void) getFriendListData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            data.token, @"token",
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/friends.getList" parameters:dict progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             contactUser = [[ContactUser alloc] initUserWithImage:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"image"]
                                                            fname:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"first_name"]
                                                            lname:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"last_name"]
                                                            ident:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"id"]
                            ];
             
             isLoaded = true;
                          
             [self.tableViewContact reloadData];
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
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isLoaded == true) {
        
        if (contactUser.ident.count == 0) {
            return 1;
        } else {
            return contactUser.ident.count;
        }
        
    } else {
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (contactUser.ident.count == 0) {
        
        UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.text = @"У вас пока нет друзей";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        
        return cell;
        
    } else {
        
        ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.photo.layer.cornerRadius = 25;
        cell.photo.clipsToBounds = YES;
        
        cell.name.text = [NSString stringWithFormat:@"%@ %@", [contactUser.fname objectAtIndex:indexPath.row], [contactUser.lname objectAtIndex:indexPath.row]];
        [cell.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [contactUser.image objectAtIndex:indexPath.row], @"_list.jpg"]]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSUserDefaults standardUserDefaults] setObject:[contactUser.ident objectAtIndex:indexPath.row] forKey:@"user.ID"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"userMap"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

- (void)selected:(id)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        tableViewContact.hidden = false;
        containerViewRequset.hidden = true;
        
    } else {
        
        tableViewContact.hidden = true;
        containerViewRequset.hidden = false;
    }
}

@end

