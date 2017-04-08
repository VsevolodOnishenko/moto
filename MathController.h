//
//  MathController.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathController : NSObject

+ (NSString *)stringifyDistance:(float)meters;
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;
+ (NSString *)stringifMaxPaceFromDis:(float)meters overTime:(int)seconds;

+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations;

@end
