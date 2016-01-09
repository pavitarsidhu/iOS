

#import <UIKit/UIKit.h>
#import "SearchResultTableTableViewController.h"
#import "orderCart.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property bool flag;
@property (strong,nonatomic) UISearchController *searchController;
@property (strong,nonatomic) SearchResultTableTableViewController *resultViewController;
@property (strong,nonatomic) NSMutableArray *restaurantInformationArray;
@property (strong,nonatomic) NSString *clickedRestaurantName;
@property (strong,nonatomic) orderCart *cart;


-(void)fetchPosts;
-(void)setupSearchBar;
-(void)setNavigationBarBackgroundColorus;

@end
