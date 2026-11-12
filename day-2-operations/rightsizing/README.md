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

## Initial offline cost estimates

An upcoming Runner release adds a monthly base-disk estimate to successful manual and Drift observation plan logs. The feature is unreleased and requires a qualified Runner that includes it.

Initial reviewed pricing covers AWS `aws_ebs_volume` `gp3` disks and Azure `azurerm_managed_disk` `Premium_LRS` or `Premium_ZRS` disks with known pricing inputs. Azure custom performance tiers, on-demand bursting and shared-disk charges are excluded. Other configurations, compute, usage charges and GCP prices are outside this initial scope.

The entry reports a known monthly disk subtotal and coverage counts, not the whole Environment's bill or a before/after savings calculation. Unsupported resources remain unpriced, not free. Missing or unknown pricing inputs produce unknown coverage. An all-unpriced plan has no amount.

Estimation runs offline with Pogi `0.2.0` and embedded AWS and Azure USD list-price snapshots dated `2026-10-20`. There is no runtime refresh, pricing account, API key or external plan upload. Discounts and tax are excluded. Set `COST_ESTIMATION_ENABLED=false` in the Runner process environment to opt out. Estimation failure does not change plan or observation success.

These estimates support review of eligible disk configurations. They do not provide automatic rightsizing, recommendations or budgets. Confirm savings against your cloud bill and operational requirements.

## References

- [Platform Orchestrator Documentation](https://docs.stellwerk.dev/platform-orchestrator/)
- [Deployments and plan-only execution](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/deployments/)
- [Offline plan cost estimates](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/offline-plan-cost-estimates/)
- [Platform Orchestrator Terraform Modules](https://github.com/stellwerk-tf-modules)

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
