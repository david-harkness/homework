## Answer to Part 2 Problem 2
There is a single table for dealing with all 3 level of organizations.
 - Essentially pseudo-polymorphic table. 
There is a table for dealing with users
and a join table that includes the specified role.
Recursive is used to find the correct role for any given user / organization.

No DB is required.
I am using an in-memory db, but no setup is needed for it. 

## Testing
    rake test
    
    