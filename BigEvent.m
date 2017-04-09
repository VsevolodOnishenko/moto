//
//  BigEvent.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 20.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "BigEvent.h"

@interface BigEvent () {
    
    NSString *formatTime;
    NSMutableDictionary *info;
    BigEventModel *event;
}

@end

@implementation BigEvent
@synthesize BigEventTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableStyle];
    [self loadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Описание события";
    self.navigationController.navigationBar.topItem.title = @"";
    
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:false animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableStyle {
    
    BigEventTableView.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    BigEventTableView.separatorColor = [UIColor clearColor];
    BigEventTableView.estimatedRowHeight = 50;
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor whiteColor]];
}

- (void) loadData {
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/bigEvents.get?id=%@&fields=image,title,description,contacts,address,start_time",
        [[NSUserDefaults standardUserDefaults] objectForKey:@"user.id"]];//спросить нужно ли использовать token
        [manager GET: url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
             NSLog(@"Response object is %@", responseObject);
        
                 event = [[BigEventModel alloc] initWithImage:[[responseObject valueForKey:@"data"] valueForKey:@"image"]
                                                title:[[responseObject valueForKey:@"data"] valueForKey:@"title"]
                                                descr:[[responseObject valueForKey:@"data"] valueForKey:@"description"]
                                             contacts:[[responseObject valueForKey:@"data"] valueForKey:@"contacts"]
                                              address:[[responseObject valueForKey:@"data"] valueForKey:@"address"]
                                                 time:[[responseObject valueForKey:@"data"] valueForKey:@"start_time"]
        
                  ];
    
         info = [NSMutableDictionary dictionary];
         [info addEntriesFromDictionary:event.contacts];
         
         if (!(event.time == nil)) {
             
             int timeInterval = [event.time intValue] - 10800;
             NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
             [dateformat setDateFormat:@"dd MMM в HH:mm"];
             formatTime = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
         }
        
         [BigEventTableView reloadData];
     }
         failure:^(NSURLSessionTask *operation, NSError *error){
         NSLog(@"Error: %@", error);
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return info.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    } else if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.section == 2) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.section == 3) {
        return 30;
    } else {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *) [BigEventTableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    
    EventViewInfoCell *cellInfo = (EventViewInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"EventViewInfoCell"];
    if (cellInfo == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventViewInfoCell" owner:self options:nil];
        cellInfo = [nib objectAtIndex:0];
    }
    
    cellInfo.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.section) {
        case 0: {
            
            EventViewHeaderCell *cell = (EventViewHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"EventViewHeaderCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventViewHeaderCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://motomoto.2-wm.ru/apiv1", event.image]]];
            return cell;
        }
            break;
            
        case 1: {
            
            EventTitleCell *cell = (EventTitleCell *)[tableView dequeueReusableCellWithIdentifier:@"EventTitleCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventTitleCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            cell.title.text = event.title;
            cell.address.text = event.address;
            return cell;
        }
            
        case 2: {
            
            cell.textLabel.text = event.descr;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
            return cell;
        }
            break;
            
        case 3: {
            
            cellInfo.title.text = formatTime;
            cellInfo.icon.image = [UIImage imageNamed:@"place_info_time.pdf"];
            return cellInfo;
        }
            break;
            
        case 4: {
            
            NSArray *keys = [info allKeys];
            id key = [keys objectAtIndex:indexPath.row];
            id obj = [info objectForKey:key];
            cellInfo.title.text = obj;
            
            cellInfo.icon.contentMode = UIViewContentModeScaleAspectFit;
            
            NSDictionary *dict = @{@"phone" : @"place_info_phone.pdf",
                                   @"email" : @"place_info_mail.pdf",
                                   @"site" : @"place_info_net.pdf",
                                   @"facebook" : @"place_info_fb.pdf",
                                   @"vk" : @"map_info_vk.pdf",
                                   @"instagram" : @"Instagram_Color.png"
                                   };
            
            cellInfo.icon.image = [UIImage imageNamed:dict[key]];
            
            return cellInfo;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if (indexPath.section == 4) {
     
        NSArray *keys = [info allKeys];
        id key = [keys objectAtIndex:indexPath.row];
        
        if ([key isEqualToString:@"site"] || [key isEqualToString:@"facebook"] || [key isEqualToString:@"vk"] || [key isEqualToString:@"instagram"]) {
            
            NSString *url = [NSString stringWithFormat:@"%@", [info objectForKey:key]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        } else if ([key isEqualToString:@"phone"]) {
            
            NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            NSString *originalNumber = [[[info objectForKey:key] componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
            
            NSString *string = [NSString stringWithFormat:@"telprompt://%@", originalNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }
    }
}

@end
