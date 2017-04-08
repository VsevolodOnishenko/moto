//
//  PlaceMap.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 10.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "PlaceMap.h"

@interface PlaceMap () <GMSMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate> {
    
    PlaceMapModel *place;
    
    NSMutableDictionary *info;
    NSString *formatTime;
    
    NSString *model;
    
    NSString *URLAlbumImage;
    NSArray *countImage;
    
    NSMutableArray *timesStart;
    NSMutableArray *timesEnd;
    NSString *formattedTime;
    
    bool isSelectedShedule;
    
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

static const float kformatTime = 2.77777777777778 * 0.0000001;

@implementation PlaceMap

@synthesize PlaceMapTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initActivityIndicatorView];
    
    [self initUserLocation];
    
    [self checkiPhoneModel];
    [self ApplyTableViewStyle];
    
    [self loadData];
    [self loadImage];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
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


- (void) initUserLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void) checkiPhoneModel {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    model = [self platformType:platform];
    
    free(machine);
}

- (NSString *) platformType:(NSString *)platform {
    
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";

    return platform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Описание места";
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void) ApplyTableViewStyle {
    
    PlaceMapTableView.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
    PlaceMapTableView.separatorColor = [UIColor clearColor];
    PlaceMapTableView.estimatedRowHeight = 40;
}

