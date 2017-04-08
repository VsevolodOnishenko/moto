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

#import "MessagesViewController.h"

@interface DemoMessagesViewController () {
    
    NSNumber *lastidMessage;
    NSUInteger lastCount;

    bool isEarlyMessageLoad;
    
    User *user;
    UserData *userData;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DemoMessagesViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMessageData];
    [self ApplyStyleNoAvatar];
    [self ApplyCollectionViewStyle];
    
    [self userData];
    [self getUserData];
    
    [self receiveMessage];
    [self messageMarkerAsRead];
    
     self.timer = [NSTimer scheduledTimerWithTimeInterval:(5.0) target:self
                                                 selector:@selector(receiveMessage) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.backItem.title = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    lastCount = 0;
}

- (void) getUserData {
    
    NSError *error = nil;
    userData = [[UserData alloc] initUserDataWithToken:[FDKeychain itemForKey: @"token"
                                                                   forService: @"MotoMotoApp"
                                                                        error: &error]
                
                                                    ID:[FDKeychain itemForKey: @"id"
                                                                   forService: @"MotoMotoApp"
                                                                        error: &error]
                ];
}

- (void) initMessageData {
    self.demoData = [[DemoModelData alloc] init];
}

- (void) ApplyCollectionViewStyle {
    
    self.inputToolbar.contentView.textView.textColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
    self.inputToolbar.contentView.backgroundColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.31 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
}

- (void) ApplyStyleNoAvatar {
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
}

- (void) userData {
   
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://moto.2-wm.ru/apiv2/users.get?id=%@&fields=image,first_name", [[NSUserDefaults standardUserDefaults] objectForKey:@"user.id"]]
     
      parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
          
          user = [[User alloc] initUserWithImageURL:[[responseObject valueForKey:@"data"] valueForKey:@"image"]
                                              fname:[[responseObject valueForKey:@"data"] valueForKey:@"first_name"]
                                              lname:nil
                                                 ID:nil
                  ];
          NSLog(@"response object is %@", responseObject);
          
          
          self.title = user.fname;
          
          UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
          view.layer.cornerRadius = 17;
          view.clipsToBounds = YES;
          
          [view setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", user.image_url, @"_profile.jpg"]]];
        
          UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:view];
          button.image = view.image;
          self.navigationItem.rightBarButtonItem = button;
      }
     
      failure:^(NSURLSessionTask *operation, NSError *error){
         NSLog(@"Error: %@", error);
     }];
}

- (void) receiveMessage {
    
    [self userData];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
             
             userData.token, @"token",
             [[NSUserDefaults standardUserDefaults] objectForKey:@"user.id"], @"opponent_id",
             
             nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://moto.2-wm.ru/apiv2/messages.getDialog" parameters:dict progress:nil
     
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSLog(@"%@", responseObject);
              
              if ([[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"id"] lastObject] > lastidMessage) {
                  
                  NSArray *allMessage = [[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"text"];
                  NSArray *allAuthors = [[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"my"];
                  NSArray *allDates = [[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"time"];
                  
                  incomeMessage *dialog = [[incomeMessage alloc] initMessage:[allMessage subarrayWithRange:NSMakeRange(lastCount, allMessage.count - lastCount)]
                                                                      author:[allAuthors subarrayWithRange:NSMakeRange(lastCount, allAuthors.count - lastCount)]
                                                                        date:[allDates subarrayWithRange:NSMakeRange(lastCount, allDates.count - lastCount)]
                                            ];
                  
                  for (NSString *message in dialog.message) {
                      
                      NSUInteger count = [dialog.message indexOfObject:message];
                      
                      if ([[dialog.author objectAtIndex:count] integerValue] == 0) {
                          
                          lastidMessage = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"id"] lastObject];
                          lastCount = allMessage.count;
                        
                          JSQMessage *incomeMessage = [[JSQMessage alloc] initWithSenderId:[[NSUserDefaults standardUserDefaults] stringForKey:@"user.id"]
                                                                         senderDisplayName:user.fname
                                                                                      date:[NSDate dateWithTimeIntervalSince1970:[[dialog.date objectAtIndex:count] doubleValue]]
                                                                                      text:[dialog.message objectAtIndex:count]
                                                       ];
                        
                          [self.demoData.messages addObject:incomeMessage];
                          [self finishReceivingMessageAnimated:YES];
                          
                      } else {
                          
                          if (isEarlyMessageLoad == false) {
                              
                              lastidMessage = [[[[responseObject valueForKey:@"data"] valueForKey:@"items"] valueForKey:@"id"] lastObject];
                              lastCount = allMessage.count;
                              
                              JSQMessage *outcomeMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"053496-4509-289"]
                                                                              senderDisplayName:@""
                                                                                           date:[NSDate dateWithTimeIntervalSince1970:[[dialog.date objectAtIndex:count] doubleValue]]
                                                                                           text:[dialog.message objectAtIndex:count]
                                                            ];
                              
                              [self.demoData.messages addObject:outcomeMessage];
                              [self finishSendingMessage];
                              [self isOutgoingMessage:outcomeMessage];
                          }
                      }
                  }
                  
                  isEarlyMessageLoad = true;
              }
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void) messageMarkerAsRead {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
             lastidMessage, @"id",
             nil];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", userData.token] forHTTPHeaderField:@"Authorization"];
    [manager POST:@"http://moto.2-wm.ru/apiv2/dialogs/message/mark/read" parameters:dict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"%@", responseObject);
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error: %@", error);
          }];
}

- (BOOL)isOutgoingMessage:(id<JSQMessageData>)messageItem {
    
    NSString *messageSenderId = [messageItem senderId];
    NSParameterAssert(messageSenderId != nil);
    return [messageSenderId isEqualToString:self.senderId];
}

#pragma mark - Actions

- (void)closePressed:(UIBarButtonItem *)sender {
    [self.delegateModal didDismissJSQDemoViewController:self];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
             
             userData.token, @"token",
             [[NSUserDefaults standardUserDefaults] objectForKey:@"user.id"], @"recipient_id",
             text, @"text",
             nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://moto.2-wm.ru/apiv2/messages.create" parameters:dict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                       senderDisplayName:senderDisplayName
                                                                    date:date
                                                                    text:text];
              
              [self.demoData.messages addObject:message];
              [self finishSendingMessageAnimated:YES];
          }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error: %@", error);
              
              JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                       senderDisplayName:senderDisplayName
                                                                    date:date
                                                                    text:@"Ошибка отправки"];
              
              [self.demoData.messages addObject:message];
              [self finishSendingMessageAnimated:YES];
          }];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return @"053496-4509-289";
}

- (NSString *)senderDisplayName {
    return @"";
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.demoData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 5 == 0) {
        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];

    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }

    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message {
    return nil;
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 5 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    NSLog(@"Показать историю сообщений");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tapped avatar!");
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender {
    if ([UIPasteboard generalPasteboard].image) {
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.demoData.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

- (void) dealloc {
    [self.timer invalidate];
}

@end
