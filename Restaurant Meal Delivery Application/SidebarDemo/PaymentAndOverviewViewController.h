//
//  PaymentAndOverviewViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-18.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderCart.h"
#import "Stripe.h"
#import "PTKView.h"

@interface PaymentAndOverviewViewController : UIViewController<PTKViewDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate, UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) orderCart *cart;
@property (strong,nonatomic) PTKView *stripePaymentCardView;

@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *visibleScrollView;
@property (strong, nonatomic) NSArray *orderItemNames;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UITextField *tipAmount;
@property (weak, nonatomic) IBOutlet UILabel *subTotal;
@property (weak, nonatomic) IBOutlet UILabel *taxes;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFee;
@property (weak, nonatomic) IBOutlet UILabel *totalSum;
@property (weak, nonatomic) IBOutlet UILabel *tipBill;
@property (weak, nonatomic) IBOutlet UITextField *coupon;



@property (weak, nonatomic) IBOutlet UIButton *updateTotalButton;
@property (weak, nonatomic) IBOutlet UIButton *applyCouponButton;

@property double runningTip;
@property double discount;


@property (strong,nonatomic) NSString *bill;

- (IBAction)placeOrderPressed:(id)sender;
- (void)createBackendChargeWithToken:(STPToken *)token;
-(NSString*)calculateFees;
-(NSString *)URLEncodeStringFromString:(NSString *)string;
- (IBAction)updateTotal:(id)sender;
- (IBAction)applyCouponPressed:(id)sender;
-(void)addButtonBorders;
@end
