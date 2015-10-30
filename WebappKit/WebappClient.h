//
//  WebappClient.h
//  WebappKit
//
//  Created by Jason Brennan on 2015-10-30.
//  Copyright © 2015 Jason Brennan. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const WebappAuthToken;
extern NSString * const WebappAPISecret;


/** Callback type for logging in. */
typedef void(^WebappClientLoginCompletion)(NSString *authToken, NSString *apiSecret);


/** Basic client class for interfacing with my Webapp-derived projects. Made in Objective C because dealing with JSON in Swift is a monster. */
@interface WebappClient : NSObject


/** Initializes the client with the given baseURL. The baseURL should include the port, if needed. */
+ (instancetype)newWithBaseURL:(NSString *)baseURL;


/** Synchronously logs in to the server. The email and password are not stored, but the API secret returned is stored. */
- (void)syncronouslyLogInWithEmail:(NSString *)email password:(NSString *)password completion:(WebappClientLoginCompletion)completion;

@end
