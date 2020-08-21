//
//  PostgresDBResultSetPrivate.h
//  libpq
//
//  Created by Kyle Hankinson on 2020-08-21.
//  Copyright © 2020 Kyle Hankinson. All rights reserved.
//

#ifndef PostgresDBResultSetPrivate_h
#define PostgresDBResultSetPrivate_h

#import "libpq-fe.h"
#include "postgres_ext.h"
#include "pg_config_ext.h"

@interface PostgresDBResultSet(Private)

- (id) initWithConnection: (PGconn*) connection;

@end

#endif /* PostgresDBResultSetPrivate_h */
