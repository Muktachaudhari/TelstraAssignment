//
//  TableViewController_ListView.h
//  InfyAssignment
//
//  Created by Mukta on 23/01/17.
//  Copyright © 2017 Mukta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController_ListView : UITableViewController <UITableViewDataSource>
{
     UIActivityIndicatorView *activityIndicator;
    
}
@property(nonatomic, strong)NSArray *detailArray;
-(void) setDataArray :(NSArray*)dataArray;
@end
