//
//  ResponceData.m
//  InfyAssignment
//
//  Created by Mukta on 23/01/17.
//  Copyright © 2017 Mukta. All rights reserved.
//

#import "ResponceData.h"

@implementation ResponceData

//Initialize the variables
-(id) init
{
    _title=@"";
    _descriptionDetail=@"";
    _imgUrl = @"";
    return self;
}

//Set the data to the variables
-(id) setData:(NSDictionary *)infoDict
{
    [self setTitle:[infoDict objectForKey:@"title"]];
    [self setDescriptionDetail:[infoDict objectForKey:@"description"]];
    [self setImgUrl:[infoDict objectForKey:@"imageHref"]];
    
    return self;
}
@end
