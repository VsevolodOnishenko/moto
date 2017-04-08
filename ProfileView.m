//
//  ProfileView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 22.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    
    NSString *data_id;
    NSString *data_token;
    
    User *user;
    
    NSString *fullImage;
    
    bool isContact;
    bool isSelected;
    bool isLoaded;
    
    UIActivityIndicatorView *spinner;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *eb;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ProfileView
@synthesize ProfileTableView, slideBarButton, editProfileButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initActivityIndicatorView];
    
    [self setRevealSlideMenu];
    [self ApplyTableStyle];
    [self getUserData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self userData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setRevealSlideMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    slideBarButton.target = self.revealViewController;
    slideBarButton.action = @selector(revealToggle:);
}

- (void) ApplyTableStyle {
    
    ProfileTableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    ProfileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    ProfileTableView.separatorColor = [UIColor clearColor];
}

- (void) initActivityIndicatorView {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxY([self.view bounds]), 40)];
    
    [spinner setCenter:CGPointMake(CGRectGetMidX([self.view bounds]),20)];
    [activityView addSubview:spinner];
    
    [spinner startAnimating];
    
    self.tableView.tableHeaderView = activityView;
}

- (void) hideActivityIndicatorView {
    
    [spinner stopAnimating];
    self.tableView.tableHeaderView = nil;
}

- (void) getUserData {
    
    NSError *error = nil;
    data_id = [FDKeychain itemForKey: @"id"
                          forService: @"MotoMotoApp"
                               error: &error];
    
    data_token = [FDKeychain itemForKey: @"token"
                             forService: @"MotoMotoApp"
                                  error: &error];
}

- (void) userData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/users.get?id=%@&fields=image,first_name,last_name", data_id];
    [manager GET:url parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             user = [[User alloc] initUserWithImageURL:[[responseObject valueForKey:@"data"] valueForKey:@"image"]
                                                 fname:[[responseObject valueForKey:@"data"] valueForKey:@"first_name"]
                                                 lname:[[responseObject valueForKey:@"data"] valueForKey:@"last_name"]
                                                    ID:nil
                     ];
             
             isLoaded = true;
             isSelected = true;
             
             [self hideActivityIndicatorView];
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (isLoaded == true) {
        return 3;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 190;
    } else if (indexPath.section == 1) {
        return 40;
    } else {
        return 300;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            
            ProfileInfoCell *cell = (ProfileInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileInfoCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileInfoCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
                
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tapImage.delegate = self;
            
            cell.image.userInteractionEnabled = YES;
            [cell.image addGestureRecognizer:tapImage];
            
            cell.name.text = [NSString stringWithFormat:@"%@ %@", user.fname, user.lname];
            [cell.name setUserInteractionEnabled:false];
            
            cell.address.text = [NSString stringWithFormat:@"г.Санкт - Петербург"];
            
            cell.image.layer.cornerRadius = 55;
            cell.image.clipsToBounds = YES;
            [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_profile.jpg"]]];
            
            return cell;
        }
            break;
            
        case 1: {
            
            UITableViewCell *cell = (UITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            
            self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"ФОТОГРАФИИ", @"СОБЫТИЯ"]];
            self.segmentControl.frame = CGRectMake(0, 0, CGRectGetWidth([cell bounds]), 40);
            self.segmentControl.tintColor = [UIColor clearColor];
            self.segmentControl.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
            self.segmentControl.selectedSegmentIndex = 0;
    
            [_segmentControl addTarget:self
                                action:@selector(selected:)
                      forControlEvents:UIControlEventValueChanged];
            
            [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
            [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
            [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0]} forState:UIControlStateNormal];
            
            [cell.contentView addSubview:self.segmentControl];
            
            return cell;
        }
            break;
            
        case 2: {
        
            if (isSelected == false) {
                isSelected = true;
                
                ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
                if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
                
                cell.collectionView.delegate = self;
                cell.collectionView.dataSource = self;
                
                [cell.collectionView registerNib:[UINib nibWithNibName:@"ListImageCell" bundle:nil] forCellWithReuseIdentifier:@"ListImageCell"];
                
                return cell;
                
            } else {
                isSelected = false;
                
                ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
                if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.backgroundColor = [UIColor redColor];
                
                cell.collectionView.delegate = self;
                cell.collectionView.dataSource = self;
                
                cell.collectionView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
                [cell.collectionView registerNib:[UINib nibWithNibName:@"ListImageCell" bundle:nil] forCellWithReuseIdentifier:@"ListImageCell"];
                
                UILabel *lblMain = [[UILabel alloc] init];
                lblMain.frame = CGRectMake(0, CGRectGetMidY([cell bounds]), CGRectGetWidth([cell bounds]), 50);
                lblMain.text = @"У вас пока нет фотографий";
                lblMain.textColor = [UIColor whiteColor];
                lblMain.textAlignment = NSTextAlignmentCenter;
                lblMain.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:16];
                [cell.contentView addSubview:lblMain];
                
                UILabel *lblBody = [[UILabel alloc] init];
                lblBody.frame = CGRectMake(0, CGRectGetMidY([cell bounds]) * 1.3, CGRectGetWidth([cell bounds]), 100);
                lblBody.text = @"Использовать фотографии - лучший способ рассказать о себе и своих мото предпочтениях.";
                lblBody.textColor = [UIColor whiteColor];
                lblBody.textAlignment = NSTextAlignmentCenter;
                lblBody.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
                lblBody.numberOfLines = 3;
                [cell.contentView addSubview:lblBody];
                
                UIButton *button = [[UIButton alloc] init];
                button.frame = CGRectMake(0, CGRectGetMidY([cell bounds]) * 2.5, CGRectGetWidth([cell bounds]), 100);
                [button setTitle:@"Загрузить фотографии" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:0.48 green:0.73 blue:0.92 alpha:1.0] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                return cell;
            }
        }
            break;
             
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = (UICollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"ListImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.5;
    
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}

- (void)selected:(id)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        isSelected = true;
        NSArray *ip = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]];
        [self.tableView reloadRowsAtIndexPaths:ip withRowAnimation:UITableViewRowAnimationNone];
        
    } else {
        
        isSelected = false;
        NSArray *ip = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]];
        [self.tableView reloadRowsAtIndexPaths:ip withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)addImage:(id)sender {
}

- (void)tap:(UITapGestureRecognizer *)tapGesture {
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_full.jpg"]];
    
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (IBAction)editProflile:(id)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingProfile"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

- (void)sendMessage:(UIButton *)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

- (void)addToContact:(UIButton *)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", data_token] forHTTPHeaderField:@"Authorization"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data_id, @"from_person",
            [[NSUserDefaults standardUserDefaults] stringForKey:@"user.id"], @"to_person",
            @"1", @"status",
            
            nil];
    
    NSString *url = @"http://motomoto.2-wm.ru/apiv1/users/friend/create";
    [manager POST:url parameters:dict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if ([responseObject valueForKey:@"status"]) {
                  isContact = true;
                  [ProfileTableView reloadData];
              }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error: %@", error);
     }];
}

@end
