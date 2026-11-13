# Rightsizing for cost control

Use the Platform Orchestrator to apply reviewed infrastructure sizing changes through normal deployments.

> ℹ️ **Note**
>
> This guide describes a manual workflow. This directory does not contain a runnable rightsizing example. Automatic utilization analysis, sizing recommendations, resizing and budget enforcement are not implemented.

## Review and deploy a sizing change

1. Use your monitoring and cloud billing tools to identify an oversized resource and check its performance requirements.
2. Change the relevant manifest parameter, provided the selected Resource Type and Module expose that sizing option.
3. Run a plan-only deployment and review replacement, data retention and availability implications. A smaller size is not always an in-place change.
4. Apply the reviewed manifest through a normal deployment and verify service behavior and actual cloud costs.

Keep the manifest change and deployment history as the record of what you changed. The Orchestrator executes your selected configuration; it does not decide whether a resource is underutilized.

## Optional infrastructure cost estimates

An upcoming coordinated update adds Infracost estimates to successful manual
and Drift observation plan logs. The integration is unreleased.

An installation administrator supplies an Infracost API key and enables
estimates under **Administration → Configuration → Infrastructure costs**.
Estimates are disabled by default. The key is encrypted in storage, can be
replaced or removed, and is never returned through the settings API.

Plans are processed locally. Infracost receives price queries containing
cost-related characteristics, such as region and instance class, rather than
the full plan. The Runner needs network access to the pricing service; there
is no offline price catalogue. Pricing failures do not stop a successful plan.

AWS, Azure and Google Cloud coverage depends on the pinned calculators and
resource configuration. Unsupported resources remain unpriced. Usage-dependent
charges need assumptions, so a partial monthly estimate is not the whole
Environment's bill or a guarantee of savings.

These estimates support review of sizing changes. They do not provide automatic
rightsizing, recommendations or budgets. Confirm savings against your cloud bill
and operational requirements.

## References

- [Platform Orchestrator Documentation](https://docs.stellwerk.dev/platform-orchestrator/)
- [Deployments and plan-only execution](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/deployments/)
- [Infrastructure cost estimates](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/infrastructure-cost-estimates/)
- [Platform Orchestrator Terraform Modules](https://github.com/stellwerk-tf-modules)

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
