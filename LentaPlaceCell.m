//
//  LentaPlaceCell.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 02.12.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "LentaPlaceCell.h"

@implementation LentaPlaceCell

@synthesize imageUser = _imageUser;
@synthesize name = _name;
@synthesize date = _date;
@synthesize comment = _comment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
