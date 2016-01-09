//
//  RegisterAccountViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-07-24.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "RegisterAccountViewController.h"
#import "AFNetworking.h"

@interface RegisterAccountViewController ()

@end

@implementation RegisterAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarBackgroundColorus];
    [self.view setBackgroundColor:[UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f]];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; 
}

- (IBAction)registerButtonPressed:(id)sender {
    
    //Checks if a reguired field is empty
    //REMINDER: ADD CHECK TO SEE IF TERMS AND CONDITIONS HAVE BEEN ACCEPTED TOO
    if([_userNameField.text  isEqual: @""] || [_passwordField.text  isEqual: @""] || [_firstNameField.text  isEqual: @""] || [_lastNameField.text isEqual: @""]) {
       
        //Create/setup alert controller
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Required Fields" message:@"All fields must be filled in to register an account." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        //Display alert controller
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } else {
    
        //prepare parameters to pass in URL
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:_userNameField.text,@"username", _passwordField.text,@"password", _firstNameField.text,@"firstName", _lastNameField.text, @"lastName", nil];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
        [manager POST:@"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/register-account.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSString *response = responseObject[@"response"];
        
            if([response isEqualToString:@"success"]) {
                
                //Create/setup alert controller
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Registration Complete" message:@"Your account has been created!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                //Display alert controller
                [alertController addAction:defaultAction];
                [self presentViewController:alertController animated:YES completion:nil];
            
            
            } else if([response isEqualToString:@"taken"]) {
                //Create/setup alert controller
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Username Taken" message:@"The specified username has already been taken. Please try another one." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
                
                //Display alert controller
                [alertController addAction:defaultAction];
                [self presentViewController:alertController animated:YES completion:nil];

            }
        
        } failure:nil];
    
    }
}

-(void)setNavigationBarBackgroundColorus{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
}
@end
