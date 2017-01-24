//
//  TableViewController_ListView.m
//  InfyAssignment
//
//  Created by Mukta on 23/01/17.
//  Copyright © 2017 Mukta. All rights reserved.
//

#import "TableViewController_ListView.h"
#import "TableViewCell_CustomCell.h"
#import "ResponceData.h"
#import "Constants.h"

@interface TableViewController_ListView ()

@end

@implementation TableViewController_ListView


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self loadActivityIndicator];
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _detailArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell_CustomCell *cell;
    static NSString *CellIdentifier = @"Cell";
    cell = (TableViewCell_CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[TableViewCell_CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ResponceData *dataObject = [_detailArray objectAtIndex:indexPath.row];
    if (dataObject)
    {
        NSString *urlString = [[NSString alloc]initWithFormat:@"%@",dataObject.imgUrl];
          NSString *title = [[NSString alloc]initWithFormat:@"%@",dataObject.title];
        if (title.length > 0) {
            cell.title.text = title;
        }
         NSString *description = [[NSString alloc]initWithFormat:@"%@",dataObject.descriptionDetail];
        if (description.length > 0) {
           
            cell.descriptionDetail.text = description;
        }
        
        
        cell.thumbNailImage.image = [UIImage imageNamed:@"defaultImages"];
        // download the image asynchronously
        [self downloadImageWithURL:[NSURL URLWithString:urlString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.thumbNailImage.image = image;
            }
            else
            {

            }
        }];
        
        
    }
    

    return cell;
}
//To manage the table view height according to the data to be displayed 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, CGFLOAT_MAX);
    CGSize size;
    
    ResponceData *responceDataObject = [_detailArray objectAtIndex:indexPath.row];
    NSString *description = [[NSString alloc]initWithFormat:@"%@",responceDataObject.descriptionDetail];
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [description boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:UILabelFont}
                                                   context:context].size;
    
    size = CGSizeMake((boundingBox.width), (boundingBox.height));
    if(size.height > MaxHeight)
        return size.height + CellPadding;
    else
        return DefaultCell_Height;
}

//Loading the activity indicator
-(void) loadActivityIndicator
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

//To Stop the activity indicator
-(void) stopActivityIndicator
{
    [activityIndicator stopAnimating];
}

//To update the constraints
-(void)updateConstraints
{
    NSDictionary *viewsDictionary = @{@"tableView":self.view, @"navbar":self.navigationController.navigationBar};
    
    NSArray *constraints;
    
    constraints= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navbar]-[tableView]|"
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

//To set the data to the Array
-(void) setDataArray :(NSArray*)dataArray
{
    [self stopActivityIndicator];
    _detailArray = dataArray;
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
