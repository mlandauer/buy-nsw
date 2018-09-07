# Soft Deletion AKA discard

Soft deletion of models is a very useful feature. It allows us to
1. safely delete models without fear of irreversibly corrupting the state
   of the database (we can un-delete things very easily)
2. maintain 'deleted' data in case we need to retrieve it later

We use the gem [discard](https://github.com/jhawthorn/discard) to achieve a simple soft deletion
implementation. `discard` is a third-generation implementation of soft deletion and is pretty
mature.

The primary intention of discarding records is to act __only__ as a deletion substitute.
We __do not__ intend to utilise discard for any versioning purposes.
`undiscard` callbacks are intentionally left unimplemented - needing to undiscard
a model should be a very rare case, ideally it should never happen.

As of build-1468, the discardable models are:
- BuyerApplication
- SellerVersion
- Product
- Seller (cascades to SellerVersion, Product and User)
- User (conditionally cascades to Seller, Buyer)

As discard was introduced quite late into buy.nsw's development, it was easier
to override the default scope of the discardable models to hide discarded ones,
rather than rewrite all references to use the discarded objects. When discarding
models, be careful to ensure that relevant models are either discarded themselves,
or are tolerant of related objects not existing in default scope. An example of this
is `/ops/seller-applications/{id}` where the events listing is aware of the
possibility that an event's user could be discarded.

The scopes available are:
```ruby
User.kept                       # only non-discarded records - default scope
User.with_discarded             # all records regardless of discard state
User.with_discarded.discarded   # only discarded records
```

To discard objects:
```
User.find(123).discard              # Discard one record
Seller.find(55).owners.discard_all  # Discard a collection of records
```

Cascades are implemented by supplying an `after_discard` callback on a discardable
model ([example](https://github.com/digitalnsw/buy-nsw/blob/2cb7d6123fcad587190180bce23f0ee5a52249a3/app/models/seller.rb#L49)).
