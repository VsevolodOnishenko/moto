//
//  SmallEventView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 28.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SmallEventView.h"

@interface SmallEventView () <GMSMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate> {
    
    SEObject *seObject;
    User *user;
    
    GMSMapView *map;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation SmallEventView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self initUserLocation];
    [self ApplyTableViewStyle];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void) ApplyTableViewStyle {
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.estimatedRowHeight = 100;
}

- (void) initUserLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void) loadData {
    
    NSString *url = [NSString stringWithFormat:@"http://motomoto.2-wm.ru/apiv1/events/small/%@/", [[NSUserDefaults standardUserDefaults] objectForKey:@"se.ID"]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             seObject = [[SEObject alloc] initObjectWithUserID:[[[responseObject valueForKey:@"data"] valueForKey:@"user_id"] intValue]
                                                      latitude:[[[responseObject valueForKey:@"data"] valueForKey:@"latitude"] floatValue]
                                                     longitude:[[[responseObject valueForKey:@"data"] valueForKey:@"longitude"] floatValue]
                                                          time:[[[responseObject valueForKey:@"data"] valueForKey:@"start_time"] doubleValue]
                                                          text:[[responseObject valueForKey:@"data"] valueForKey:@"description"]
                                                          type:[[responseObject valueForKey:@"data"] valueForKey:@"type"]
                                                     creatTime:[[[responseObject valueForKey:@"data"] valueForKey:@"creation_time"] doubleValue]
                         ];
             
             [self.tableView reloadData];
             
             [self loadUserData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"People Error: %@", error);
         }];
}

- (void) loadUserData {
    
    NSString *url = [NSString stringWithFormat:@"http://motomoto.2-wm.ru/apiv1/profile/%d", seObject.UserID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             user = [[User alloc] initUserWithImageURL:[responseObject valueForKey:@"image"]
                                                 fname:[responseObject valueForKey:@"first_name"]
                                                 lname:[responseObject valueForKey:@"last_name"]
                                                    ID:nil];
             
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 150;
    } else if (indexPath.section == 1) {
        return 60;
    } else if (indexPath.section == 2) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.section == 3 ){
        return 100;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0: {
            
            UITableViewCell *cell = (UITableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            GMSCameraPosition *loc = [GMSCameraPosition cameraWithLatitude:seObject.latitude
                                                                 longitude:seObject.longitude
                                                                      zoom:15
                                      ];
            
            map = [GMSMapView mapWithFrame:CGRectMake(0, 0, CGRectGetWidth([cell bounds]), CGRectGetHeight([cell bounds])) camera:loc];
            map.delegate = self;
            [map setUserInteractionEnabled:true];
            
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(seObject.latitude, seObject.longitude);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.map = map;
            marker.icon = [UIImage imageNamed:@"shape_20.png"];
            [cell.contentView addSubview:map];
            
            UIButton *positionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [positionButton addTarget:self
                               action:@selector(placeLocation:)
                     forControlEvents:UIControlEventTouchUpInside];
            positionButton.frame = CGRectMake(CGRectGetMaxX([cell bounds]) * 0.88, CGRectGetMaxY([cell bounds]) * 0.5, 30.0, 30.0);
            UIImage *image = [UIImage imageNamed:@"target button copy.png"];
            [positionButton setImage:image forState:UIControlStateNormal];
            [cell.contentView addSubview:positionButton];
            
            UIButton *pathButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [pathButton addTarget:self
                           action:@selector(pathButtonTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
            pathButton.frame = CGRectMake(CGRectGetMaxX([cell bounds]) * 0.88, CGRectGetMaxY([cell bounds]) * 0.75, 30.0, 30.0);
            pathButton.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:pathButton];
            
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
            
            NSDictionary *dict = @{@"ride" : @"Прохват",
                                   @"meeting" : @"Встреча",
                                   };
            id value = dict[seObject.type];
            cell.title.text = value;
            self.navigationItem.title = value;
            
            CLGeocoder *ceo = [[CLGeocoder alloc]init];
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:seObject.latitude longitude:seObject.longitude];
            
            NSDictionary *dictGeo = [NSDictionary dictionary];
            dictGeo = [NSDictionary dictionaryWithObjectsAndKeys:
                    
                    [NSString stringWithFormat:@"%f", seObject.latitude], @"latitude",
                    [NSString stringWithFormat:@"%f", seObject.longitude], @"longitude",
                    
                    nil];
            
            [ceo reverseGeocodeLocation:loc
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                          
                          CLPlacemark *placemark = [placemarks objectAtIndex:0];
                          if (placemark) {
                              
                              cell.address.text = placemark.name;
                              
                          } else {
                              
                              NSLog(@"Could not locate");
                          }
                      }
             ];
            
            return cell;
        }
            break;
            
        case 2: {
            
            SEUserCell *cell = (SEUserCell *)[tableView dequeueReusableCellWithIdentifier:@"SEUserCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SEUserCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            
            cell.image.layer.cornerRadius = 20;
            cell.image.clipsToBounds = true;
            [cell.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://motomoto.2-wm.ru/%@", user.image_url]]];
            
            cell.title.text = [NSString stringWithFormat:@"%@ %@", user.fname, user.lname];
            
            int timeInterval = seObject.creatTime - 10800;
            NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"dd MMM в HH:mm"];
            cell.time.text = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
            
            cell.body.text = seObject.text;
            
            return cell;
        }
            break;
            
        case 3: {
            
            SEButtonCell *cell = (SEButtonCell *)[tableView dequeueReusableCellWithIdentifier:@"SEButtonCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SEButtonCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            cell.icon.contentMode = UIViewContentModeScaleAspectFill;
            cell.icon.image = [UIImage imageNamed:@"place_info_time.pdf"];
            
            int timeInterval = seObject.time - 10800;
            NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
            [dateformat setDateFormat:@"dd MMM в HH:mm"];
            cell.time.text = [dateformat stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
}

- (IBAction)pathButtonTapped:(UIButton *)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Проложить маршрут до выбранной точки ?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Отмена"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Да", nil];
    
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
    
}

- (IBAction)placeLocation:(UIButton *)sender {
    
    [map animateToLocation:CLLocationCoordinate2DMake(seObject.latitude, seObject.longitude)];
    [map animateToZoom:15];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    
    if (buttonIndex == 0) {
        
        NSString *directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, seObject.latitude, seObject.longitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
    }
}


@end
