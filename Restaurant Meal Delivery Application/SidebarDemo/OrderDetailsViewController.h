//
//  OrderDetailsViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-17.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderCart.h"

@interface OrderDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *orderAddress;
@property (strong, nonatomic) IBOutlet UITextField *roonNumber;
@property (strong, nonatomic) IBOutlet UITextView *additionalOrderDetails;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong,nonatomic) orderCart *cart;

@property (weak, nonatomic) IBOutlet UIView *realView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)pressedContinue:(id)sender;
-(void)restoreEnteredInformation;

@end
