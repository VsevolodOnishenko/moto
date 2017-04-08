//
//  SearchPeopleView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 29.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SearchPeopleView.h"

@interface SearchPeopleView () <UISearchResultsUpdating, UISearchBarDelegate> {
    
    NSMutableDictionary *dict;
    ContactUser *contactUser;
}

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation SearchPeopleView

@synthesize sideBarButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchController];
    [self setRevealSlideMenu];
    [self ApplyTableViewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initDictinory {
    dict = [[NSMutableDictionary alloc] init];
}

- (void) setRevealSlideMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
}

- (void) ApplyTableViewStyle {
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) setSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar setValue:@"Отмена" forKey:@"_cancelButtonText"];
    self.searchController.searchBar.placeholder = @"Поиск...";
    
    [self.searchController.searchBar sizeToFit];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = searchController.searchBar.text;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            searchString , @"query",
            nil];
    
    [self searchRequset];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void) searchRequset {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/search" parameters:dict progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             contactUser = [[ContactUser alloc] initUserWithImage:[[[responseObject valueForKey:@"data"] valueForKey:@"users"] valueForKey:@"image"]
                                                            fname:[[[responseObject valueForKey:@"data"] valueForKey:@"users"] valueForKey:@"first_name"]
                                                            lname:[[[responseObject valueForKey:@"data"] valueForKey:@"users"] valueForKey:@"last_name"]
                                                            ident:[[[responseObject valueForKey:@"data"] valueForKey:@"users"] valueForKey:@"id"]
                            ];
             
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contactUser.ident.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCell *cell = (ContactCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [contactUser.fname objectAtIndex:indexPath.row], [contactUser.lname objectAtIndex:indexPath.row]];
    
    cell.photo.layer.cornerRadius = 25;
    cell.photo.clipsToBounds = YES;
    [cell.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [contactUser.image objectAtIndex:indexPath.row], @"_list.jpg"]]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[[contactUser.ident objectAtIndex:indexPath.row] intValue]] forKey:@"user.ID"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    
    UIViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"userMap"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:user animated:YES];
}

@end
