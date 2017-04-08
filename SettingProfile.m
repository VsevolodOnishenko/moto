//
//  SettingProfile.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SettingProfile.h"

@interface SettingProfile () <UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIActivityIndicatorView *loader;
    
    NSString *data_id;
    NSString *data_token;
    
    NSString *fname;
    NSString *lname;
    NSString *year;
    NSString *sex;
    
    User *user;
    
    RKDropdownAlert *alertRK;
    
    bool isLoaded;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation SettingProfile

@synthesize SettingProfileTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initActivityIndicatorView];
        
    [self ApplyTableStyle];
    [self initSegmentController];
    
    [self getUserData];
    [self userData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Изм.профиль";
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initActivityIndicatorView {
    
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxY([self.view bounds]), 40)];
    
    [loader setCenter:CGPointMake(CGRectGetMidX([self.view bounds]),20)];
    [activityView addSubview:loader];
    
    [loader startAnimating];
    
    self.tableView.tableHeaderView = activityView;
}

- (void) hideActivityIndicatorView {
    
    [loader stopAnimating];
    self.tableView.tableHeaderView = nil;
}

- (void) ApplyTableStyle {
    
    SettingProfileTableView.separatorColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    SettingProfileTableView.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
    SettingProfileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initSegmentController {
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"", @""]];
    
    [self.segmentControl addTarget:self
                        action:@selector(tapSegmentControl:)
              forControlEvents:UIControlEventValueChanged];

    self.segmentControl.tintColor = [UIColor clearColor];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0]} forState:UIControlStateNormal];
    
    [self.segmentControl setTitle:@"Мужской" forSegmentAtIndex:0];
    [self.segmentControl setTitle:@"Женский" forSegmentAtIndex:1];
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
    
    NSString *url = [NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/users.get?id=%@&fields=image,first_name,last_name,gender", data_id];
    [manager GET:url parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             user = [[User alloc] initUserWithImageURL:[[responseObject valueForKey:@"data"] valueForKey:@"image"]
                                                 fname:[[responseObject valueForKey:@"data"] valueForKey:@"first_name"]
                                                 lname:[[responseObject valueForKey:@"data"] valueForKey:@"last_name"]
                                                    ID:nil
                     ];
             
             fname = user.fname;
             lname = user.lname;
             self.navigationItem.title = user.fname;
             
             isLoaded = true;
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
    
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
        return 130;
    else
        return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1)
        return @"Личная информация";
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return CGFLOAT_MIN;
    else
        return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0: {
            
            SettingProfileCell *cell = (SettingProfileCell *)[SettingProfileTableView dequeueReusableCellWithIdentifier:@"SettingProfileCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingProfileCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
            cell.image.layer.cornerRadius = 45;
            cell.image.clipsToBounds = YES;
            
            cell.fname.delegate = self;
            cell.lname.delegate = self;
            
            [cell.fname addTarget:self action:@selector(fnameDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.lname addTarget:self action:@selector(lnameDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tapImage.delegate = self;
            cell.image.userInteractionEnabled = YES;
            [cell.image addGestureRecognizer:tapImage];
            
            loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX([cell bounds]), CGRectGetMaxY([cell bounds]) * 0.95 , 20, 20)];
            [cell addSubview:loader];
            
            cell.fname.text = user.fname;
            cell.lname.text = user.lname;
            
            [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_profile.jpg"]]];
            
            return cell;
        }
            break;
            
        case 1: {
            
            switch (indexPath.row) {
                    
                case 0: {
                    
                    SettingYearCell *cell = (SettingYearCell *)[SettingProfileTableView dequeueReusableCellWithIdentifier:@"SettingYearCell"];
                    if (cell == nil) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingYearCell" owner:self options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
                    
                    cell.tfYear.delegate = self;
                    [cell.tfYear addTarget:self action:@selector(yearDidChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    return cell;
                }
                    break;
                    
                case 1: {
                    
                    UITableViewCell *cell = (UITableViewCell *) [SettingProfileTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                    cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
                    
                    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                    cell.textLabel.textColor = [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:1.0];
                    cell.textLabel.text = @"Пол";
                    
                    self.segmentControl.frame = CGRectMake(50, 0, CGRectGetWidth([cell bounds]) - 50, CGRectGetHeight([cell bounds]));
                    [cell.contentView addSubview:_segmentControl];
                    
                    if ([sex isEqualToString:@"man"]) {
                        self.segmentControl.selectedSegmentIndex = 0;
                    }
                    
                    if ([sex isEqualToString:@"woman"]) {
                        self.segmentControl.selectedSegmentIndex = 1;
                    }
                    
                    return cell;
                }
                    
                default:
                    return nil;
                    break;
            }
        }
            break;
            
        case 2: {
            
            UITableViewCell *cell = (UITableViewCell *) [SettingProfileTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
            
            NSArray *geo = @[@"Страна    Россия", @"Город      Санкт - Петербург"];
            
            cell.textLabel.text = [geo objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.textLabel.textColor = [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:1.0];
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tap:(UITapGestureRecognizer *)tapGesture {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *showImage = [UIAlertAction actionWithTitle:@"Посмотреть фотографию" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
                                                              imageInfo.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_full.jpg"]];
                                                              
                                                              JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                                                                                     initWithImageInfo:imageInfo
                                                                                                     mode:JTSImageViewControllerMode_Image
                                                                                                     backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
                                                              
                                                              [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
                                                          }];
    
    UIAlertAction *addImage = [UIAlertAction actionWithTitle:@"Добавить фотографию" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                         imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                         imagePickerController.delegate = self;
                                                         [self presentViewController:imagePickerController animated:YES completion:nil];
                                                         
                                                     }];
    
    //UIAlertAction *deleteImage = [UIAlertAction actionWithTitle:@"Удалить фотографию" style:UIAlertActionStyleDefault
    //                                               handler:^(UIAlertAction * action) {
    //                                             }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                        }];
    
    [alert addAction:showImage];
    [alert addAction:addImage];
    //[alert addAction:deleteImage];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [loader startAnimating];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:0];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data_token, @"token",
            encodedString, @"image",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://moto.2-wm.ru/apiv2/users.edit" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if ([[responseObject valueForKey:@"errors"] valueForKey:@"image_invalid"]) {
                  
                  if (alertRK.isShowing == 0) {
                      
                      [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Ошибка" message:@"Ошибка редактрования" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
              }
            
              else {
                 
                  if (alertRK.isShowing == 0) {
                      
                      [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                      [RKDropdownAlert title:@"Успешно" message:@"Данные обновлены" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                  }
                  
                  [self userData];
              }
          }
     
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              if (alertRK.isShowing == 0) {
                  
                  [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Ошибка" message:@"Ошибка редактирования" backgroundColor:[UIColor colorWithRed:0.76 green:0.28 blue:0.28 alpha:1.0] textColor:[UIColor whiteColor] time:2];
              }
          }];
}

-(void)fnameDidChange:(UITextField *)tf {
    fname = tf.text;
}

-(void)lnameDidChange:(UITextField *)tf {
    lname = tf.text;
}

-(void)yearDidChange:(UITextField *)tf {
    year = tf.text;
}

- (void)tapSegmentControl:(id)sender {
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        sex = @"man";
    } else {
        sex = @"woman";
    }
}

- (IBAction)editProfile:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:

            data_token, @"token",
            
            fname, @"first_name",
            lname, @"last_name",
            sex , @"gender",
            
            nil];
    
    [manager POST:@"http://moto.2-wm.ru/apiv2/users.edit" parameters:dict progress:nil
     
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
               if ([[responseObject valueForKey:@"errors"] valueForKey:@"token_not_specified"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:@"Ошибка редактрования" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
               
               else if ([[responseObject valueForKey:@"errors"] valueForKey:@"token_invalid"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:@"Ошибка редактрования" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
               
               else if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_invalid"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:@"Проверьте указанное имя" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
               
               else if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_short"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       NSString *messageError = [NSString stringWithFormat:@"Минимальная длина имени состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_short"] valueForKey:@"min_length"]];
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
               
               else if ([[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_long"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       NSString *messageError = [NSString stringWithFormat:@"Максимальная длина имени состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"first_name_too_long"] valueForKey:@"max_length"]];
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
               
               else if ([[responseObject valueForKey:@"errors"] valueForKey:@"last_name_invalid"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:@"Проверьте указанную фамилию" backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
               
               else if ([[responseObject valueForKey:@"errors"] valueForKey:@"last_name_too_long"]) {
                   
                   if (alertRK.isShowing == 0) {
                       
                       NSString *messageError = [NSString stringWithFormat:@"Максимальная длина фамилии состовляет %@ символов", [[[responseObject valueForKey:@"errors"] valueForKey:@"last_name_too_long"] valueForKey:@"max_length"]];
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Ошибка" message:messageError backgroundColor:[UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
               }
    
               else {
                   
                   if (alertRK.isShowing == 0) {
                       
                       [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                       [RKDropdownAlert title:@"Успешно" message:@"Данные обновлены" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:2];
                   }
                   
                   [self userData];
                   
               }
           }
     
     
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
               NSLog(@"error: %@", error);
               
               if (alertRK.isShowing == 0) {
                   
                   [alertRK title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                   [RKDropdownAlert title:@"Ошибка" message:@"Ошибка обновления данных" backgroundColor:[UIColor colorWithRed:0.76 green:0.28 blue:0.28 alpha:1.0] textColor:[UIColor whiteColor] time:2];
               }
           }];
}

@end
