//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "ModelData.h"

@implementation DemoModelData

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.messages = [[NSMutableArray alloc] init];
        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed:0.25 green:0.27 blue:0.31 alpha:1.0]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.92 alpha:1.0]];
    }
    
    return self;
}


@end
