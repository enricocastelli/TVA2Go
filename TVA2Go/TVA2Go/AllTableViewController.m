//
//  FullVideoViewController.m
//  TVA2Go
//
//  Created by Alyson Vivattanapa on 11/24/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "AllTableViewController.h"
#import "PinnedViewController.h"
#import "TAAYouTubeWrapper.h"
#import "RankingTableViewCell.h"
#import "TVA2Go-Swift.h"
#import "MostPinnedTableViewController.h"
#import "HomeViewController.h"

@interface AllTableViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *videos;
@property (strong, nonatomic) NSString *stringSearch;
@property (strong, nonatomic) UITextField *searchField;

@end

@implementation AllTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;


    self.stringSearch = @"";
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"RankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"empty"];
   
    [TAAYouTubeWrapper videosForUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        self.videos = [videos mutableCopy];
        [self.tableView reloadData];
        [self createHeader];
        self.tableView.hidden = NO;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self setNav];
}

- (void)createHeader
{
    
    UIView * header = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil]firstObject];
    
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    self.tableView.tableHeaderView = header;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    
    
    UILabel * allLabel = [header viewWithTag:4];
    allLabel.hidden = NO;
    
    UIButton*mine = [header viewWithTag:2];
    [mine addTarget:self action:@selector(pushMine) forControlEvents:UIControlEventTouchUpInside];
    UILabel * mineLabel = [header viewWithTag:5];
    mineLabel.hidden = YES;
    UIButton*most = [header viewWithTag:3];
    [most addTarget:self action:@selector(pushMost) forControlEvents:UIControlEventTouchUpInside];
    UILabel * mostlabel = [header viewWithTag:6];
    mostlabel.hidden = YES;
    
}

- (void)setNav
{
   
    self.navigationItem.title = @"All Videos";
    
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:22.0f], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *home = [UIImage imageNamed:@"Home"];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:home style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.navigationItem.leftBarButtonItem = homeButton;
    
    UIImage *searchImage = [UIImage imageNamed:@"Search"];
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = search;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.videos.count == 0){
        return 1;
    } else {
        return self.videos.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.videos.count == 0){
        
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"empty" forIndexPath:indexPath];
        
        cell.textLabel.text = @"NO VIDEOS FOUND";
        
        self.tableView.allowsSelection = NO;
        
        return cell;
        
    } else {
            RankingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        GTLYouTubeVideo *video = self.videos[indexPath.row];
        
        cell.titleLabel.text = video.snippet.title;
        
        
        NSURL *url = [NSURL URLWithString:video.snippet.thumbnails.standard.url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage*im = [UIImage imageWithData:data];
        cell.imageThumbnail.image = im;
        [cell.imageThumbnail loadInBackground];
        cell.pinImage.alpha = 0;
        cell.rankingLabel.alpha = 0;
        
        self.tableView.allowsSelection = YES;

        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FullVideoSwift *f = [[FullVideoSwift alloc] initWithNibName:@"FullSwiftViewController" bundle:nil];
    f.fullVideo = self.videos[indexPath.row];
    
    [self.navigationController pushViewController:f animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView * _Nonnull)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)pushMine
{
    PinnedSwiftViewController *pin = [[PinnedSwiftViewController alloc] initWithNibName:@"PinnedSwiftViewController" bundle:nil];
    HomeViewController *h = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers: @[h,pin]];
    [self.navigationController popToViewController:pin animated:YES];
}

- (void)pushMost
{
    MostPinnedTableViewController *most = [[MostPinnedTableViewController alloc] init];
    HomeViewController *h = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers: @[h,most]];
    [self.navigationController popToViewController:most animated:YES];
}


- (void)search
{
    self.tableView.hidden = YES;
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.placeholder = @"Search";
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;
    [searchField becomeFirstResponder];
    UIBarButtonItem *searchGo = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchGo)];
    self.navigationItem.rightBarButtonItem = searchGo;
    self.stringSearch = searchField.text;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.stringSearch = textField.text;

}


- (void)searchGo
{
    [self setNav];
    [self.searchField resignFirstResponder];
    NSMutableArray *arra = [[NSMutableArray alloc] init];

    [TAAYouTubeWrapper videosForUser:@"TVAcademyNL" onCompletion:^(BOOL succeeded, NSArray *videos, NSError *error) {
        self.videos = [videos mutableCopy];
    }];
    for (GTLYouTubeVideo *video in self.videos) {
        
        if ([video.snippet.title.lowercaseString containsString:self.searchField.text.lowercaseString]) {
            
            [arra addObject:video];
        }
    }
    self.videos = arra;

    self.navigationItem.titleView = nil;
    [self.tableView reloadData];
    
    self.tableView.hidden = NO;
}





@end
