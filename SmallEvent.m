//
//  SmallEvent.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 10.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SmallEvent.h"

@interface SmallEvent () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIDatePicker *datePicker;
    NSString *type;
    
    NSString *stringFromDate;
    UIImage *imageUpload;
    
    UserData *userData;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation SmallEvent

@synthesize SmallEventTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableViewStyle];
    
    [self initSegmentController];
    [self initTimeDataPicker];
    
    [self getUserData];
    
    [self.navigationItem.backBarButtonItem setTitle:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    [SmallEventTableView reloadData];
}

- (void) ApplyTableViewStyle {
    
    SmallEventTableView.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:0.7];
    SmallEventTableView.separatorColor = [UIColor clearColor];
    SmallEventTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    SmallEventTableView.estimatedRowHeight = 50;
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

- (void) initSegmentController {
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"", @""]];
    
    [_segmentControl addTarget:self
                       action:@selector(tapSegmentControl:)
             forControlEvents:UIControlEventValueChanged];
    
    _segmentControl.selectedSegmentIndex = 0;
    type = @"0";
    _segmentControl.tintColor = [UIColor clearColor];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0]} forState:UIControlStateNormal];
    
    NSString *titleSegemntAtIndex0;
    NSString *titleSegemntAtIndex1;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"smallEvent.type"] isEqualToString:@"Создать проишествие"]) {
        
        titleSegemntAtIndex0 = @"ДТП";
        titleSegemntAtIndex1 = @"ЗАСАДА";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"smallEvent.type"] isEqualToString:@"Создать встречу"]) {
        
        titleSegemntAtIndex0 = @"ВСТРЕЧА";
        titleSegemntAtIndex1 = @"ЧТО ТО";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"smallEvent.type"] isEqualToString:@"Создать прохват"]) {
        
        titleSegemntAtIndex0 = @"ПРОХВАТ";
        titleSegemntAtIndex1 = @"ЧТО ТО";
    }
    
    [_segmentControl setTitle:titleSegemntAtIndex0 forSegmentAtIndex:0];
    [_segmentControl setTitle:titleSegemntAtIndex1 forSegmentAtIndex:1];

}

- (void) initTimeDataPicker {
    
    datePicker = [[UIDatePicker alloc] init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd MMM HH:mm"];
    stringFromDate = [dateformat stringFromDate:[NSDate date]];
    
    [datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.row == 3) {
        return 150;
    } else if (indexPath.row == 4) {
        return 150;
    } else if (indexPath.row == 5) {
        return 70;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *) [SmallEventTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    
    switch (indexPath.row) {
        case 0: {
    
            _segmentControl.frame = CGRectMake(0, 0, CGRectGetWidth([cell bounds]), CGRectGetHeight([cell bounds]));
            [cell.contentView addSubview:_segmentControl];
            
            cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
            
            return cell;
        }
            break;
            
        case 1: {
            
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"TW"] == NULL) {
                
                NSAttributedString *ph = [[NSAttributedString alloc] initWithString:@"Описание события..." attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
                cell.textLabel.attributedText = ph;
                
            } else {
                
             cell.textLabel.text = [NSString stringWithFormat:@"Описание:  %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"TW"]];
            }
            
            return cell;
        }
            break;
            
        case 2: {
            
            UIView *separetorView = [[UIView alloc] init];
            separetorView.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
            separetorView.frame = CGRectMake(0, CGRectGetMinY([cell bounds]), CGRectGetWidth([cell bounds]), 1);
            [cell.contentView addSubview:separetorView];
            
            if (stringFromDate == NULL) {
                
                NSAttributedString *ph = [[NSAttributedString alloc] initWithString:@"Дата и время события..." attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:0.5] }];
                cell.textLabel.attributedText = ph;
                
            } else {
                
                cell.textLabel.text = [NSString stringWithFormat:@"Дата и время:  %@", stringFromDate];
            }
            
            return cell;
        }
            break;
            
        case 3: {
            
            UIView *separetorView = [[UIView alloc] init];
            separetorView.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
            separetorView.frame = CGRectMake(0, CGRectGetMinY([cell bounds]), CGRectGetWidth([cell bounds]), 1);
            [cell.contentView addSubview:separetorView];
            
            datePicker.frame = CGRectMake(0, 0, CGRectGetWidth([cell bounds]), CGRectGetHeight([cell bounds]));
            [cell.contentView addSubview:datePicker];
            
            return cell;
        }
            break;
            
        case 4: {
                        
            SmallEventCell *cell = (SmallEventCell *)[SmallEventTableView dequeueReusableCellWithIdentifier:@"SmallEventCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SmallEventCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.backgroundColor = [UIColor clearColor];
            
            cell.image.layer.cornerRadius = 5;
            cell.image.clipsToBounds = YES;
            
            CGImageRef cgref = [imageUpload CGImage];
            CIImage *cim = [imageUpload CIImage];
            
            if (cim == nil && cgref == NULL) {
                cell.image.image = [UIImage imageNamed:@"imageupload.png"];
            } else {
                cell.image.image = imageUpload;
            }
            
            return cell;
        }
            break;
            
        case 5: {
            
            SmallEventButton *cell = (SmallEventButton *)[SmallEventTableView dequeueReusableCellWithIdentifier:@"SmallEventButton"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SmallEventButton" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        
            cell.backgroundColor = [UIColor clearColor];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10000);
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (void)dateIsChanged:(id)sender {
   
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"dd MMM HH:mm"];
    
    stringFromDate = [dateformat stringFromDate:[datePicker date]];
    [SmallEventTableView reloadData];
}

- (void)tapSegmentControl:(id)sender {
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        type = @"0";
    } else {
        type = @"1";
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if (indexPath.row == 1) {
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"EditSmallAvent"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
        
    } else if (indexPath.row == 4) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    } else if (indexPath.row == 5) {
        
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"TW"] == nil) {
            [RKDropdownAlert title:@"Ошибка" message:@"Укажите описание события" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:10];
        } else if (stringFromDate == nil) {
            [RKDropdownAlert title:@"Ошибка" message:@"Укажите дату и время события" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:10];
        } else {
            
            NSMutableDictionary *dict0 = [[NSMutableDictionary alloc] init];
            dict0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     
                     type , @"event_type",
                     [[NSUserDefaults standardUserDefaults] stringForKey:@"TW"] , @"description",
                     [[NSUserDefaults standardUserDefaults] stringForKey:@"smallEvent.address"] , @"address",
                     [[NSUserDefaults standardUserDefaults] stringForKey:@"smallEvent.location"], @"position",
                     
                     nil];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", userData.token] forHTTPHeaderField:@"Authorization"];
            
            [manager POST:@"http://motomoto.2-wm.ru/apiv1/events/small/create/" parameters:dict0 progress:nil
             
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      [RKDropdownAlert title:@"Успешно" message:@"Ваше событие создано" backgroundColor:[UIColor colorWithRed:0.17 green:0.54 blue:0.26 alpha:1.0] textColor:[UIColor whiteColor] time:10];
                      
                      
                      CATransition* transition = [CATransition animation];
                      transition.duration = 0.1;
                      transition.type = kCATransitionFade;
                      transition.subtype = kCATransitionFromRight;
                      
                      UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"map"];
                      self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                      
                      [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                      [self.navigationController pushViewController:Place animated:YES];
                  }
             
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      
                      [RKDropdownAlert title:@"Ошибка" message:@"Не удалось создать событие" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:10];
                  }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    imageUpload = image;
    [SmallEventTableView reloadData];
}

@end
