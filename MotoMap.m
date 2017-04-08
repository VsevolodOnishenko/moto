//
//  MotoMap.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.10.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MotoMap.h"

@import GoogleMaps;

@interface MotoMap () <UIGestureRecognizerDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate, UITextFieldDelegate, CLLocationManagerDelegate> {
    
    UIView *iconContainer;
    UIImageView *icon;
    
    CGPoint touchPoint;
    CLLocationCoordinate2D location;
    
    BOOL isEditingEvent;
    BOOL islookingUsers;
    
    CATransition *aFade;
    CATransition *aPushBottom;
    CATransition *aPushTop;
    CATransition *aPushRight;
    CATransition *aPushLeft;
    
    GMSMapView *mapView;
    
    GMUClusterManager *clusterManagerPeople;
    GMUClusterManager *clusterManagerEvent;
    
    GMUClusterManager *clusterPlaceCategoryParking;
    GMUClusterManager *clusterPlaceCategoryGaz;
    GMUClusterManager *clusterPlaceCategoryService;
    GMUClusterManager *clusterPlaceCategoryShop;
    GMUClusterManager *clusterPlaceCategoryRestoraunt;
    GMUClusterManager *clusterPlaceCategoryCafe;
    GMUClusterManager *clusterPlaceCategoryBar;
    GMUClusterManager *clusterPlaceCategorySchool;
    GMUClusterManager *clusterPlaceCategoryPeople;
    
    bool categoryPeople;
    bool categoryEvent;
    
    bool categoryParking;
    bool categoryGaz;
    bool categoryService;
    bool categoryShop;
    bool categoryRestoraunt;
    bool categoryCafe;
    bool categoryBar;
    bool categorySchool;
    
    NSNumber *placeLongitude;
    NSNumber *placeLatitude;
    
    UISwipeGestureRecognizer *swipeDown;
    
    UIView *viewContainer;
    UIView *viewMain;
    
    PlaceObjectJSON *placeObjJSON;
    UserObjJSON *userObjJSON;
    EventObjectJSON *eventObjJSON;
    
    NSMutableArray *iconsPlaces;
    NSMutableArray *iconsEvents;
    
    id <GMUClusterItem> itemEvents;
    id <GMUClusterItem> itemUsers;
    id <GMUClusterItem> itemPlaces;
    
    User_object *user_obj;
    Place_object *place_obj;
    Event_object *event_obj;
    
    UIImageView *iconview;
    UIImageView *placeview;
    NSString *userIcon;
    NSString *checkIcon;
    
    UIView *placeView;
    
    UIActivityIndicatorView *spinner;
        
    UITableView *PlaceTableView;
    
    UIView *viewblur;
    
    NSMutableArray *shedule;
    
    NSURL *styleUrl;
    
    NSString *data_id;
    NSString *data_token;
    
    int event_type_creat;
    NSDictionary *dict;
    
    UITapGestureRecognizer *tap;
    UISwipeGestureRecognizer *leftSwipe;
    
    bool isNeedCancelSmallEvent;
    
    UIButton *button;
}

@property (weak, nonatomic) IBOutlet XXXRoundMenuButton *roundMenu;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isOpened;

@end

@implementation MotoMap 

@synthesize sidebarButton, roundMenu, headerView, headerViewTitle, launchPlaceView, launchPlaceView_title, addingSmallEvent_lbl, addingSmallEventView, rightBarButton, addingSmallEvent_btn, contentView;

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideBarButtonAction) name:@"tapped" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonClicked) name:@"Clicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ButtonUnClicked) name:@"UnClicked" object:nil];
    
    [self getUserData];
    
    [self initUserLocation];
    [self initMap];
    [self setFilterSetting];
    
    [self setRoundMenu];
    [self setRevealSlideMenu];
    [self setShadowCornerView];
    [self setAnimationTypes];
    
    [self initCluster];
    [self initFilterSelector];
    
    [self initUserLocationButton];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Moto - Moto";
}

