//
//  PostgresDBClient.m
//  libpq
//
//  Created by Kyle Hankinson on 2020-08-21.
//  Copyright © 2020 Kyle Hankinson. All rights reserved.
//

#import "PostgresDBClient.h"
#import "PostgresDBResultSetPrivate.h"

#define kDefaultPort 5432

@implementation PostgresDBClient
{
    PGconn  * internalConnection;
}

+ (void) initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int pqlibversion = PQlibVersion();
        NSLog(@"PQlibVersion version: %d", pqlibversion);
        PQinitOpenSSL(1,1);
    });
} // End of initialize

+ (NSString*) escapeConnectionStringEntry: (NSString*) connectionStringEntry
{
    // According to the docs here:
    // http://www.postgresql.org/docs/9.5/static/libpq-connect.html#LIBPQ-CONNSTRING
    // Single quotes and backslashes within the value must be escaped with a backslash, i.e., \' and \\.

    // Escape backslashes first
    connectionStringEntry =
        [connectionStringEntry stringByReplacingOccurrencesOfString: @"\\"
                                                         withString: @"\\\\"];

    // Escape single quotes
    connectionStringEntry =
        [connectionStringEntry stringByReplacingOccurrencesOfString: @"'"
                                                         withString: @"\\'"];

    // We need to surround the connection string with single quotes
    connectionStringEntry = [NSString stringWithFormat: @"'%@'", connectionStringEntry];

    return connectionStringEntry;
} // End of PostgresEscapeConnectionStringEntry:

- (void) dealloc
{
    if(internalConnection)
    {
        PQfinish(internalConnection);
        internalConnection = NULL;
    } // End of we have an internal connection
} // End of dealloc

- (BOOL) connect: (NSString*) host
        username: (NSString*) username
        password: (NSString*) password
        database: (NSString*) database
           error: (NSError**) pError
{
    return [self connect: host
                username: username
                password: password
                database: database
                    port: kDefaultPort
                   error: pError];
} // End of connect:username:password:database:error:

- (BOOL) connect: (NSString*) host
        username: (NSString*) username
        password: (NSString*) password
        database: (NSString*) database
            port: (NSUInteger) port
           error: (NSError**) pError
{
    if(0 == port)
    {
        port = kDefaultPort;
    } // End of no port

    NSMutableArray * connectionOptions = [NSMutableArray array];

    if(database.length > 0)
    {
        [connectionOptions addObject:
            [NSString stringWithFormat: @"dbname='%@'", database]];
    } // End of dbname specified

    if(0 != host.length)
    {
        [connectionOptions addObject: [NSString stringWithFormat: @"host='%@'", host]];
    } // End of host

    [connectionOptions addObject:
     [NSString stringWithFormat: @"port=%ld", (unsigned long) port]];

    if(0 != username.length)
    {
        [connectionOptions addObject:
            [NSString stringWithFormat: @"user='%@'", username]];
    } // End of username

    if(0 != password.length)
    {
        NSString * tempPassword = password;

        // NOTE: DO NOT URL ENCODE OUR PASSWORD. It has already been escaped
        // by surrounding by quotes.
        NSString * escapedPassword = [PostgresDBClient escapeConnectionStringEntry: tempPassword];
        [connectionOptions addObject: [NSString stringWithFormat: @"password=%@", escapedPassword]];
    } // End of password

    // Set our sslmode to prefer (the default)
    [connectionOptions addObject: @"sslmode=prefer"];

    NSString * connectionString = [connectionOptions componentsJoinedByString: @" "];

    // Connect
    internalConnection = PQconnectdb(connectionString.UTF8String);

    // Check if we succeeded
    if (PQstatus(internalConnection) != CONNECTION_OK)
    {
        if(pError)
        {
            *pError = [self lastError];
            return NO;
        }
    } // End of we failed to connect

    return YES;
} // End of connect:...

- (NSError*) lastError
{
    if(nil == internalConnection)
    {
        return [NSError errorWithDomain: kPostgresDBClientErrorDomain
                                   code: 0
                               userInfo: @{NSLocalizedDescriptionKey : @"Unknown error. (No connection to the server)."}];
    } // End of no internal connection

    const char * pErrorMessage = PQerrorMessage(internalConnection);
    if(nil == pErrorMessage)
    {
        return [NSError errorWithDomain: kPostgresDBClientErrorDomain
                                   code: 0
                               userInfo: @{NSLocalizedDescriptionKey : @"Unknown error (no error information available)."}];
    }

    NSString * errorMessage = [NSString stringWithUTF8String: pErrorMessage];
    return [NSError errorWithDomain: kPostgresDBClientErrorDomain
                               code: 0
                           userInfo: @{NSLocalizedDescriptionKey : errorMessage}];
} // End of lastError

- (PostgresDBResultSet*) executeQuery: (NSString*) sql
                                error: (NSError**) pError
{
    if(NULL == internalConnection)
    {
        return NULL;
    } // End of mysql was null

    const char * pSQL = sql.UTF8String;
    if(0 == PQsendQuery(internalConnection, pSQL))
    {
        NSString * queryError = [NSString stringWithUTF8String: PQerrorMessage(internalConnection)];
        NSLog(@"Query failed: %@", queryError);
        
        if(pError)
        {
            *pError = [self lastError];
        }

        return NULL;
    } // End of failed to execute query

    PostgresDBResultSet * resultSet = NULL;
    resultSet = [[PostgresDBResultSet alloc] initWithConnection: internalConnection];

    return resultSet;
}

@end
