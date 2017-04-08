//
//  LentaPlaceCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 02.12.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LentaPlaceCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imageUser;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UILabel *comment;

@end
