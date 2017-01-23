//
//  ResponceData.h
//  InfyAssignment
//
//  Created by Mukta on 23/01/17.
//  Copyright © 2017 Mukta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponceData : NSObject

@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* descriptionDetail;
@property(nonatomic, retain) NSString* imgUrl;

-(id) setData:(NSDictionary *)infoDict;
@end