- (void) loadData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[[NSUserDefaults standardUserDefaults] stringForKey:@"place.url"] parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             place = [[PlaceMapModel alloc] initPlaceMapWithTitle:[[responseObject valueForKey:@"data"] valueForKey:@"name"]
                                                             body:[[responseObject valueForKey:@"data"] valueForKey:@"description"]
                                                         category:[[[responseObject valueForKey:@"data"] valueForKey:@"services"] allObjects]
                                                            image:[[[[responseObject valueForKey:@"data"] valueForKey:@"photos"] valueForKey:@"image"] allObjects]
                                                         contacts:[[responseObject valueForKey:@"data"] valueForKey:@"contacts"]
                                                          shedule:[[responseObject valueForKey:@"data"] valueForKey:@"schedule"]
                                                              lng:[[[responseObject valueForKey:@"data"] valueForKey:@"longitude"] floatValue]
                                                              ltd:[[[responseObject valueForKey:@"data"] valueForKey:@"latitude"] floatValue]
                      ];
             
            [PlaceMapTableView reloadData];
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 
                 info = [NSMutableDictionary dictionary];
                 [info addEntriesFromDictionary:place.contacts];
                
                 NSArray *week = @[@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday"];
                 
                 timesStart = [[NSMutableArray alloc] init];
                 timesEnd = [[NSMutableArray alloc] init];
                 
                 for (NSString *day in week) {
                     
                     float timeStartJSON = [[[[[place.shedule valueForKey:day] allObjects] firstObject] firstObject] doubleValue];
                     float timeEndJSON = [[[[[place.shedule valueForKey:day] allObjects] firstObject] lastObject] doubleValue];
                     
                     float fotmattedTimeStart = kformatTime * timeStartJSON;
                     float formattedTimeEnd = kformatTime * timeEndJSON;
                     
                     NSNumber *timeStart = [NSNumber numberWithFloat:fotmattedTimeStart];
                     NSNumber *timeEnd = [NSNumber numberWithFloat:formattedTimeEnd];
                     
                     [timesStart addObject:timeStart];
                     [timesEnd addObject:timeEnd];
                 }
                 
                 NSDate *todayDate = [NSDate date];
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"EEEE"];
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"понедельник"]) {
                     if ([timesStart objectAtIndex:0] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:0] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:0], [timesEnd objectAtIndex:0]];
                     }
                 }
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"вторник"]) {
                     if ([timesStart objectAtIndex:1] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:1] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:1], [timesEnd objectAtIndex:1]];
                     }
                 }
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"среда"]) {
                     if ([timesStart objectAtIndex:2] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:2] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:2], [timesEnd objectAtIndex:2]];
                     }
                 }
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"четверг"]) {
                     if ([timesStart objectAtIndex:3] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:3] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:3], [timesEnd objectAtIndex:3]];
                     }
                 }
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"пятница"]) {
                     if ([timesStart objectAtIndex:4] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:5] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:4], [timesEnd objectAtIndex:4]];
                     }
                 }
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"суббота"]) {
                     if ([timesStart objectAtIndex:5] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:5] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:5], [timesEnd objectAtIndex:5]];
                     }
                 }
                 
                 if ([[dateFormatter stringFromDate:todayDate] isEqualToString:@"воскресенье"]) {
                     if ([timesStart objectAtIndex:6] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else if ([timesEnd objectAtIndex:6] == [NSNumber numberWithFloat:0]) {
                         formattedTime = @"Часы работы неизвестны";
                     } else {
                         formattedTime = [NSString stringWithFormat:@"Сегодня: %@.00 - %@.00", [timesStart objectAtIndex:6], [timesEnd objectAtIndex:6]];
                     }
                 }
                 
                     [PlaceMapTableView reloadData];
             });
             
             [self hideActivityIndicatorView];
         }
     
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void) loadImage {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[[NSUserDefaults standardUserDefaults] stringForKey:@"place.image.url"] parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             NSString *obj0 = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] firstObject] firstObject];
             NSString *obj1 = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] firstObject] lastObject];
             
             if ([obj0 isKindOfClass:[NSNumber class]]) {
                 URLAlbumImage = obj1;
             } else if ([obj1 isKindOfClass:[NSNumber class]]) {
                 URLAlbumImage = obj0;
             }
            
             [PlaceMapTableView reloadData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return place.contacts.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else if ((indexPath.section == 5) && (isSelectedShedule == true)) {
        return 240;
    } else if (indexPath.section == 6) {
        return 120;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0: {
            
            ImagePlaceCell *cell0 = (ImagePlaceCell *)[tableView dequeueReusableCellWithIdentifier:@"ImagePlaceCell"];
            if (cell0 == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImagePlaceCell" owner:self options:nil];
                cell0 = [nib objectAtIndex:0];
            }
            cell0.backgroundColor = [UIColor clearColor];
            
            [cell0.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://motomoto.2-wm.ru/%@", URLAlbumImage]]];
            
            return cell0;
        }
            break;
            
        case 1: {
            
            EventTitleCell *cell = (EventTitleCell *)[tableView dequeueReusableCellWithIdentifier:@"EventTitleCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventTitleCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            cell.title.text = place.title;
            cell.address.text = @"г.Санкт - Петербург";
            
            return cell;
        }
            break;
            
        case 2: {
            
            UITableViewCell *cell = (UITableViewCell *) [PlaceMapTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            if ([model isEqualToString:@"iPhone SE"]) {
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:15];
            } else {
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
            }
            
            [cell.textLabel sizeToFit];
            cell.textLabel.numberOfLines = 0;
            
            cell.textLabel.text = place.body;
            
            return cell;
        }
            break;
            
        case 3: {
            
            NSDictionary *dict = @{@"bar" : @"Бар",
                                   @"fuel" : @"Заправка",
                                   @"store" : @"Магазин",
                                   @"place" : @"Место встречи",
                                   @"restaurant" : @"Ресторан",
                                   @"repair" : @"Ремонт",
                                   @"school" : @"Мотошкола"
                                   };
            
            NSMutableArray *ad = [[NSMutableArray alloc] init];
            
            for (NSString *category in place.category) {
                
                NSUInteger count = [place.category indexOfObject:category];
                id value = dict[[place.category objectAtIndex:count]];
                
                [ad addObject:value];
            }
            
            UITableViewCell *cell = (UITableViewCell *) [PlaceMapTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            if ([model isEqualToString:@"iPhone SE"]) {
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:15];
            } else {
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
            }
            
            [cell.textLabel sizeToFit];
            cell.textLabel.numberOfLines = 0;
            
            cell.textLabel.text = [ad componentsJoinedByString:@" - "];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            cell.textLabel.textColor = [UIColor colorWithRed:0.77 green:0.82 blue:0.87 alpha:1.0];
            
            return cell;
        }
            break;
            
        case 4: {
            
            EventViewInfoCell *cell = (EventViewInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"EventViewInfoCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EventViewInfoCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.backgroundColor = [UIColor clearColor];
            cell.icon.contentMode = UIViewContentModeScaleAspectFit;
            
            if (!(info == nil)) {
                
                NSArray *keys = [info allKeys];
                id key = [keys objectAtIndex:indexPath.row];
                id obj = [info objectForKey:key];
                cell.title.text = obj;
                
                NSDictionary *dict = @{@"phone" : @"place_info_phone.pdf",
                                       @"email" : @"place_info_mail.pdf",
                                       @"site" : @"place_info_net.pdf",
                                       @"facebook" : @"place_info_fb.pdf",
                                       @"vk" : @"map_info_vk.pdf",
                                       @"instagram" : @"Instagram_Color.png"
                                       };
                
                cell.icon.image = [UIImage imageNamed:dict[key]];
            }
            
            return cell;
        }
            break;
            
        case 5: {
            
            PlaceSheduleCell *cell = (PlaceSheduleCell *)[tableView dequeueReusableCellWithIdentifier:@"PlaceSheduleCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlaceSheduleCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1.0];
            
            cell.todaysTime.text = formattedTime;
            cell.icon.image = [UIImage imageNamed:@"place_info_time.pdf"];
            
            if ([timesStart objectAtIndex:0] == [NSNumber numberWithFloat:0]) {
                cell.time_0.text = @"Пн. -";
            } else if ([timesEnd objectAtIndex:0] == [NSNumber numberWithFloat:0]) {
                cell.time_0.text = @"Пн. -";
            } else {
                cell.time_0.text = [NSString stringWithFormat:@"Пн. %@.00 - %@.00", [timesStart objectAtIndex:0], [timesEnd objectAtIndex:0]];
            }
            
            if ([timesStart objectAtIndex:0] == [NSNumber numberWithFloat:1]) {
                cell.time_1.text = @"Вт. -";
            } else if ([timesEnd objectAtIndex:0] == [NSNumber numberWithFloat:1]) {
                cell.time_1.text = @"Вт. -";
            } else {
                cell.time_1.text = [NSString stringWithFormat:@"Вт. %@.00 - %@.00", [timesStart objectAtIndex:1], [timesEnd objectAtIndex:1]];
            }
            
            if ([timesStart objectAtIndex:2] == [NSNumber numberWithFloat:0]) {
                cell.time_2.text = @"Ср. -";
            } else if ([timesEnd objectAtIndex:2] == [NSNumber numberWithFloat:0]) {
                cell.time_2.text = @"Ср. -";
            } else {
                cell.time_2.text = [NSString stringWithFormat:@"Ср. %@.00 - %@.00", [timesStart objectAtIndex:2], [timesEnd objectAtIndex:2]];
            }
            
            if ([timesStart objectAtIndex:3] == [NSNumber numberWithFloat:0]) {
                cell.time_3.text = @"Чт. -";
            } else if ([timesEnd objectAtIndex:4] == [NSNumber numberWithFloat:0]) {
                cell.time_3.text = @"Чт. -";
            } else {
                cell.time_3.text = [NSString stringWithFormat:@"Чт. %@.00 - %@.00", [timesStart objectAtIndex:3], [timesEnd objectAtIndex:3]];
            }
            
            if ([timesStart objectAtIndex:4] == [NSNumber numberWithFloat:0]) {
                cell.time_4.text = @"Пт. -";
            } else if ([timesEnd objectAtIndex:4] == [NSNumber numberWithFloat:0]) {
                cell.time_4.text = @"Пт. -";
            } else {
                cell.time_4.text = [NSString stringWithFormat:@"Пт. %@.00 - %@.00", [timesStart objectAtIndex:4], [timesEnd objectAtIndex:4]];
            }
            
            if ([timesStart objectAtIndex:5] == [NSNumber numberWithFloat:0]) {
                cell.time_5.text = @"Сб. -";
            } else if ([timesEnd objectAtIndex:5] == [NSNumber numberWithFloat:0]) {
                cell.time_5.text = @"Сб. -";
            } else {
                cell.time_5.text = [NSString stringWithFormat:@"Сб. %@.00 - %@.00", [timesStart objectAtIndex:5], [timesEnd objectAtIndex:5]];
            }
            
            if ([timesStart objectAtIndex:6] == [NSNumber numberWithFloat:0]) {
                cell.time_6.text = @"Вс. -";
            } else if ([timesEnd objectAtIndex:6] == [NSNumber numberWithFloat:0]) {
                cell.time_6.text = @"Вс. -";
            } else {
                cell.time_6.text = [NSString stringWithFormat:@"Вс. %@.00 - %@.00", [timesStart objectAtIndex:6], [timesEnd objectAtIndex:6]];
            }
            
            if (isSelectedShedule == true) {
                
                cell.time_0.hidden = false;
                cell.time_1.hidden = false;
                cell.time_2.hidden = false;
                cell.time_3.hidden = false;
                cell.time_4.hidden = false;
                cell.time_5.hidden = false;
                cell.time_6.hidden = false;
                
            } else {
                
                cell.time_0.hidden = true;
                cell.time_1.hidden = true;
                cell.time_2.hidden = true;
                cell.time_3.hidden = true;
                cell.time_4.hidden = true;
                cell.time_5.hidden = true;
                cell.time_6.hidden = true;
            }
                        
            return cell;
        }
            break;
            
        case 6: {
            
            UITableViewCell *mapCell = (UITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cellMap" forIndexPath:indexPath];
            
            GMSCameraPosition *loc = [GMSCameraPosition cameraWithLatitude:place.ltd
                                                                 longitude:place.lng
                                                                      zoom:15
                                      ];
            
            GMSMapView *map = [GMSMapView mapWithFrame:CGRectMake(0, 0, CGRectGetWidth([mapCell bounds]), CGRectGetHeight([mapCell bounds])) camera:loc];
            map.delegate = self;
            [map setUserInteractionEnabled:false];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(place.ltd, place.lng);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.map = map;
            marker.icon = [UIImage imageNamed:@"shape_20.png"];
            [mapCell.contentView addSubview:map];
            
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, CGRectGetWidth([mapCell bounds]), CGRectGetHeight([mapCell bounds]));
            view.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:0.3];
            [mapCell.contentView addSubview:view];
            
            UILabel *lbl = [[UILabel alloc] init];
            lbl.frame = CGRectMake(0, 0, CGRectGetWidth([mapCell bounds]), 40);
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"Нажмите, чтобы проложить маршрут";
            lbl.textColor = [UIColor whiteColor];
            lbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            [mapCell.contentView addSubview:lbl];
            
            return mapCell;
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
    
    if (indexPath.section == 5) {
        
        if (indexPath.row == 0) {
            
            if (isSelectedShedule == false) {
                
                isSelectedShedule = true;
                
                [tableView beginUpdates];
                [tableView endUpdates];
                
                NSArray *ip = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:5]];
                [self.tableView reloadRowsAtIndexPaths:ip withRowAnimation:UITableViewRowAnimationNone];
                
            } else {
                
                isSelectedShedule = false;
                
                [tableView beginUpdates];
                [tableView endUpdates];
                
                NSArray *ip = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:5]];
                [self.tableView reloadRowsAtIndexPaths:ip withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    
    if (indexPath.section == 6) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Проложить маршрут до выбранной точки ?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Отмена"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Да", nil];
        
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    
    if (buttonIndex == 0) {
        
        NSString *directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, place.ltd, place.lng];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
    }
}


@end
