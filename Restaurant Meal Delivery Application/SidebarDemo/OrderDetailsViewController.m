//
//  OrderDetailsViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-17.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "PaymentAndOverviewViewController.h"

@interface OrderDetailsViewController ()

@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Give button border
    _continueButton.layer.borderWidth = .5f;
    _continueButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    //Helps put in motion the methods that bring unseeable text fields user is editing into view
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapView.numberOfTapsRequired = 1;
    _realView.userInteractionEnabled = YES;
    [self.realView addGestureRecognizer:tapView];
    
    [self restoreEnteredInformation];

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

//Removes keyboard display when user taps anywhere on screen
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PaymentAndOverviewViewController *temp = segue.destinationViewController;
    
    temp.cart = _cart; 
}

- (IBAction)pressedContinue:(id)sender {
    //Check if any required fields are empty. If they are, an alert pops up.
    if([_userName.text isEqualToString:@""] || [_orderAddress.text isEqualToString:@""] || [_phoneNumber.text isEqualToString:@""]) {
        
        //Create/setup alert controller
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Required Fields" message:@"A name, address, and phone number must be provided." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        //Display alert controller
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } else {
        //First update the user's cart appropritately
        _cart.userName = _userName.text;
        _cart.deliveryAddress = _orderAddress.text;
        _cart.apartmentRoomNumber = _roonNumber.text;
        _cart.additionalDetails = _additionalOrderDetails.text;
        _cart.contact = _phoneNumber.text;
        
        [self performSegueWithIdentifier:@"orderCheckout2" sender:self];
    }
}

-(void)tapDetected:(id)sender{
    [self.realView endEditing:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    _cart.userName = _userName.text;
    _cart.deliveryAddress = _orderAddress.text;
    _cart.apartmentRoomNumber = _roonNumber.text;
    _cart.additionalDetails = _additionalOrderDetails.text;
    _cart.contact = _phoneNumber.text;
}



//Restores previously entered delivery information
-(void)restoreEnteredInformation {
    _userName.text = _cart.userName;
    _orderAddress.text = _cart.deliveryAddress;
    _phoneNumber.text = _cart.contact;
    _roonNumber.text = _cart.apartmentRoomNumber;
    _additionalOrderDetails.text = _cart.additionalDetails;
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
@end