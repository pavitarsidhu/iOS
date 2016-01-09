#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "RestaurantNameViewCell.h"
#import "RestaurantList.h"
#import <dispatch/dispatch.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RestaurantMenuViewController.h"
#import "orderCart.h"
#import "CategoriesViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated {
    //We need to reset this everytime use returns home
    _cart = [[orderCart alloc]init];
    _cart.orderedItems = [[NSMutableDictionary alloc]init];
    _cart.menuNamesAndPrices = [[NSMutableDictionary alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
        
    //Get list of restaurants and their image URLs
    [self fetchPosts];
    
    //List of restaurants needed to load home page
    _restaurantInformationArray = [[NSMutableArray alloc] init];


    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self setNavigationBarBackgroundColorus];
    
    //setup for sidebar
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        //[_tableView setUserInteractionEnabled:NO];
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //searchBar setup
    [self setupSearchBar];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_restaurantInformationArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantNameViewCell *cell = (RestaurantNameViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"restaurantName" forIndexPath:indexPath];
    
    //Enables touch capabilities for the restaurant logos
    cell.restaurantClicked = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    cell.restaurantClicked.numberOfTapsRequired = 1;
    cell.restaurantLogo.userInteractionEnabled = YES;
    [cell.restaurantLogo addGestureRecognizer:cell.restaurantClicked];
    cell.restaurantLogo.tag = indexPath.row;
    
    //The flag to check if the array containing info for all restaurants has been obtained
    if(_flag == true) {
        
        RestaurantList *currentRestaurant = [_restaurantInformationArray objectAtIndex:indexPath.row];
        
        cell.restaurantName.text = currentRestaurant.name;
        cell.imageAddress = currentRestaurant.imageURL;
        cell.openOrClosed.text = currentRestaurant.hours;
    
        NSString *URL = [NSString stringWithFormat:@"http://amigodash.com/images/%@.png",cell.imageAddress];
        NSURL *url = [NSURL URLWithString:URL];
        
        /*SDWebImage framework manages cache, performance, etc of images 
         with full support for tableViewCells, and it automatically uses Grand
         Central Dispatch, so you do not have to worry about anything! */
        [cell.restaurantLogo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photo.png"]];
    }
    return cell;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

-(void)fetchPosts {
    NSString *address = @"http://ec2-52-26-122-138.us-west-2.compute.amazonaws.com/restaurants.php";
    NSURL *url = [NSURL URLWithString:address];
    
    NSURLSessionDataTask *downloadRestaurants = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *someError;
        NSArray *restaurantInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&someError];
        
         for(NSDictionary *dict in restaurantInfo) {
             RestaurantList *newRestaurant = [[RestaurantList alloc]init];
             
             newRestaurant.name = [dict valueForKey:@"name"];
             newRestaurant.imageURL = [dict valueForKey:@"image"];
             newRestaurant.hours = [dict valueForKey:@"hours"];
             
             [_restaurantInformationArray addObject:newRestaurant];
             
         
             _flag = true;
             
             /*You CANNOT call any UIKit methods in secondary threads, so because of that
             we use GSD to execute "reloadData" in main thread. */
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_tableView reloadData];
             });
         }
    }];
    
    [downloadRestaurants resume];
    
    
}

-(void)setupSearchBar{
    self.resultViewController = [[SearchResultTableTableViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
    self.searchController.searchBar.delegate = self;
    self.resultViewController.tableView.delegate = self;
    [self.searchController.searchBar sizeToFit];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //Colour settings for search bar
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f];
    self.searchController.searchBar.layer.borderColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f].CGColor;
    self.searchController.searchBar.layer.borderWidth = 1;
    self.tableView.backgroundColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f];
}

-(void)setNavigationBarBackgroundColorus{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)tapDetected:(id)sender{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    int specificRestaurantInArray = (int)gesture.view.tag;
    
    RestaurantList *cur = [_restaurantInformationArray objectAtIndex:specificRestaurantInArray];
    _clickedRestaurantName = cur.name;
    
    [self performSegueWithIdentifier:@"menuCategories" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CategoriesViewController *categoryViewController = segue.destinationViewController;
    
    /* This block of code is how you change the controller's back
     button to an image. It may be something to consider changing fully soon.
     
    UIImage *someImage = [UIImage imageNamed:@"amex.png"];
    
    UIBarButtonItem *test = [[UIBarButtonItem alloc]initWithImage:someImage style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = test;
    */
   
    //Set the MenuViewController's restaurant name so it can fetch proper menu
    //And add proper restaurant name to user cart
    _cart.restaurantName = _clickedRestaurantName;
    categoryViewController.restaurantName = _clickedRestaurantName;
    categoryViewController.cart = _cart;
    
}
@end