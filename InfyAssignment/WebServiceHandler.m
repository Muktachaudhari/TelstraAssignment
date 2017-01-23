//
//  WebServiceHandler.m
//  InfyAssignment
//
//  Created by Mukta on 23/01/17.
//  Copyright © 2017 Mukta. All rights reserved.
//

#import "WebServiceHandler.h"
#import "Constants.h"
#import "Reachability.h"
#import "ResponceData.h"

@implementation WebServiceHandler

//Entry point to WebServiceHandler
- (void)fetch:(NSDictionary *)aRequestDictionary
{
    Reachability *internetReachability =[Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetReachability currentReachabilityStatus];
    if (netStatus == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNetworkCheck object:nil];
        });
        
    }
    else
    {
        NSURL *url = [NSURL URLWithString:request_URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [self makeConnection:request callingService:self];
        
    }
}

//Make connection to get data from the webservice
- (void)makeConnection:(NSURLRequest *)aRequest callingService:(id)aService
{
    NSURLSession *tSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *tPostRequestTask = [tSession dataTaskWithRequest:aRequest
                                                         completionHandler:^(NSData *tData, NSURLResponse *tResponse, NSError *tError) {
                                                             
                                                             if(tError == nil) {
                                                                 
                                                                 [self onDataReceived:tData];
                                                                 
                                                                 [tSession finishTasksAndInvalidate];
                                                             }
                                                             else {
                                                                 
                                                                 [aService onError:tError];
                                                                 
                                                                 [tSession finishTasksAndInvalidate];
                                                             }
                                                             
                                                         }];
    [tPostRequestTask resume];
}
//Control comes here after getting data from the webservice
- (void)onDataReceived:(NSData *)aResponseData {
    
    
    NSString *string = [[NSString alloc] initWithData:aResponseData encoding:NSASCIIStringEncoding];
    NSData* mainData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:mainData options:NSJSONReadingAllowFragments error:nil];
    NSArray *dataArray = [jsonData valueForKey:@"rows"];
    NSString *titleHeader = [jsonData valueForKey:@"title"];
    
    NSMutableArray *detailDataArray = [self getDetailsArray:dataArray];
    if (detailDataArray)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceivedData object:titleHeader userInfo:detailDataArray];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceivedError object:nil];
        });
    }
}

//Control comes here after getting the error from webservice
- (void)onError:(NSError *)aError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReceivedError object:nil];
    });
}

-(NSMutableArray *)getDetailsArray:(NSArray *)dataArray
{
    NSMutableArray *detailDataArray = [[NSMutableArray alloc]init];
    for(NSDictionary *tempDict in dataArray)
    {
        ResponceData *responceData = [[ResponceData alloc]init];
        if(!(([tempDict objectForKey:@"title"] == [NSNull null]) && ([tempDict objectForKey:@"description"] == [NSNull null]) && ([tempDict objectForKey:@"imageHref"] == [NSNull null])))
        {
            [responceData setData:tempDict];
            [detailDataArray addObject:responceData];
        }
    }
    return detailDataArray;
}
@end
