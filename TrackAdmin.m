//
//  TrackAdmin.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "TrackAdmin.h"

@interface TrackAdmin () <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *image;
    NSArray *title;
    NSArray *subtitle;
    NSArray *distance;
}

@end

@implementation TrackAdmin

@synthesize tableTrack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableSyle];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableSyle {
    
    tableTrack.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableTrack.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    tableTrack.separatorColor = [UIColor clearColor];
}

- (void) loadData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"https://drive.google.com/uc?export=download&id=0BzEFC7r_La7PdDZZTmZhR0U5ckE" parameters:nil progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         image = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"image"];
         title = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"title"];
         subtitle = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"address"];
         distance = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"distance"];
         
         [self.tableTrack reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
         
         NSLog(@"success!");
     }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"error: %@", error);
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return image.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellident = @"HistoryCell";
    TrackAdminCell *cell = (TrackAdminCell *)[tableTrack dequeueReusableCellWithIdentifier:cellident];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrackAdminCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.image.layer.cornerRadius = 5;
    cell.image.clipsToBounds = YES;
    
    [cell.image setImageWithURL:[NSURL URLWithString:[image objectAtIndex:indexPath.row]]];
    cell.title.text = [NSString stringWithFormat:@"%@", [title objectAtIndex:indexPath.row]];
    cell.subtitle.text = [NSString stringWithFormat:@"%@,  %@ метров", [subtitle objectAtIndex:indexPath.row], [distance objectAtIndex:indexPath.row]];

    return cell;
}


@end
