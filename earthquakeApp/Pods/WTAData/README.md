WTAData
=======

WTAData provides a light-weight interface for setting up an asynchronous CoreData stack. WTAData utilizes two NSManagedObjectContexts: main and background, for achieving fast and performant core data access.  The main context is generally used for read access to the core data stack.  The main context updates automatically when changes are saved by the background managed object context.  The background context is primarily used for performing saves in background threads, such as when a network call completes.

## Setup

Setting up a default stack supporting CoreData automigration by providing WTAData with your Core Data model.

`WTAData *data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];`

Once the stack is created, the stack is ready to go.  In additon to the default initialization, WTAData provides some additional initializers for speciifc use-cases as shown below.

````
// Initialize a new configuration
WTADataConfiguration *configuration = [WTADataConfiguration defaultConfigurationWithModelNamed:@"WTADataExample"];

// Set flag for deleting the store on a model mis-match
[configuration setShouldDeleteStoreFileOnModelMismatch:YES];

// Set flag for deleting the store on sql integrity errors
[configuration setShouldDeleteStoreFileOnIntegrityErrors:YES];

// Set flag for using an in-memory store
[configuration setShouldUseInMemoryStore:YES];

[[WTAData alloc] initWithConfiguration:configuration];
`````

## Fetching Entities

Fetching entities from the store is easy using the categories provided by WTAData on NSManagedObjects

```
NSError *error = nil;
WTAData *data = <initialized stack>
[ManagedObject fetchInContext:data.mainContext error:&error];
```

See additional helpers in NSManagedObject+WTAData.h for more information.

## Saving data

WTAData provides simple mechanisms for saving and creating data in the background.  For example, saving new items in the background is as simple as the following lines of code.

```
[self.data saveInBackground:^(NSManagedObjectContext *context) {
    Entity *entity = [Entity createEntityInContext:context];
    entity.stringAttribute = [NSString stringWithFormat:@"Entity Created"];
  } completion:^(BOOL savedChanges, NSError *error) {
    NSLog(@"Changes saved %d with error %@", savedChanges, error);
  }];
  
