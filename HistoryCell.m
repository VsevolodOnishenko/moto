//
//  HistoryCell.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 13.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

@synthesize image = _image;
@synthesize title = _title;
@synthesize lenght = _lenght;
@synthesize time_duration = _time_duration;

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
