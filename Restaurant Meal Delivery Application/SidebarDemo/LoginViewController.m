//
//  LoginViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-07-24.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set background color of navigation bar and view controller
    [self setNavigationBarBackgroundColorus];
    [self.view setBackgroundColor:[UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f]];
    
    //Add borders to login/register buttons
    //Give button border
    _loginField.layer.borderWidth = .5f;
    _loginField.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    _registerField.layer.borderWidth = .5f;
    _registerField.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
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
- (IBAction)loginPressed:(id)sender {
    
    //prepare parameters to pass in URL
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:_usernameTextField.text,@"username", _passwordTextField.text,@"password", nil];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/user-login.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = responseObject[@"response"];
        
        if([response isEqualToString:@"success"]) {
            [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
            
            
        } else if([response isEqualToString:@"fail"]) {
            //Create/setup alert controller
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication Failed" message:@"Username or password incorrect." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            
            //Display alert controller
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        
    } failure:nil];
    
}

- (IBAction)registerPressed:(id)sender {
    [self performSegueWithIdentifier:@"registerAccount" sender:self];
}

-(void)setNavigationBarBackgroundColorus{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
}

@end
