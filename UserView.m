//
//  UserView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "UserView.h"

@interface UserView () <UIGestureRecognizerDelegate> {
    
    NSString *data_id;
    NSString *data_token;
    
    User *user;
    
    bool isLoaded;
}
@end

@implementation UserView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableStyle];
    
    [self getUserData];
    [self userData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableStyle {
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
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
    
    NSString *url = [NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/users.get?id=%@&fields=image,first_name,last_name", [[NSUserDefaults standardUserDefaults] objectForKey:@"user.ID"]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (isLoaded == true) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 250;
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
            
            UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
            
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tapImage.delegate = self;
            
            cell.photo.userInteractionEnabled = YES;
            [cell.photo addGestureRecognizer:tapImage];
            
            cell.name.text = [NSString stringWithFormat:@"%@ %@", user.fname, user.lname];
            [cell.name setUserInteractionEnabled:false];
            
            cell.title.text = [NSString stringWithFormat:@"г.Санкт - Петербург"];
            
            cell.photo.layer.cornerRadius = 55;
            cell.photo.clipsToBounds = YES;
            [cell.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_profile.jpg"]]];
            
            [cell.sendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
            [cell.friendRequest addTarget:self action:@selector(friendRequest:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void) sendMessage:(UIButton *)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

- (void) friendRequest:(UIButton *)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data_token, @"token",
            [[NSUserDefaults standardUserDefaults] stringForKey:@"user.ID"], @"user_id",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"http://moto.2-wm.ru/apiv2/friends.add";
    [manager POST:url parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"%@", responseObject);
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error: %@", error);
          }];
}


- (void) tap:(UITapGestureRecognizer *)tapGesture {
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_full.jpg"]];
    
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
