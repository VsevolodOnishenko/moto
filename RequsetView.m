//
//  RequsetView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 04.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "RequsetView.h"

@interface RequsetView () <UITableViewDelegate, UITableViewDataSource> {
    
    bool isLoaded;
    
    bool isLoadedOut;
    bool isLoadedIn;
    
    bool isCanceled;
    bool isAdded;
    bool isCanceledSelf;
    
    OutcomeReqObj *outcomeReqObj;
    IncomeReqObj *incomeReqObj;
    
    UserData *data;
    
    RKDropdownAlert *alert;
}

@end

@implementation RequsetView

@synthesize tableViewRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableViewStyle];
    
    [self getUserData];
    
    [self getIncomingRequestListData];
    [self getOutcomingRequestListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableViewStyle {
    
    self.tableViewRequest.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableViewRequest.separatorColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    self.tableViewRequest.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

- (void) getIncomingRequestListData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data.token, @"token",
            @"incoming", @"type",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/friends.getRequests" parameters:dict progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                       
             incomeReqObj = [[IncomeReqObj alloc] initUserWithImage:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"image"]
                                                              fname:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"first_name"]
                                                              lname:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"last_name"]
                                                              ident:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"id"]
                                                               time:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"time"]
                             ];
             
             isLoaded = true;
             isLoadedIn = true;
             [self.tableViewRequest reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error: %@", error);
         }];
}

