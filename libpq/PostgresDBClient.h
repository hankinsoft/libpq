//
//  PostgresDBClient.h
//  libpq
//
//  Created by Kyle Hankinson on 2020-08-21.
//  Copyright © 2020 Kyle Hankinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostgresDBResultSet.h"

NS_ASSUME_NONNULL_BEGIN

#define kPostgresDBClientErrorDomain      @"PostgresDBClient"

@interface PostgresDBClient : NSObject

- (BOOL) connect: (NSString*) host
        username: (NSString*) username
        password: (NSString*) password
        database: (NSString*) database
           error: (NSError**) pError;

- (BOOL) connect: (NSString*) host
        username: (NSString*) username
        password: (NSString*) password
        database: (NSString*) database
            port: (NSUInteger) port
           error: (NSError**) pError;

- (NSError*) lastError;

- (PostgresDBResultSet*) executeQuery: (NSString*) sql
                                error: (NSError**) pError;

@end

NS_ASSUME_NONNULL_END
