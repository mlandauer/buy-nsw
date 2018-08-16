# How buyer onboarding works
## August 2018

The buyer onboarding process for buy.nsw comes from similar roots as seller onboarding.

Similar to seller onboarding, the onboarding process for buyers:

- is composed of multiple steps, represented as form objects
- enforces validation on all steps at point of submission

We'd recommend having a read of `docs/seller_onboarding.md` to get an understanding of the main concepts here.

## How buyer onboarding is different

Buyer onboarding differs in a few ways:

- steps are presented in order
- there's a conditional step to get manager approval by email
- there is no task list of all steps, but there is a review point before submission

We've modelled the buyer onboarding journey in `app/flows/buyer_application_flow.rb`, which handles both the conditional step check and validation. (This pattern could be extended to seller or product onboarding in future.)

## Requesting manager approval

When the buyer's `employment_status` is `contractor`, the state machine defined in `BuyerApplication` is configured to transition a submitted application to `awaiting_manager_approval` and, when the form is submitted, an email is automatically sent to the nominated manager to approve the application.

Once the manager has approved the application, it progresses to `awaiting_assignment` or `ready_for_review` as per the normal behaviour.