- (void) initCluster {
    
    id <GMUClusterAlgorithm> algorithmPeople = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorPeople = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererPeople = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                    clusterIconGenerator:iconGeneratorPeople];
    clusterManagerPeople = [[GMUClusterManager alloc] initWithMap:mapView
                                                  algorithm:algorithmPeople
                                                   renderer:rendererPeople];
    [clusterManagerPeople setDelegate:self mapDelegate:self];
    
    id <GMUClusterAlgorithm> algorithmEvent = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorEvent = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererEvent = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                           clusterIconGenerator:iconGeneratorEvent];
    clusterManagerEvent = [[GMUClusterManager alloc] initWithMap:mapView
                                                        algorithm:algorithmEvent
                                                         renderer:rendererEvent];
    [clusterManagerEvent setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmParking = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorParking = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererParking = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                        clusterIconGenerator:iconGeneratorParking];
    clusterPlaceCategoryParking = [[GMUClusterManager alloc] initWithMap:mapView
                                                               algorithm:algorithmParking
                                                                renderer:rendererParking];
    [clusterPlaceCategoryParking setDelegate:self mapDelegate:self];
    
    
    
    id <GMUClusterAlgorithm> algorithmGaz = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorGaz = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererGaz = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                     clusterIconGenerator:iconGeneratorGaz];
    clusterPlaceCategoryGaz = [[GMUClusterManager alloc] initWithMap:mapView
                                                               algorithm:algorithmGaz
                                                                renderer:rendererGaz];
    [clusterPlaceCategoryGaz setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmService = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorService = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererService = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                        clusterIconGenerator:iconGeneratorService];
    clusterPlaceCategoryService = [[GMUClusterManager alloc] initWithMap:mapView
                                                           algorithm:algorithmService
                                                            renderer:rendererService];
    [clusterPlaceCategoryService setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmShop = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorShop = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererShop = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                        clusterIconGenerator:iconGeneratorShop];
    clusterPlaceCategoryShop = [[GMUClusterManager alloc] initWithMap:mapView
                                                               algorithm:algorithmShop
                                                                renderer:rendererShop];
    [clusterPlaceCategoryShop setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmRestoraunt = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorRestoraunt = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererRestoraunt = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                         clusterIconGenerator:iconGeneratorRestoraunt];
    clusterPlaceCategoryRestoraunt = [[GMUClusterManager alloc] initWithMap:mapView
                                                            algorithm:algorithmRestoraunt
                                                             renderer:rendererRestoraunt];
    [clusterPlaceCategoryRestoraunt setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmCafe = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorCafe = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererCafe = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                               clusterIconGenerator:iconGeneratorCafe];
    clusterPlaceCategoryCafe = [[GMUClusterManager alloc] initWithMap:mapView
                                                                  algorithm:algorithmCafe
                                                                   renderer:rendererCafe];
    [clusterPlaceCategoryCafe setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmBar = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorBar = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererBar = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                         clusterIconGenerator:iconGeneratorBar];
    clusterPlaceCategoryBar = [[GMUClusterManager alloc] initWithMap:mapView
                                                            algorithm:algorithmBar
                                                             renderer:rendererBar];
    [clusterPlaceCategoryBar setDelegate:self mapDelegate:self];
    
    
    id <GMUClusterAlgorithm> algorithmSchool = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id <GMUClusterIconGenerator> iconGeneratorSchool = [[GMUDefaultClusterIconGenerator alloc] init];
    id <GMUClusterRenderer> rendererSchool = [[GMUDefaultClusterRenderer alloc] initWithMapView:mapView
                                                                        clusterIconGenerator:iconGeneratorSchool];
    clusterPlaceCategorySchool = [[GMUClusterManager alloc] initWithMap:mapView
                                                           algorithm:algorithmSchool
                                                            renderer:rendererSchool];
    [clusterPlaceCategorySchool setDelegate:self mapDelegate:self];
    
    
    [self initPlaces];
    [self initPeople];
    [self initEvents];
}

