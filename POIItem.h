//
//  POIItem.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 30.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "MotoMap.h"

#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <GoogleMaps/GoogleMaps.h>

@interface Place_object : NSObject <GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSMutableArray *icons;
@property(nonatomic, readonly) NSString *type;
@property(nonatomic, readonly) NSNumber *i;
@property(nonatomic, readonly) NSArray *category;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position type:(NSString *)type icons:(NSMutableArray *)icons i:(NSNumber *)i category:(NSArray *)category;

@end
