//
//  TrackHistory.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 13.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "TrackHistory.h"

@interface TrackHistory () <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *image;
    NSArray *length;
    
    NSMutableArray *time_route;
}

@end

@implementation TrackHistory

@synthesize tableTrackHistory;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self ApplyTableSyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableSyle {
    
    tableTrackHistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableTrackHistory.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    tableTrackHistory.separatorColor = [UIColor clearColor];
    
    [self.tableTrackHistory setContentInset:UIEdgeInsetsMake( - 60, 0, 0, 0)];
}

- (void) loadData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"https://drive.google.com/uc?export=download&id=0BzEFC7r_La7PYUlSWFJZY1FMdzQ" parameters:nil progress:nil
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         image = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"image"];
         length = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] allObjects] valueForKey:@"distance"];
         
         [self.tableTrackHistory reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
         
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
    HistoryCell *cell = (HistoryCell *)[tableTrackHistory dequeueReusableCellWithIdentifier:cellident];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.image.layer.cornerRadius = 5;
    cell.image.clipsToBounds = YES;
    
    [cell.image setImageWithURL:[NSURL URLWithString:[image objectAtIndex:indexPath.row]]];
    cell.title.text = @"Проезд";
    cell.lenght.text = [NSString stringWithFormat:@"%@ метров", [length objectAtIndex:indexPath.row]];
    cell.time_duration.text = @"15 минут";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *ind = [NSNumber numberWithUnsignedInteger:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:ind forKey:@"ind"];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.1;
    transition.type = kCATransitionFade;
    
    UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryView"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:Place animated:YES];
}

@end
