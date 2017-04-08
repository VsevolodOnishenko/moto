//
//  Event_object.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 11.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "MotoMap.h"

#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Event_object : NSObject <GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) NSString *type_event;
@property(nonatomic, readonly) NSString *time;
@property(nonatomic, readonly) NSArray *icons;

@property(nonatomic, readonly) NSArray *ID;
@property(nonatomic, readonly) NSArray *UserID;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position type:(NSString *)type type_event:(NSString *)type_event time:(NSString *)time icons:(NSArray *)icons ID:(NSArray *)ID UserID:(NSArray *)UserID;

@end