- (void) initFilterSelector {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryParkingOn) name:@"categoryParkingOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryParkingOff) name:@"categoryParkingOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryGazOn) name:@"categoryGazOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryGazOff) name:@"categoryGazOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryServiceOn) name:@"categoryServiceOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryServiceOff) name:@"categoryServiceOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryShopOn) name:@"categoryShopOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryShopOff) name:@"categoryShopOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryRestorauntOn) name:@"categoryRestorauntOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryRestorauntOff) name:@"categoryRestorauntOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryCafeOn) name:@"categoryCafeOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryCafeOff) name:@"categoryCafeOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryBarOn) name:@"categoryBarOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryBarOff) name:@"categoryBarOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorySchoolOn) name:@"categorySchoolOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorySchoolOff) name:@"categorySchoolOff" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryEventsOn) name:@"categoryEventOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryEventsOff) name:@"categoryEventOff" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryPeopleOn) name:@"categoryPeopleOn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryPeopleOff) name:@"categoryPeopleOff" object:nil];
}

- (void) setFilterSetting {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.0"])  {
        categoryParking = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.1"]) {
        categoryGaz = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.2"]) {
        categoryService = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.3"]) {
        categoryShop = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.4"]) {
        categoryRestoraunt = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.5"]) {
        categoryCafe = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.6"]) {
        categoryBar = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.7"]) {
        categorySchool = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.8"]) {
        categoryPeople = true;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"select.9"]) {
        categoryEvent = true;
    }
}


- (void) categoryPeopleOn {
    categoryPeople = true;
    [self generateClusterItems_users];
}

- (void) categoryPeopleOff {
    
    categoryPeople = false;
    [clusterManagerPeople clearItems];
    [clusterManagerPeople removeItem:user_obj];
}

- (void) categoryEventsOn {
    categoryEvent = true;
    [self generateClusterItems_events];
}

- (void) categoryEventsOff {
    
    categoryEvent = false;
    [clusterManagerEvent clearItems];
    [clusterManagerEvent removeItem:event_obj];
}

- (void) categoryParkingOn {
    categoryParking = true;
    [self generateClusterItemsParkingObject];
}

- (void) categoryParkingOff {
    
    categoryParking = false;
    [clusterPlaceCategoryParking clearItems];
    [clusterPlaceCategoryParking removeItem:place_obj];
}

- (void) categoryGazOn {
    categoryGaz = true;
    [self generateClusterItemsGazObject];
}

- (void) categoryGazOff {
    
    categoryGaz = false;
    [clusterPlaceCategoryGaz clearItems];
    [clusterPlaceCategoryGaz removeItem:place_obj];
}

- (void) categoryServiceOn {
    categoryService = true;
    [self generateClusterItemsRepairObject];
}

- (void) categoryServiceOff {
    
    categoryService = false;
    [clusterPlaceCategoryService clearItems];
    [clusterPlaceCategoryService removeItem:place_obj];
}

- (void) categoryShopOn {
    categoryShop = true;
    [self generateClusterItemsShopObject];
}

- (void) categoryShopOff {
    
    categoryShop = false;
    [clusterPlaceCategoryShop clearItems];
    [clusterPlaceCategoryShop removeItem:place_obj];
}

- (void) categoryRestorauntOn {
    categoryRestoraunt = true;
    [self generateClusterItemsRestoranteObject];
}

- (void) categoryRestorauntOff {
    
    categoryRestoraunt = false;
    [clusterPlaceCategoryRestoraunt clearItems];
    [clusterPlaceCategoryRestoraunt removeItem:place_obj];
}

- (void) categoryCafeOn {
    categoryCafe = true;
    [self generateClusterItemsCafeObject];
}

- (void) categoryCafeOff {
    
    categoryCafe = false;
    [clusterPlaceCategoryCafe clearItems];
    [clusterPlaceCategoryCafe removeItem:place_obj];
}

- (void) categoryBarOn {
    categoryBar = true;
    [self generateClusterItemsBarObject];
}

