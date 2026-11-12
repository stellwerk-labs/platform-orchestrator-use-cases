# Progressive rollouts

Progressive Rollouts is a commercial Stellwerk plugin for deploying Module Version changes across Environments in controlled waves.

Updating a shared infrastructure Module can affect many applications. A database or network change that works in one Environment may still fail elsewhere. Progressive Rollouts lets platform teams select the target Environments, review the proposed changes and control how far each update proceeds.

## Prepare and review the change

Publish the candidate Module Version, then design a rollout using explicit Environments or Project, Environment Type and label selectors. Preview the targets and proposed changes before preparing the rollout.

Preparation freezes a plan revision and its target set. Review conflicts, Environment Pins and the planned deployment changes before starting. Approvals are tied to that plan revision and their Environment or Project scope, so an approval is not blanket permission for a different plan.

## Execute in waves

Arrange targets into waves, for example development first, staging second and production last. Each wave can specify:

- the Environments to update;
- the maximum deployment concurrency;
- required approvals;
- a bake period before further progression; and
- retry limits and manual or automatic progression.

The plugin starts ordinary Orchestrator deployments and records rollout progress and events. Default promotion is an explicit rollout policy. Starting a rollout does not mean every Environment changes at once.

Use the bake period to inspect application behavior with your own observability tools. Automatic progression follows the configured policy; it does not provide automatic metric-based health analysis or automatic rollback.

## Stop or recover deliberately

Pause a rollout to stop new forward work, then resume when you are ready. Cancellation prevents further progression; it does not erase deployments already executed. Existing Environment Pins remain constraints, with any override requiring its own authorization.

When recovery is needed, request an explicit rollback for an Environment or the rollout. A rollback is another infrastructure deployment, subject to retained material and the usual recovery limits. It is not a restore of lost application data.

## Get Progressive Rollouts

Progressive Rollouts is licensed separately. Contact [Stellwerk Labs](mailto:hello@stellwerk.dev?subject=Progressive%20Rollouts) for a demonstration, licensing and access to the plugin for your installation.

## Further reading

- [Impact analysis](https://docs.stellwerk.dev/platform-orchestrator/docs/use-cases/impact-analysis/)
- [Module version management](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/module-version-management/)
- [Environment version Pins](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/environment-version-pins/)
- [Rollback](https://docs.stellwerk.dev/platform-orchestrator/docs/use-cases/rollback/)

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
