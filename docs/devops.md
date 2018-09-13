# Operations Manual

## Github
The digitalnsw/buy-nsw repository is owned by the digitalnsw github organization. New team members
should be added to the organization rather than given explicit write access to the buy-nsw repo,
as access to several integrations (eg circleci) are tied directly to the organization.

The repository is set up such that commits to `master` are banned - all changes should be made by
pushing a branch to `origin` and submiting a pull request (either on github.com, or using
[hub](https://hub.github.com)). Pull requests must be reviewed by at least one team member, and must
also pass multiple integration checks (pass all tests, pass codeclimate review).

## AWS
BuyNSW is deployed on AWS, under the `buynsw` account. New team members should have an IAM user
created for them by another team member. After gaining access to AWS, developers should install
`awsebcli` using `pip` and also consider installing `awscli` and `awslogs`. Follow the installation
and configuration guides for each respective tool.

## `app-staging`
[CircleCI](https://circleci.com/gh/digitalnsw) is set up to CI/CD `origin/master` onto staging.


