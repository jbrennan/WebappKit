//
//  WebappClient.m
//  WebappKit
//
//  Created by Jason Brennan on 2015-10-30.
//  Copyright © 2015 Jason Brennan. All rights reserved.
//

#import "WebappClient.h"


NSString * const WebappAuthToken = @"WebappAuthToken";
NSString * const WebappAPISecret = @"WebappAPISecret";

@interface WebappClient ()
@property (copy) NSString *baseURL;
@end


@implementation WebappClient


+ (instancetype)newWithBaseURL:(NSString *)baseURL {
	WebappClient *client = [self new];
	client.baseURL = baseURL;
	
	return client;
}


- (void)syncronouslyLogInWithEmail:(NSString *)email password:(NSString *)password completion:(WebappClientLoginCompletion)completion {
	
	NSString *loginURL = [self.baseURL stringByAppendingString:@"/api/user/login"];
	
	id credentials = @{@"username": email, @"password" : password};
	
	NSData *json = [NSJSONSerialization dataWithJSONObject:credentials options:0 error:NULL];
	NSURL *login = [NSURL URLWithString:loginURL];
	
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:login];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:json];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
	NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
	
	if ([responseDict[@"status"] isEqual:@"Error"]) {
		NSLog(@"Error logging in...%@", responseDict[@"error"]);
		return;
	}
	NSLog(@"Got login: %@", responseDict);
	
	NSString *authToken = responseDict[@"auth_token"];
	NSString *apiSecret = responseDict[@"api_secret"];
	
	[[NSUserDefaults standardUserDefaults] setObject:authToken forKey:WebappAuthToken];
	[[NSUserDefaults standardUserDefaults] setObject:apiSecret forKey:WebappAPISecret];
	
	completion(authToken, apiSecret);
	
}

@end