- (void) categoryBarOff {
    
    categoryBar = false;
    [clusterPlaceCategoryBar clearItems];
    [clusterPlaceCategoryBar removeItem:place_obj];
}

- (void) categorySchoolOn {
    categorySchool = true;
    [self generateClusterItemsSchoolObject];
}

- (void) categorySchoolOff {
    
    categorySchool = false;
    [clusterPlaceCategorySchool clearItems];
    [clusterPlaceCategorySchool removeItem:place_obj];
}

- (void) initUserLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    [_locationManager requestWhenInUseAuthorization];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSString *ltd = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
    
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    [man.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", data_token] forHTTPHeaderField:@"Authorization"];
    
    NSMutableDictionary *pos = [[NSMutableDictionary alloc] init];
    pos = [NSMutableDictionary dictionaryWithObjectsAndKeys:
           
            ltd, @"latitude",
            lng, @"longitude",
           
            nil];
    
    NSString *url = [NSString stringWithFormat:@"http://motomoto.2-wm.ru/apiv1/profile/%@/location", data_id];
    [man PATCH:url parameters:pos
     
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
           }
     
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"error: %@", error);
           }];
}

- (void) initMap {
    
    GMSCameraPosition *userLocation = [GMSCameraPosition cameraWithLatitude:self.locationManager.location.coordinate.latitude
                                                                  longitude:self.locationManager.location.coordinate.longitude
                                                                       zoom:13
                                       ];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, CGRectGetWidth([self.view bounds]), CGRectGetHeight([self.view bounds])) camera:userLocation];
    mapView.delegate = self;
    
    mapView.myLocationEnabled = YES;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSError *error;
    
    styleUrl = [mainBundle URLForResource:@"style_day" withExtension:@"json"];
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    mapView.mapStyle = style;
    
    [self.view insertSubview:mapView atIndex:0];
}

- (void) setRevealSlideMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
}

- (void) sideBarButtonAction {
    
    if (mapView.isUserInteractionEnabled == true) {
        //mapView.userInteractionEnabled = false;
    }
}

- (void) setAnimationTypes {
    
    [fabriqAnimation initAnimationType_PushTop:aPushTop];
    [fabriqAnimation initAnimationType_PushBottom:aPushBottom];
    [fabriqAnimation initAnimationType_Fade:aFade];
    [fabriqAnimation initAnimationType_PushLeft:aPushLeft];
    [fabriqAnimation initAnimationType_PushRight:aPushRight];
}

- (void) setShadowCornerView {
    
    [fabriqStyleView ApplyStyleView_CornerShadow:headerView cornerRaduis:0 shadowOffSetX:-3 shadowOffSetY:3 shadowRaduis:3 shadowOpacity:0.3 maskToBounds:NO];
    [fabriqStyleView ApplyStyleView_CornerShadow:roundMenu cornerRaduis:0 shadowOffSetX:-2 shadowOffSetY:2 shadowRaduis:3 shadowOpacity:0.2 maskToBounds:NO];
    [fabriqStyleView ApplyStyleView_CornerShadow:addingSmallEventView cornerRaduis:0 shadowOffSetX:3 shadowOffSetY:3 shadowRaduis:5 shadowOpacity:5 maskToBounds:NO];
}

