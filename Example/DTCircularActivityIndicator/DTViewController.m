//
//  DTViewController.m
//  DTCircularActivityIndicator
//
//  Created by Thinh Vo on 23/04/2018.
//

#import "DTViewController.h"
#import <DTCircularActivityIndicator/DTCircularActivityIndicator.h>

@interface DTViewController ()
@property(nonatomic, strong) DTCircularActivityIndicator *activityIndicator;
@end

@implementation DTViewController

#pragma mark - Life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.activityIndicator];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGSize activityIndicatorSize = CGSizeMake(50, 50);
    
    CGFloat indicatorX = (screenSize.width - activityIndicatorSize.width) / 2;
    CGFloat indicatorY = (screenSize.height - activityIndicatorSize.height) / 2;
    
    self.activityIndicator.frame = CGRectMake(indicatorX, indicatorY, activityIndicatorSize.width, activityIndicatorSize.height);
    self.activityIndicator.colors = @[UIColor.blueColor, UIColor.grayColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.activityIndicator startAnimating];
}

#pragma mark - Properties
- (DTCircularActivityIndicator *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[DTCircularActivityIndicator alloc] initWithFrame:CGRectZero];
    }
    
    return _activityIndicator;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
