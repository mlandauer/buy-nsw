# How seller onboarding works
## August 2018

The buy.nsw seller onboarding process is a complex user journey:

- users are asked many questions and it may take them a long time to complete
- users may need to save and come back later with all the information they need
- some users invite others from their organisation to help complete the application

It was clear that the default Rails pattern, using a simple form with `new` and `create` actions, would not scale to this problem.

## Splitting the forms up

buy.nsw makes heavy use of form objects to separate the form logic and validations away from the underlying model. In the seller onboarding process, there are around 13 forms which a user needs to complete, plus additional forms for each product created.

All these forms are located in `app/forms/seller_versions` and `app/forms/products`. Each form contains validations for its own fields, and we're using [dry-validation](http://dry-rb.org/gems/dry-validation/) for the validation library.

## Validations and progress

A core principle of the seller onboarding process is to allow invalid or missing data to be persisted. Whilst we validate it at the time, and display any errors to the user, invalid data does not prevent the user from continuing the journey. We only enforce the validation at the point of submission.

The `SellerApplicationProgressReport` looks after this. It takes every form which applies to the seller and products, validates the current data against it, and returns details on which steps are complete, and which are missing. It's used to enforce validation before submission, and it's also used to show "Completed" labels in the task list.

We've experimented with caching elements of the progress report to speed things up. For example, a seller with many products will have a lot of forms that need to be validated before submission. It's currently set to 1 second, as we did not find this to be a huge problem in practice, but it may need adjusting upwards in the future. You could also explore other ways to validate data on the summary pages in one go.

## Rendering the forms

The name of the form object is coerced into an underscored key by the `Sellers::Applications::StepPresenter`, and used to build a path to a partial in the `app/views/sellers/applications/forms` directory. Forms for products follow similar behaviour, but are located in `app/views/sellers/applications/products/forms`.

The key used for the form partial is also used for I18n translations for field labels and hint text. You'll find these in `config/locales/sellers/en.yml`, nested under `sellers.applications.steps`.

We make heavy use of the [enumerize gem](https://github.com/brainspec/enumerize) to populate multiple-choice fields. In this case, Enumerize handles validation and translation automatically, with labels stored under the `enumerize` prefix in the locale file.

## Checking eligibility

As buy.nsw is currently only open to cloud sellers, there's an eligibility check built into the seller onboarding flow. This is based on answers provided in the `SellerVersions::ServicesForm` to either `offers_cloud` or `govdc`. In turn, these fields auto-populate options in the `services` list.

Users who are ineligible at the current time cannot complete the application, and are shown the message in `app/views/sellers/applications/root/_ineligible_seller_alert.html.erb`.
