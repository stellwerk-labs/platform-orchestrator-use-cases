# Impact analysis

Use Module Version Management to find which Environments run an affected Module Version before deciding how to respond.

Suppose a PostgreSQL Module Version has an incorrect access-control setting. You need to find the Environments using that version, compare it with a correction, and decide where to deploy first. The Orchestrator provides the version and deployment records for that investigation.

## Find affected Environments

In the Console, open the Module catalogue and select the affected Version. Inspect its usage, lifecycle history and active Environment Pins. Usage reflects the latest trustworthy successful Deployment in each Environment, including when that evidence was observed.

You can also inspect usage and compare two published Versions with `octl`. Replace the example Module ID and versions with your own:

```shell
octl get module-version-usage postgres 1.4.0
octl get module-version-comparison postgres 1.4.0 1.4.1
octl get module-version-history postgres 1.4.0
```

The comparison shows changes to the Module definition, such as inputs, dependencies and declared outputs. It helps you review a correction; it does not predict every cloud resource change or prove application compatibility. Use a plan-only deployment to inspect the proposed infrastructure actions for a particular Environment.

Treat unknown or stale usage as incomplete evidence. An Environment without a trustworthy deployment record cannot be assumed unaffected.

## Choose a response

Test the corrected Version before making it Default. Existing Environment Pins can keep their already-active Version while other Environments move forward. Changing a Default affects later version resolution; it does not update running infrastructure.

If a Version is unsafe, marking it Defective blocks normal adoption. It does not repair Environments already using it or choose a replacement for them. Recovery still needs an explicit decision and deployment.

## Coordinate the rollout

The commercial **Progressive Rollouts** plugin adds a reviewed rollout plan: preview and freeze the selected Environments, arrange them into waves, set concurrency and approval policies, and control execution. It builds on the Orchestrator's Module Versions, deployment history and Pins.

See [Progressive Rollouts](https://docs.stellwerk.dev/platform-orchestrator/docs/use-cases/progressive-rollouts/) for the plugin's capabilities and how to contact Stellwerk Labs.

## Further reading

- [Module version management](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/module-version-management/)
- [Environment version Pins](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/environment-version-pins/)
- [Deployments](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/deployments/)

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
