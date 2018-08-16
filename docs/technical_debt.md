# Technical debt in the application
## August 2018

The first version of buy.nsw was a minimum viable product (MVP) and, as with all digital products, as we learn more about how our users actually use the product, it's refined our thinking about the user journeys, operational workflows and data models.

Likewise, as we get more practical experience of working with the particular mix of libraries and technologies for the project, we're able to make more informed choices about the future direction of the codebase.

In the run up to end-August 2018, we've focussed on using these learnings to refactor the application to make it easier for future team members to pick it up fresh. This is often called fixing 'technical debt'. We've made substantial progress on this across the application. This document explains the rationale behind our decisions, and some considerations for future team members working on the platform.

**NOTE!** Whilst this document covers broader pieces of refactoring work, we've documented smaller chores or future ideas in [the list of issues on the GitHub repository](https://github.com/digitalnsw/buy-nsw/issues).

## 1. Moving to immutable records of seller and product details

Integrity is a core foundation of buying processes in government. In our software, integrity means having robust processes for reviewing new and updated seller profiles, and having a clear audit history for what happened when.

buy.nsw started out with the concepts of `Seller`, and `SellerApplication` – respectively containing the seller profile (eg. contact details), and metadata on the application itself (eg. who submitted it and who reviewed it).

When it comes to supporting versioned changes for a seller profile, we were faced with a few challenges:

- simply adding a gem like `paper_trail` to the model would give us an audit history, but no ability for substantial changes (eg. a new authorised representative) to be reviewed by the operations team prior to publication
- as with the initial seller application, sellers should be able to stage multiple changes at once, potentially working with multiple team members, before submitting a new version
- as the platform and procurement policy evolves, there is a need for government to ask sellers to provide new or updated information

Our solution was to migrate to a different data model, based on immutability of versions after publication:

- the `Seller` model, which contains solely an identifier and status field (`active` or `inactive`)
- the `SellerVersion` model, which contains the full seller profile, along with its review state.

In theory, once a `SellerVersion` has been approved, the details shouldn't be changed, ever. Subsequent changes should be made by duplicating the current version, making the changes, and pushing through the approvals workflow. (For simple changes, the approval could be automatic.)

We have made all the changes to migrate sellers to this data structure. This included:

- 'flattening' associated models (eg. seller addresses and awards) into a single table, using PostgreSQL's array and JSON column types
- converting the `Document` model to also become immutable, with the ID of the specific file stored on the `SellerVersion` (or `Product`)

This now means that work can be done to build the user-facing functionality for updating seller details. Once this has been done for sellers, a similar approach should be taken to version the `Product` model.

## 2. Removing Trailblazer from the application

On building the first version of buy.nsw, we used the [Trailblazer framework](http://trailblazer.to) to model complex business operations in a robust and testable way. For example, making a decision on a seller application involves checking the state, updating the state, logging an event and sending an email to the applicant.

We really liked the pattern, particularly the idea executing steps in order until one fails. However, in our team we've found Trailblazer hard to work with in practice. There's a lot of magic to learn, and most of the operation data gets passed around in a large hash, which added additional cognitive overhead to our team when picking up an operation fresh.

We prototyped the same behaviour as a plain-old Ruby object (PORO), which are now found in `app/services`, and we've gone ahead to refactor many of the existing operations in this way. Do note that we still use Reform to build form objects.

There's some future work required to complete this: a few operations remain in the `app/concepts` directory, and then the associated controllers will require refactoring to remove the Trailblazer `run` helper method.

## 3. Simplifying the step presenters

We've been through multiple iterations of the user journey for seller and buyer onboarding over the past 6 months. Each iteration has been simpler, both in terms of user experience and technical implementation. As a result, we've been able to cut out lots of controller code and simplify the forms.

With the new, simpler implementation, it's' worth investing time in the future to review the step presenters in `app/presenters` and figure out what their purpose ought to be.

## 4. Restructuring the JavaScript

We don't use a lot of JavaScript in buy.nsw – the majority of functionality is delivered through server-side code. We use JavaScript to progressively enhance a few areas, like adding multiple addresses to the seller profile, or submitting a problem report at the bottom of the page.

There's some duplication between `expanding_list.js` and `detailed_expanding_list.js` which would be worth resolving. The former is a simplified version, made for fields which are arrays of single text fields. The latter is the original code used for handling multi-field arrays, which we're now only using for addresses.

We'd like to look at a library like [stimulus](https://github.com/stimulusjs/stimulus) as a way to reorganise and simplify JavaScript in the future, and make it easier in our code to see where JavaScript may affect the DOM.