- (void) setRoundMenu {
    
    [roundMenu loadButtonWithIcons:@[
                                     [UIImage imageNamed:@"map_se_edit_0.pdf"],
                                     [UIImage imageNamed:@"map_se_edit_1.pdf"],
                                     [UIImage imageNamed:@"map_se_edit_2.pdf"]
                                     ]
                       startDegree:-M_PI layoutDegree:M_PI/2];
    
    [self.roundMenu setButtonClickBlock:^(NSInteger idx) {
        
        addingSmallEvent_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
         
         switch (idx) {
                 
             case 0: {
                 event_type_creat = 0;
                 
                 NSString *titleCrash = @"Создать встречу";
                 headerViewTitle.text = [NSString stringWithFormat:@"%@", titleCrash];
                 addingSmallEvent_btn.titleLabel.text = @"Создать";
             }
                 break;
                 
             case 1: {
                 event_type_creat = 1;
                 
                 NSString *titleMeeting = @"Создать прохват";
                 headerViewTitle.text = [NSString stringWithFormat:@"%@", titleMeeting];
                 addingSmallEvent_btn.titleLabel.text = @"Создать";
             }
                 break;
                 
             case 2: {
                 event_type_creat = 2;
                 
                 NSString *titleRace = @"Создать происшествие";
                 headerViewTitle.text = [NSString stringWithFormat:@"%@", titleRace];
                 addingSmallEvent_btn.titleLabel.text = @"Создать";
             }
                 break;
            
             default:
                 break;
         }
         
         [self settingNewEvent];
     }];
    
    [roundMenu setCenterIcon:[UIImage imageNamed:@"map_se_edit_button.pdf"]];
    [roundMenu setCenterIconType:XXXIconTypeCustomImage];
    
    roundMenu.tintColor = [UIColor whiteColor];
    roundMenu.backgroundColor = [UIColor clearColor];
    roundMenu.mainColor = [UIColor clearColor];
}

- (void) initUserLocationButton {
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];

    UIImage *image = [UIImage imageNamed:@"target button copy.png"];
    [button setImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(userLocation:) forControlEvents:UIControlEventTouchUpInside];
        
    [self.contentView addSubview:button];
}

- (void) ButtonClicked {
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         button.center = CGPointMake(button.center.x, button.center.y - 70.0f);
                         
                     }];
    
    [contentView setUserInteractionEnabled:false];
}

- (void) ButtonUnClicked {
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         button.center = CGPointMake(button.center.x, button.center.y + 70.0f);
                         
                     }];
    
    [contentView setUserInteractionEnabled:true];
}

- (void) initPeople {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://motomoto.2-wm.ru/apiv1/profile/map/all?format=json" parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
            
             userObjJSON = [[UserObjJSON alloc] initUserWithlng:[[responseObject valueForKey:@"longitude"] allObjects]
                                                            ltd:[[responseObject valueForKey:@"latitude"] allObjects]
                                                          image:[[responseObject valueForKey:@"image"] allObjects]
                                                             ID:[[responseObject valueForKey:@"id"] allObjects]
                            ];
             
             [self generateClusterItems_users];
     }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"People Error: %@", error);
     }];
}

- (void) initEvents {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://motomoto.2-wm.ru/apiv1/events/small?format=json" parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             eventObjJSON = [[EventObjectJSON alloc] initObjecttWithID:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"id"]
                                                                   ltd:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"latitude"]
                                                                   lng:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"longitude"]
                                                                  time:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"start_time"]
                                                                UserID:[[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"user_id"]
                             ];
             
             [self setEventIcons];
             [self generateClusterItems_events];
     }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void) initPlaces {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://motomoto.2-wm.ru/apiv1/places/list" parameters:nil progress:nil
     
         success:^(NSURLSessionTask *task, id responseObject) {
             
             placeObjJSON = [[PlaceObjectJSON alloc] initObjecttWithPosition:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"longitude"]
                                                                         ltd:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"latitude"]
                                                                        type:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"services"]
                                                                          ID:[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"id"]
                             ];
             
             [self setPlacesIcon];
             
             [self generateClusterItemsParkingObject];
             [self generateClusterItemsGazObject];
             [self generateClusterItemsRepairObject];
             [self generateClusterItemsShopObject];
             [self generateClusterItemsRestoranteObject];
             [self generateClusterItemsCafeObject];
             [self generateClusterItemsBarObject];
             [self generateClusterItemsSchoolObject];
     }
     
         failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void) setEventIcons {
    
    iconsEvents = [[NSMutableArray alloc] init];
    
    UIImage *icon_race_category = [UIImage imageNamed:@"map_icon_event.pdf"];
    
    for (NSString *type in eventObjJSON.ltd) {
        
        [iconsEvents addObject:icon_race_category];
    }
}

