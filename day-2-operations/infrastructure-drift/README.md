# Infrastructure drift detection

Drift Detection is a commercial Stellwerk plugin that checks selected Environments for differences between their deployed configuration and actual infrastructure.

A manual cloud-console change, a failed deployment or an external process can leave infrastructure in a different condition from the one your platform deployed. Drift Detection helps platform teams inspect those differences and decide whether to restore the deployed configuration.

## Choose what to monitor

An organization Admin selects the Environments to monitor in the Console. Filters help you select by Project, Environment Type and Production status. The saved selection contains explicit Environments; creating another Environment does not silently add it to monitoring.

Choose a cron schedule and timezone, or request a manual check of monitored Environments. Checks respect deployment queues and Runner capacity. A busy Environment or full Runner is skipped rather than given another waiting observation job.

The plugin needs a compatible Runner and a trustworthy, reproducible successful deployment baseline. Installation maintenance stops new checks while existing work settles.

## Review findings

Each check runs a normal Terraform/OpenTofu plan with refresh against the captured configuration of the latest trustworthy successful deployment. Detection does not apply that plan or persist refreshed infrastructure state.

Findings distinguish observed changes from the actions proposed to return to the deployed configuration. The Console shows resource types, action counts and finding history without exposing raw state, plan JSON or secret values. Failed or incomplete observations are never presented as clean results.

A finding can become stale after another deployment. Provider refresh can also report normalization of stored state without an external infrastructure edit, so a reported difference is evidence to review, not proof of an unauthorized change.

## Decide how to respond

An Admin can dismiss the current finding with a reason or request an explicit deployment of the last known good configuration. Dismissal does not suppress future findings. A corrective deployment produces a fresh plan and follows the normal deployment and Pin checks; it does not apply the plan saved during detection.

Drift Detection does not automatically remediate infrastructure or deliver alerts to external notification services. Correction is confirmed by a matching successful deployment or a later valid clean observation.

## Get Drift Detection

Drift Detection is licensed separately and can be used independently of Progressive Rollouts. Contact [Stellwerk Labs](mailto:hello@stellwerk.dev?subject=Drift%20Detection) for a demonstration, licensing and access to the plugin for your installation.

## Further reading

- [Deployments](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/deployments/)
- [Module version management](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/module-version-management/)
- [Native plugin lifecycle](https://docs.stellwerk.dev/platform-orchestrator/docs/architecture/plugins/install-and-operate-native-plugins/)

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