- (void) getOutcomingRequestListData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data.token, @"token",
            @"outcoming", @"type",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/friends.getRequests" parameters:dict progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             outcomeReqObj = [[OutcomeReqObj alloc] initUserWithImage:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"image"]
                                                                fname:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"first_name"]
                                                                lname:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"last_name"]
                                                                ident:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"user"] valueForKey:@"id"]
                                                                 time:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"time"]
                              ];
             
             isLoaded = true;
             isLoadedOut = true;
             [self.tableViewRequest reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error: %@", error);
         }];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Входящие";
    } else {
        return @"Исходящие";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isLoaded == true) {
        
        if (section == 0) {
            
            if (incomeReqObj.ident.count == 0) {
                return 1;
            } else {
                return incomeReqObj.ident.count;
            }
            
        } else {
            
            if (outcomeReqObj.ident.count == 0) {
                return 1;
            } else {
                return outcomeReqObj.ident.count;
            }
        }
        
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            
            if (incomeReqObj.ident.count == 0) {
                
                UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                
                cell.textLabel.text = @"Нет входящий заявок";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
                
                return cell;
                
            } else {
                
                if (isLoadedIn == true) {
                    
                    InComeReqCell *cell = (InComeReqCell *)[tableView dequeueReusableCellWithIdentifier:@"InComeReqCell"];
                    if (cell == nil) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InComeReqCell" owner:self options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    cell.backgroundColor = [UIColor clearColor];
                    
                    cell.image.layer.cornerRadius = 25;
                    cell.image.clipsToBounds = YES;
                    
                    cell.name.text = [NSString stringWithFormat:@"%@ %@", [incomeReqObj.fname objectAtIndex:indexPath.row], [incomeReqObj.lname objectAtIndex:indexPath.row]];
                    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [incomeReqObj.image objectAtIndex:indexPath.row], @"_list.jpg"]]];
                    
                    double timeInterval = [[incomeReqObj.time objectAtIndex:indexPath.row] doubleValue] - 10800;
                    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
                    [dateformat setDateFormat:@"dd MMM HH:mm"];
                    cell.time.text = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
                    
                    [fabriqStyleView ApplyStyleView_CornerShadow:cell.addRequest cornerRaduis:0 shadowOffSetX:1 shadowOffSetY:1 shadowRaduis:1 shadowOpacity:1 maskToBounds:NO];
                    [fabriqStyleView ApplyStyleView_CornerShadow:cell.cancelRequest cornerRaduis:0 shadowOffSetX:1 shadowOffSetY:1 shadowRaduis:1 shadowOpacity:1 maskToBounds:NO];
                    
                    [cell.addRequest addTarget:self action:@selector(addRequest:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.cancelRequest addTarget:self action:@selector(cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (isAdded == true) {
                        [cell.addRequest setTitle:@"Добавлен" forState:UIControlStateNormal];
                        cell.cancelRequest.hidden = true;
                    }
                    
                    if (isCanceled == true) {
                        [cell.addRequest setTitle:@"Отменена" forState:UIControlStateNormal];
                        cell.cancelRequest.hidden = true;
                    }
                    
                    return cell;
                } else {
                    return nil;
                }
            }
        }
            break;
            
        case 1: {
            
            if (outcomeReqObj.ident.count == 0) {
                
                UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                
                cell.textLabel.text = @"Нет исходящий заявок";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
                
                return cell;
                
            } else {
                
                if (isLoadedOut == true) {
                    
                    OutComeReqCell *cell = (OutComeReqCell *)[tableView dequeueReusableCellWithIdentifier:@"OutComeReqCell"];
                    if (cell == nil) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OutComeReqCell" owner:self options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    cell.backgroundColor = [UIColor clearColor];
                    
                    cell.image.layer.cornerRadius = 25;
                    cell.image.clipsToBounds = YES;
                    
                    cell.name.text = [NSString stringWithFormat:@"%@ %@", [outcomeReqObj.fname objectAtIndex:indexPath.row], [outcomeReqObj.lname objectAtIndex:indexPath.row]];
                    [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [outcomeReqObj.image objectAtIndex:indexPath.row], @"_list.jpg"]]];
                    
                    double timeInterval = [[outcomeReqObj.time objectAtIndex:indexPath.row] doubleValue] - 10800;
                    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
                    [dateformat setDateFormat:@"dd MMM HH:mm"];
                    cell.time.text = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
                    
                    [cell.cancelReq addTarget:self action:@selector(cancelReq:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (isCanceledSelf == true) {
                        [cell.cancelReq setTitle:@"Отменена" forState:UIControlStateNormal];
                    }
                    
                    return cell;
                    
                } else {
                    return nil;
                }
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void) addRequest:(UIButton *)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewRequest];
    NSIndexPath *indexPath = [self.tableViewRequest indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        
            data.token, @"token",
            [incomeReqObj.ident objectAtIndex:indexPath.row], @"user_id",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://moto.2-wm.ru/apiv2/friends.add" parameters:dict progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if ([[[responseObject valueForKey:@"data"] valueForKey:@"friendship_status"] isEqualToString:@"friend"]) {
                 
                 if (alert.isShowing == 0) {
                     
                     [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                     [RKDropdownAlert title:@"Успешно" message:@"Вы приняли заявку" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                 }
                 
                 isAdded = true;
                 [self.tableViewRequest reloadData];
                 
             } else {
                 
                 if (alert.isShowing == 0) {
                     
                     [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                     [RKDropdownAlert title:@"Ошибка" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                 }
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (alert.isShowing == 0) {
                 
                 [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                 [RKDropdownAlert title:@"Ошибка" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
             }
         }];
}

- (void) cancelRequest:(UIButton *)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewRequest];
    NSIndexPath *indexPath = [self.tableViewRequest indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data.token, @"token",
            [incomeReqObj.ident objectAtIndex:indexPath.row], @"user_id",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://moto.2-wm.ru/apiv2/friends.remove" parameters:dict progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             if (alert.isShowing == 0) {
                 
                 [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                 [RKDropdownAlert title:@"Успешно" message:@"Вы отклонили заявку" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
             }
             
             isCanceledSelf = true;
             [self.tableViewRequest reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (alert.isShowing == 0) {
                 
                 [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                 [RKDropdownAlert title:@"Ошибка" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
             }
         }];
}

- (void) cancelReq:(UIButton *)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewRequest];
    NSIndexPath *indexPath = [self.tableViewRequest indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            data.token, @"token",
            [outcomeReqObj.ident objectAtIndex:indexPath.row], @"user_id",
            
            nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://moto.2-wm.ru/apiv2/friends.remove" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if (alert.isShowing == 0) {
                  
                  [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Успешно" message:@"Заявка отменена" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
              }
              
              isCanceledSelf = true;
              [self.tableViewRequest reloadData];
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              if (alert.isShowing == 0) {
                  
                  [alert title:@"" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
                  [RKDropdownAlert title:@"Ошибка" message:@"" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:2];
              }
          }];
}

@end