- (void) setPlacesIcon {
    
    iconsPlaces = [[NSMutableArray alloc] init];
    
    NSString *repair = @"map_icon_serivce.pdf";
    NSString *shop = @"map_icon_shop.pdf";
    NSString *school = @"map_icon_school.pdf";
    NSString *rest = @"map_icon_rest.pdf";
    NSString *bar = @"map_icon_bar.pdf";
    NSString *parking = @"map_icon_parking.pdf";
    NSString *gaz = @"map_icon_gaz.pdf";
    NSString *cafe = @"map_icon_cafe.pdf";
    NSString *def = @"default_icon_place.png";
    
    for (NSArray *category in placeObjJSON.type) {
        
        if ([[category firstObject] isEqualToString:@"repair"]) {
            [iconsPlaces addObject:repair];
        } else if ([[category firstObject] isEqualToString:@"store"]) {
            [iconsPlaces addObject:shop];
        } else if ([[category firstObject] isEqualToString:@"school"]) {
            [iconsPlaces addObject:school];
        } else if ([[category firstObject] isEqualToString:@"restaurant"]) {
            [iconsPlaces addObject:rest];
        } else if ([[category firstObject] isEqualToString:@"bar"]) {
            [iconsPlaces addObject:bar];
        } else if ([[category firstObject] isEqualToString:@"parking"]) {
            [iconsPlaces addObject:parking];
        } else if ([[category firstObject] isEqualToString:@"fuel"]) {
            [iconsPlaces addObject:gaz];
        } else if ([[category firstObject] isEqualToString:@"cafe"]) {
            [iconsPlaces addObject:cafe];
        } else {
            [iconsPlaces addObject:def];
        }
    }
}

- (void) generateClusterItems_events {
    
    if (categoryEvent == true) {
        
        for (NSNumber *count in eventObjJSON.ltd) {
            
            NSUInteger valueCount = [eventObjJSON.ltd indexOfObject:count];
            
            NSNumber *lng = [eventObjJSON.lng objectAtIndex:valueCount];
            float flng = lng.floatValue;
            
            NSNumber *lat = [eventObjJSON.ltd objectAtIndex:valueCount];
            float flat = lat.floatValue;
            
            itemEvents = [[Event_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                           type:@"event"
                                                     type_event:nil
                                                           time:[eventObjJSON.time objectAtIndex:valueCount]
                                                          icons:nil
                                                             ID:[eventObjJSON.ID objectAtIndex:valueCount]
                                                         UserID:[eventObjJSON.UserID objectAtIndex:valueCount]
                          ];
            
            [clusterManagerEvent addItem:itemEvents];
        }
        
        [clusterManagerEvent cluster];
    }
}

- (void) generateClusterItems_users {
    
    if (categoryPeople == true) {
        
        for (NSNumber *count in userObjJSON.lng) {
            
            if ([count isEqual:[NSNull null]]) {
                NSLog(@"user invisible");
                
            } else {
                
                NSUInteger valueClount = [userObjJSON.lng indexOfObject:count];
                
                if ([[userObjJSON.ID objectAtIndex:valueClount] intValue] == [data_id intValue]) {
                    NSLog(@"that's me");
                    
                } else {
                    
                    NSNumber *lng = [userObjJSON.lng objectAtIndex:valueClount];
                    float flng = lng.floatValue;
                    
                    NSNumber *lat = [userObjJSON.ltd objectAtIndex:valueClount];
                    float flat = lat.floatValue;
                    
                    itemUsers = [[User_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                                 type:@"user"
                                                                ident:[userObjJSON.ID objectAtIndex:valueClount]
                                                            icon_user:[userObjJSON.image objectAtIndex:valueClount]
                                 ];
                    
                    [clusterManagerPeople addItem:itemUsers];
                }
            }
        }
        
        [clusterManagerPeople cluster];
    }
}


// generate cluster items

- (void) generateClusterItemsParkingObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"parking"] && categoryParking == true) {
                [clusterPlaceCategoryParking addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryParking cluster];
}

