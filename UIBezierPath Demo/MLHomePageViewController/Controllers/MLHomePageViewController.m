//
//  MLHomePageViewController.m
//  UIBezierPath Demo
//
//  Created by CristianoRLong on 16/8/25.
//  Copyright © 2016年 CristianoRLong. All rights reserved.
//

#import "MLHomePageViewController.h"
#import "MLBaseViewController+Constructor.h"
#import "MLBaseViewController+NavigationBar.h"
#import "MLBaseCell+Shaking.h"
#import "MLHomePageModel.h"
#import "MLHomePageCell.h"
#import <Mantle/Mantle.h>

@interface MLHomePageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MLHomePageModel *homePageModel;

@end

@implementation MLHomePageViewController
#pragma mark - Initialize Methods And Dealloc Method
#pragma mark -
#pragma mark Dealloc
- (void) dealloc {
    NSLog(@"%@: Dealloced", [self class]);
}

#pragma mark - UIViewController Life Circle
#pragma mark -
#pragma mark Load View
- (void)loadView {
    [super loadView];
}

#pragma mark View Did Load
- (void) viewDidLoad {
    [super viewDidLoad];
    
    // 1. Configure UI
    [self configureUI];
    
    // 2. Configure NavigationBar
    [self configureNavigationBar];
}

#pragma mark View Will Appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.tableView reloadData];
}

#pragma mark View Did Appear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

#pragma mark View Will Disappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

#pragma mark View Did Disappear
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
}


#pragma mark - Basic Setup Methods
#pragma mark -
#pragma mark Configure UI
- (void) configureUI {
    
    // 1. TableView
    [self.view addSubview: self.tableView];
    
    // 2. Background Image View
    [self configureBackgroundImageView];
}

#pragma mark Configure Navigation Bar
- (void)configureNavigationBar {
    [super configureNavigationBar];
    
    // 1. Title
    [self addNavigationTitle: @"CAShapeLayer Demo"];
}


#pragma mark - Override Methods
#pragma mark -
#pragma mark <#Method Name#>


#pragma mark - Lazy Load
#pragma mark -
#pragma mark Lazy Table View
- (UITableView *) tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: self.view.bounds
                                                  style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    return _tableView;
}

#pragma mark Lazy Home Page Model
- (MLHomePageModel *) homePageModel {
    
    if (!_homePageModel) {
        
        NSDictionary *modelDict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"MLTableViewDataSource"
                                                                                                ofType: @"plist"]];
        NSError *error = nil;
        _homePageModel = [MTLJSONAdapter modelOfClass: MLHomePageModel.class
                                                   fromJSONDictionary:modelDict
                                                                error:&error];
        NSAssert(!error, error.localizedDescription);
        
        NSLog(@"%@", [_homePageModel.list firstObject].list);
    }
    
    return _homePageModel;
}

#pragma mark - Network Methods
#pragma mark -
#pragma mark <#Method Name#>


#pragma mark - Public Methods
#pragma mark -
#pragma mark <#Method Name#>


#pragma mark - Private Methods
#pragma mark -
#pragma mark Configure Home Page Cell
- (__kindof MLBaseCell *) obtainHomePageCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(&*self)weakSelf = self;
    MLHomePageCell *cell = [MLHomePageCell cellInTableView: tableView
                                           reuseIdentifier: NSStringFromClass([MLHomePageCell class])];
    cell.jumpModel = [[self.homePageModel.list objectAtIndex: indexPath.section].list objectAtIndex: indexPath.row];
    cell.didClick = ^(MLHomePageCell *cell, MLViewControllerJumpModel *jumpModel){
        [weakSelf jumpViewControllerWithJumpModel: jumpModel];
    };
    return cell;
}


#pragma mark - Action Methods
#pragma mark -
#pragma mark <#Method Name#>


#pragma mark - UITableVie Delegate
#pragma mark -
#pragma mark Did Selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MLHomePageCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
    if ([cell shake]) {
        [cell beginAnimationWithAnimation];
    }
}


#pragma mark - UITableView DataSource
#pragma mark -
#pragma mark Section Count
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homePageModel.list.count;
}

#pragma mark Section Title
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.homePageModel.list objectAtIndex: section].title;
}

#pragma mark Section Height
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark Cell Height
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MLHomePageCell cellHeight];
}

#pragma mark Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.homePageModel.list objectAtIndex: section] list].count;
}

#pragma mark Cell Reuse
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self obtainHomePageCellWithTableView: tableView
                                     atIndexPath: indexPath];
}

#pragma mark - ViewController Jump Methods
#pragma mark -
#pragma mark Jump View Controller
- (void) jumpViewControllerWithJumpModel:(MLViewControllerJumpModel *)jumpModel {
    
    MLBaseViewController *viewController = [NSClassFromString(jumpModel.destination) viewController];
    [self.navigationController pushViewController: viewController
                                         animated: YES];
}

@end
