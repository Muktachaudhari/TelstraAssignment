//
//  ViewController.m
//  InfyAssignment
//
//  Created by Mukta on 23/01/17.
//  Copyright (c) 2017 Mukta. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "WebServiceHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
     self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addNotification];

    //Calling WebServiceHandler fetch on background
    WebServiceHandler *webServiceHandler = [WebServiceHandler new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [webServiceHandler fetch:nil];
    });
    [self addListView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateConstraints];
}
//Add notifications for webservice responce
-(void) addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedData:) name:NotificationReceivedData object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedError:) name:NotificationReceivedError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkCheck:) name:NotificationNetworkCheck object:nil];
}

//Control comes here after webserviceHandler gets data from webservice
-(void) recivedData :(NSNotification*)notification
{
    NSString *titleText = (NSString*)[notification object];
    self.title =  titleText;
    NSArray *dataArray = (NSArray*)[notification userInfo];
    [listView setDataArray:dataArray];
    [listView.tableView reloadData];
}
//Control comes here after webserviceHandler didn't get data from webservice
-(void) receivedError :(NSNotification*)notification
{
    UIAlertView *webserviceErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is some error fetching data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [webserviceErrorAlert show];
}
//Control comes here if network connection is not present
-(void) netWorkCheck :(NSNotification*)notification
{
    UIAlertView *noNetworkAlert = [[UIAlertView alloc] initWithTitle:@"No Network Connection" message:@"No network connection. Please try connecting to the Internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noNetworkAlert show];
}


-(void) addListView
{
    listView = [[TableViewController_ListView alloc] init];
    [listView.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    listView.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:listView.view];
}

//To Update the constraints
-(void)updateConstraints
{
    NSDictionary *viewsDictionary = @{@"tableView":listView.view };
    
    NSArray *constraints;
    
    constraints= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                                         options: 0
                                                         metrics:nil
                                                           views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                                          options: 0
                                                          metrics:nil
                                                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    
}

//Control comes here after rotating device
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