- (void) generateClusterItemsGazObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"fuel"] && categoryGaz == true) {
                [clusterPlaceCategoryGaz addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryGaz cluster];
}

- (void) generateClusterItemsRepairObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"repair"] && categoryService == true) {
                [clusterPlaceCategoryService addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryService cluster];
}

- (void) generateClusterItemsShopObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"store"] && categoryShop == true) {
                [clusterPlaceCategoryShop addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryShop cluster];
}

- (void) generateClusterItemsRestoranteObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"restaurant"] && categoryRestoraunt == true) {
                [clusterPlaceCategoryRestoraunt addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryRestoraunt cluster];
}

- (void) generateClusterItemsCafeObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"cafe"] && categoryCafe == true) {
                [clusterPlaceCategoryCafe addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryCafe cluster];
}

- (void) generateClusterItemsBarObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"bar"] && categoryBar == true) {
                [clusterPlaceCategoryBar addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategoryBar cluster];
}

- (void) generateClusterItemsSchoolObject {
    
    for (NSNumber *count in placeObjJSON.ltd) {
        
        NSUInteger valueClount = [placeObjJSON.ltd indexOfObject:count];
        
        NSNumber *lng = [placeObjJSON.lng objectAtIndex:valueClount];
        float flng = lng.floatValue;
        
        NSNumber *lat = [placeObjJSON.ltd objectAtIndex:valueClount];
        float flat = lat.floatValue;
        
        if (valueClount < iconsPlaces.count) {
            
            place_obj = [[Place_object alloc] initWithPosition:CLLocationCoordinate2DMake(flat, flng)
                                                          type:@"place"
                                                         icons:[iconsPlaces objectAtIndex:valueClount]
                                                             i:[placeObjJSON.ID objectAtIndex:valueClount]
                                                      category:[placeObjJSON.type objectAtIndex:valueClount]
                         ];
            
            if ([[place_obj.category firstObject] isEqualToString:@"school"] && categorySchool == true) {
                [clusterPlaceCategorySchool addItem:place_obj];
            }
        }
    }
    
    [clusterPlaceCategorySchool cluster];
}


- (void)clusterManager:(GMUClusterManager *)clusterManager didTapCluster:(id<GMUCluster>)cluster {
    
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithTarget:cluster.position zoom:mapView.camera.zoom + 1];
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
    
    [mapView moveCamera:update];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    user_obj = marker.userData;
    place_obj = marker.userData;
    event_obj = marker.userData;
    
    if ([[[marker valueForKey:@"_userData"] valueForKey:@"_type"] isEqualToString:@"user"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:false] forKey:@"isNativeUser"];
        [[NSUserDefaults standardUserDefaults] setObject:user_obj.ident forKey:@"user.id"];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"userMap"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
        
        
    } else if ([[[marker valueForKey:@"_userData"] valueForKey:@"_type"] isEqualToString:@"place"]) {
        
        NSString *URL = [NSString stringWithFormat:@"%@%@", @"http://motomoto.2-wm.ru/apiv1/places/",[[marker valueForKey:@"_userData"] valueForKey:@"_i"]];
        NSString *URLimage = [NSString stringWithFormat:@"http://motomoto.2-wm.ru/apiv1/places/%@/photos", [[marker valueForKey:@"_userData"] valueForKey:@"_i"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:URL forKey:@"place.url"];
        [[NSUserDefaults standardUserDefaults] setObject:URLimage forKey:@"place.image.url"];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"placeMap"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
        
    } else if ([[[marker valueForKey:@"_userData"] valueForKey:@"_type"] isEqualToString:@"event"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[[marker valueForKey:@"_userData"] valueForKey:@"_ID"] forKey:@"se.ID"];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"smallEventView"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
    }
    
    return YES;
}

