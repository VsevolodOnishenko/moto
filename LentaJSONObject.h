//
//  LentaJSONObject.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 31.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LentaJSONObject : NSObject

@property(nonatomic, readonly) NSArray *image_url;
@property(nonatomic, readonly) NSArray *title;
@property(nonatomic, readonly) NSArray *ID;

- (instancetype) initLentaObjectWithID:(NSArray *)ID image_url:(NSArray *)image_url title:(NSArray *)title;

@end
