//
//  User_object.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 11.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "MotoMap.h"

#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <GoogleMaps/GoogleMaps.h>

@interface User_object : NSObject <GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) NSString *icon_user;
@property(nonatomic, readonly) NSString *ident;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position type:(NSString *)type ident:(NSString *)ident icon_user:(NSString *)icon_user;

@end