- (void) settingNewEvent {
    
    [headerView.layer addAnimation:aPushTop forKey:nil];
    [addingSmallEventView.layer addAnimation:aPushTop forKey:nil];
    [iconContainer.layer addAnimation:aFade forKey:nil];
    
    [roundMenu.layer addAnimation:aFade forKey:nil];
    [button.layer addAnimation:aFade forKey:nil];
    
    headerView.hidden = NO;
    addingSmallEventView.hidden = NO;
    iconContainer.hidden = NO;
    
    roundMenu.hidden = YES;
    button.hidden = YES;
    
    
    rightBarButton.image = [UIImage imageNamed:@"cancel_edit_15.png"];
    isNeedCancelSmallEvent = true;
    
    
    touchPoint = CGPointMake(CGRectGetMidX([mapView bounds]), CGRectGetMidY([mapView bounds]));
    location = [mapView.projection coordinateForPoint:touchPoint];
    
    
    UIImage *image = [UIImage imageNamed:@"map_se_pin.pdf"];
    icon = [[UIImageView alloc] initWithImage:image];
    iconContainer = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX([mapView bounds]), CGRectGetMidY([mapView bounds]), 20, 31)];
    icon.frame = iconContainer.bounds;
    icon.layer.cornerRadius = 10;
    icon.clipsToBounds = YES;
    [iconContainer addSubview:icon];
    
    iconContainer.layer.masksToBounds = NO;
    iconContainer.layer.shadowOffset = CGSizeMake(-2, 3);
    iconContainer.layer.shadowRadius = 5;
    iconContainer.layer.shadowOpacity = 0.5;
    
    [mapView addSubview:iconContainer];
    
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1) target:self
                                                selector:@selector(refreshAdress) userInfo:nil repeats:YES];
}

- (void) refreshAdress {
    
    location = [mapView.projection coordinateForPoint:touchPoint];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    
    dict = [NSDictionary dictionary];
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            
            [NSString stringWithFormat:@"%f", location.latitude], @"latitude",
            [NSString stringWithFormat:@"%f", location.longitude], @"longitude",
            
            nil];
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      
                      [UIView transitionWithView:addingSmallEventView
                                        duration:0.2
                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                      animations:^ {
                                          addingSmallEvent_lbl.text = [NSString stringWithFormat:@"%@", placemark.name];
                                      }
                                      completion:NULL];
                  } else {
                      NSLog(@"Could not locate");
                  }
              }
     ];
}

- (IBAction)userLocation:(id)sender {
    
    [mapView animateToLocation:CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude)];
    [mapView animateToZoom:14];
}

- (IBAction)rightBarButton:(id)sender {
    
    if (isNeedCancelSmallEvent == true) {
        
        rightBarButton.image = [UIImage imageNamed:@"filter_0.png.png"];
        
        [headerView.layer addAnimation:aPushBottom forKey:nil];
        [addingSmallEventView.layer addAnimation:aPushBottom forKey:nil];
        [iconContainer.layer addAnimation:aFade forKey:nil];
        [icon.layer addAnimation:aFade forKey:nil];
        
        [roundMenu.layer addAnimation:aPushRight forKey:nil];
        [button.layer addAnimation:aPushRight forKey:nil];
        
        icon.hidden = YES;
        headerView.hidden = YES;
        addingSmallEventView.hidden = YES;
        iconContainer.hidden = YES;
        
        roundMenu.hidden = NO;
        button.hidden = NO;
        
        [self.timer invalidate];
        self.timer = nil;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             button.center = CGPointMake(button.center.x, button.center.y + 70.0f);
                             
                         }];
        
        isNeedCancelSmallEvent = false;
        
        [contentView setUserInteractionEnabled:true];
        
    } else {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromRight;
        
        UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"filter"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:Place animated:YES];
    }
}


- (IBAction)addingSmallEvent:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:addingSmallEvent_lbl.text forKey:@"smallEvent.address"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude] forKey:@"smallEvent.location"];
    [[NSUserDefaults standardUserDefaults] setObject:headerViewTitle.text forKey:@"smallEvent.type"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"smallEvent"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

@end
