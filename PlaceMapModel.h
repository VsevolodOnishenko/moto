//
//  PlaceMapModel.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 10.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceMapModel : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) NSArray *category;
@property (nonatomic, readonly) NSArray *image;
@property (nonatomic, readonly) NSMutableDictionary *contacts;
@property (nonatomic, readonly) NSString *shedule;
@property (nonatomic, readonly) float lng;
@property (nonatomic, readonly) float ltd;

- (instancetype)initPlaceMapWithTitle:(NSString *)title body:(NSString *)body category:(NSArray *)category image:(NSArray *)image contacts:(NSMutableDictionary *)contacts shedule:(NSString *)shedule lng:(float)lng ltd:(float)ltd;

@end
