//
//  FilterMap.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FilterCategory.h"

#import "FilterMapCell.h"
#import "FilterTitleCell.h"

@interface FilterMap : UICollectionViewController

@property (strong, nonatomic) IBOutlet UICollectionView *FilterMapCollectionView;

@end
