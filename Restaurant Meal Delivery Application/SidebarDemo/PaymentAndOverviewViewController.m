//
//  PaymentAndOverviewViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-18.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "PaymentAndOverviewViewController.h"
#import "PTKView.h"
#import "Stripe.h"
#import "STPCard.h"
#import "AFNetworking.h"

@interface PaymentAndOverviewViewController ()
@end

@implementation PaymentAndOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addButtonBorders];
    
    //Helps put in motion the methods that bring unseeable text fields user is editing into view
    [self registerForKeyboardNotifications];

    
    //Set these to 0 in order to properly do calculations
    _runningTip = 0.00;
    _discount = 0.00;
    
    _orderItemNames = [_cart.orderedItems allKeys];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapView.numberOfTapsRequired = 1;
    self.visibleScrollView.userInteractionEnabled = YES;
    [self.visibleScrollView addGestureRecognizer:tapView];
    
    //Setup for payment (Stripe) view
    _stripePaymentCardView = [[PTKView alloc] initWithFrame:CGRectMake(15,-10,290,55)];
    _stripePaymentCardView.delegate = self;
    [self.visibleScrollView addSubview:_stripePaymentCardView];
    
   //Disable submit button until details entered
    _placeOrderButton.enabled = NO;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //Calculate fees
   _bill = [self calculateFees];
    _bill = [_bill stringByReplacingOccurrencesOfString:@"$" withString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)[_cart.orderedItems count]);
    return [_cart.orderedItems count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderItem" forIndexPath:indexPath];
    
    cell.textLabel.text = _orderItemNames[indexPath.row];
    cell.detailTextLabel.text = _cart.orderedItems[_orderItemNames[indexPath.row]];
    
    //Makes sure cells aren't highlighted if user taps them
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_stripePaymentCardView resignFirstResponder];
}

//Checks if entered card is valid
-(void)paymentView:(PTKView *)paymentView withCard:(PTKCard *)card isValid:(BOOL)valid {
    _placeOrderButton.enabled = YES;
}


