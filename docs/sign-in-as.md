# Sign-in-as AKA pretender

Often, it is desirable to be able to view the application from a user's perspective,
particularly when attempting to identify issues that they are experiencing, or to
check what the application would look like from their perspective. We have employed
the gem [pretender](https://github.com/ankane/pretender) to achieve this functionality.

To view login-as a user, an operator can view the list of non-admin users from
`/ops/users` where they may select a user to login as. When impersonating a user
session, `pretender` stores the original user in `true_user` and overrides
`current_user` with the targeted login. The gem integrates with devise with little
effort.

While impersonating another user session, operators will see a bar at the top of the
page, allowing them to exit and return to their own user session at any time.
