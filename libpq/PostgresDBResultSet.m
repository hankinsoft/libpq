//
//  PostgresDBResultSet.m
//  libpq
//
//  Created by Kyle Hankinson on 2020-08-21.
//  Copyright © 2020 Kyle Hankinson. All rights reserved.
//

#import "PostgresDBResultSet.h"
#import <libpq/libpq-fe.h>
#include <libpq/postgres_ext.h>
#include <libpq/pg_config_ext.h>

@interface PostgresDBResultSet(Private)

@property(nonatomic,retain) NSArray<NSString*>* columnNames;

@end

@implementation PostgresDBResultSet
{
    PGresult            * pResult;
}

- (id) initWithConnection: (PGconn*) connection
{
    self = [super init];
    if(self)
    {
        pResult = PQgetResult(connection);
        if(pResult)
        {
            int totalFields = PQnfields(pResult);

            NSMutableArray * _columnNames  = [NSMutableArray array];
            
            for(int i = 0; i < totalFields; i++)
            {
                char * columnNamePtr = PQfname(pResult, i);

                NSString * columnName = @"nil";
                if(NULL != columnNamePtr)
                {
                    columnName = [[NSString alloc] initWithUTF8String: columnNamePtr];
                } // End of our columnNamePtr was not null

                [_columnNames addObject: columnName];
            } // End of field loop
            
            // Get our field names
            self.columnNames = _columnNames;
        } // End of we have a result
    }
    
    return self;
} // End of initWithConnection:

- (BOOL) next: (NSError *__autoreleasing  _Nullable *) error
{
    int queryResultStatus = PQresultStatus(pResult);
    if(PGRES_SINGLE_TUPLE == queryResultStatus)
    {
        return YES;
    } // End of no more rows
    
    return NO;
}

- (id) objectForColumnIndex: (NSUInteger) columnIndex
{
    if(NULL == pResult)
    {
        return nil;
    } // End of no result set

    // If our current value is null, then we won't bother doing any other processing.
    if(PQgetisnull(pResult, 0, (int) columnIndex))
    {
        return nil;
    }

    char * dataPointer = PQgetvalue(pResult, 0, (int) columnIndex);

    if(NULL == dataPointer)
    {
        return nil;
    } // End of no dataPointer

    NSString * stringValue = [NSString stringWithUTF8String: dataPointer];
    return stringValue;
} // End of objectForColumnIndex:

@end