//Contacts stripe, gets token and then requests PHP page that handles Stripe
-(void)createBackendChargeWithToken:(STPToken *)token {
    
    NSMutableDictionary *fullOrderDetails = [_cart.orderedItems mutableCopy];
    
    NSString *tip = [NSString stringWithFormat:@"%.2f",_runningTip];

    [fullOrderDetails setObject:_cart.restaurantName forKey:@"restaurant"];
    [fullOrderDetails setObject:_cart.additionalDetails forKey:@"additionalDetails"];
    [fullOrderDetails setObject:_cart.userName forKey:@"userName"];
    [fullOrderDetails setObject:_cart.deliveryAddress forKey:@"address"];
    [fullOrderDetails setObject:_cart.apartmentRoomNumber forKey:@"roomNumber"];
    [fullOrderDetails setObject:_cart.contact forKey:@"contact"];
    [fullOrderDetails setObject:_bill forKey:@"bill"];
    [fullOrderDetails setObject:@"no" forKey:@"filled"];
    [fullOrderDetails setObject:@"" forKey:@"filledBy"];
    [fullOrderDetails setObject:token.tokenId forKey:@"stripeToken"];
    [fullOrderDetails setObject:tip forKey:@"tip"];


    
    NSMutableString *temp = [NSMutableString stringWithFormat:@"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/?"];
    NSArray *keys = [fullOrderDetails allKeys];
    
    for(int i = 0; i<[keys count]; i++) {
        
        
        NSString *pair1 = [keys[i] stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
        pair1 = [pair1 stringByReplacingOccurrencesOfString:@"=" withString:@"equals"];
        
        NSString *pair2 = [[fullOrderDetails objectForKey:keys[i]] stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
        pair2 = [pair2 stringByReplacingOccurrencesOfString:@"=" withString:@"equals"];
        
        NSString *temp1 = [NSString stringWithFormat:@"&%@=%@",pair1,pair2];
        
       NSString *final = [self URLEncodeStringFromString:temp1];
        [temp appendString:final];

    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:temp parameters:_cart.orderedItems success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = responseObject[@"Response"];
        
        if([response isEqualToString:@"SUCCESS"]) {
            [self performSegueWithIdentifier:@"paymentConfirmed" sender:self];


        } else if([response isEqualToString:@"BUSY"]) {
            
            //Create/setup alert controller
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Drivers Are Busy" message:@"All drivers are currently busy. Please try again soon." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            
            //Display alert controller
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            _placeOrderButton.enabled = YES;


        } else if ([response isEqualToString:@"FAILURE"]) {
            
            //Create/setup alert controller
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Card Declined" message:@"Your card was declined. Please check entered information." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            
            //Display alert controller
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
   
        }
        
    } failure:nil];
    
}


- (IBAction)placeOrderPressed:(id)sender {
    _placeOrderButton.enabled = NO;

    
    STPCard *card = [[STPCard alloc]init];
    
    card.number = self.stripePaymentCardView.card.number;
    card.expMonth = self.stripePaymentCardView.card.expMonth;
    card.expYear = self.stripePaymentCardView.card.expYear;
    card.cvc = self.stripePaymentCardView.card.cvc;
    [[STPAPIClient sharedClient] createTokenWithCard:card completion:^(STPToken *token, NSError *error) { if (error) {
        NSLog(@"ERROR: %@",error);
    } else {
        
        [self createBackendChargeWithToken:token];
    }
    }];
    

}

-(NSString*)calculateFees {
    
    double sum = 0;
    double price;
    int quantity;
    
    for(int i = 0; i < [_orderItemNames count]; i++) {
        quantity = [_cart.orderedItems[_orderItemNames[i]] doubleValue];
        price = [_cart.menuNamesAndPrices[_orderItemNames[i]] doubleValue];
        
        sum += (quantity)*(price);
    }
    
    double tax = (sum) * (.12);
    
    
    self.subTotal.text = [NSString stringWithFormat:@"$%.2f",sum];
    self.taxes.text = [NSString stringWithFormat:@"$%.2f",tax];
    
    //Check if discount is 0, if it is, then display that properly
    if(_discount == 5.99) {
        self.deliveryFee.text = @"$0.00";
    } else {
        self.deliveryFee.text = @"$5.99";
    }
    
    self.tipBill.text = [NSString stringWithFormat:@"$%.2f",_runningTip];
    
    double finalSum = _runningTip + sum + tax + 5.99 - _discount;
    
    self.totalSum.text = [NSString stringWithFormat:@"$%.2f",finalSum];
    return self.totalSum.text;
}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%*()+'\";:,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

- (IBAction)updateTotal:(id)sender {
    
    //Create/setup alert controller
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Tip" message:@"Please enter a valid tip amount." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    //Check if entered tip amount is an int and/or float
    NSScanner *scan = [NSScanner scannerWithString:_tipAmount.text];
    if(![scan scanFloat:NULL] || ![scan isAtEnd]) {
        //Display alert controller
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
     
    } else if([_tipAmount.text floatValue] < 0) {
        //Display alert controller
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } else {
        NSString *temp = _tipAmount.text;
        _runningTip = [temp doubleValue];
        
        _bill = [self calculateFees];
        _bill = [_bill stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }

}

- (IBAction)applyCouponPressed:(id)sender {
    
    NSString *formattedCouponCode = [self URLEncodeStringFromString:_coupon.text];
    NSString *url = [NSString stringWithFormat:@"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/coupon.php?couponName=%@",formattedCouponCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = responseObject[@"response"];
        
        //Set discount price appropirately if valid promo code entered
        if([response isEqualToString:@"VALID"]) {
            
            _discount = 5.99;
            
        } else {
            _discount = 0.00;
        }
        
        //Recalculate costs and fix formatting for url
        _bill = [self calculateFees];
        _bill = [_bill stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
    } failure:nil];
}

-(void)tapDetected:(id)sender{
    [self.stripePaymentCardView resignFirstResponder];
    
    [self.visibleScrollView endEditing:YES];
}


/* All methods below here are for adding sufficient space unerneath
 UITextView labels when the user taps them because the keyboard might cover them.
 The code is from Apple's iOS developer library: https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html*/


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

-(void)addButtonBorders {
    _updateTotalButton.layer.borderWidth = .5f;
    _updateTotalButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    _applyCouponButton.layer.borderWidth = .5f;
    _applyCouponButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    _placeOrderButton.layer.borderWidth = .5f;
    _placeOrderButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
}

@end






































