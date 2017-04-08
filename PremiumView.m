//
//  PremiumView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 23.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "PremiumView.h"


@interface PremiumView () <SKPaymentTransactionObserver,SKProductsRequestDelegate,SKRequestDelegate>
{
    SKProductsRequest *productsRequest;
    NSSet *productIdentifiers;
}

@end

@implementation PremiumView

static NSString *featureAId = @"wm.motomoto.yearpay";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)noBuy:(id)sender
{
}

- (IBAction)yesBuy:(id)sender
{
    if ([SKPaymentQueue canMakePayments])
    {
        NSLog(@"User can make payments");
        
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:
                                                                                 featureAId,
                                                                                 nil]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else
    {
        NSLog(@"User can NOT make payments");
        
        [RKDropdownAlert title:@"Ошибка" message:@"К сожалению, Вы не можете совершить платеж" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor] time:5];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (IBAction)restoreBuy:(id)sender
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions)
    {
        if(transaction.transactionState == SKPaymentTransactionStateRestored)
        {
            NSLog(@"Transaction state -> Restored");
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;
    
    if ([response.products count])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        SKPayment *payment = [SKPayment paymentWithProduct:[myProduct lastObject]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        NSLog(@"No products with those ID");
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing...");
                break;
                
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Purchased");
                break;
                
            case SKPaymentTransactionStateFailed:
                if(transaction.error.code == SKErrorPaymentCancelled)
                {
                    NSLog(@"Cancelled");
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Restored");
                
            case SKPaymentTransactionStateDeferred:
                NSLog(@"Deferred");
                //Осталось покупка в очереди
                break;
                
            default:
                break;
        }
    }
}

@end
