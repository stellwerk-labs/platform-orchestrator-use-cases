# Rollback

The Orchestrator can roll back an Environment by redeploying the manifest and resource graph from an earlier Deployment.

If a deployment introduces an application or infrastructure problem, choose a known good Deployment from that Environment's history. The rollback uses its retained manifest, resource graph and Module Version identities instead of resolving the Environment again through today's Module Rules and Defaults.

## Review before applying

Use `octl rollback` with the Project ID, Environment ID and target Deployment ID. Replace these example identifiers with your own:

```shell
octl rollback my-project my-environment 01234567-89ab-cdef-0123-456789abcdef --dry-run
octl rollback my-project my-environment 01234567-89ab-cdef-0123-456789abcdef --plan-only
```

These modes serve different purposes. `--dry-run` validates the request without creating or executing a Deployment. `--plan-only` runs infrastructure planning without applying changes. Inspect the plan for resource replacement, deletion and other consequences before proceeding.

Run the rollback after reviewing the result:

```shell
octl rollback my-project my-environment 01234567-89ab-cdef-0123-456789abcdef
```

The command prompts for confirmation. The rollback appears as a new Deployment in the normal history, with its own status, logs and outputs. The API also supports rollback deployments.

## Retain what recovery needs

Keep the historical deployment records and required Module source and Provider material available. Module Version identity alone does not make a mutable external source reproducible. Missing or changed required material can stop the rollback.

The Data Plane also retains the authorized historical Provider binding needed when a target Module Version drops a Provider that existing resources still use. This supports planning and cleanup without substituting another Provider configuration.

A rollback does not restore earlier Provider credentials or Runner configuration. It plans against current infrastructure state and can still propose destructive actions. Restoring application data or reversing a database migration requires its own recovery procedure and backups.

## Coordinate recovery across Environments

A normal rollback targets one Environment. For coordinated changes across several Environments, the commercial [Progressive Rollouts](https://docs.stellwerk.dev/platform-orchestrator/docs/use-cases/progressive-rollouts/) plugin adds wave control and explicit rollout rollback operations.

## Further reading

- [Rollback deployments](https://docs.stellwerk.dev/platform-orchestrator/docs/deploy/rollbacks/)
- [Module migration and retention](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/upgrade-state-migration-and-retention/)
- [Module source and verification](https://docs.stellwerk.dev/platform-orchestrator/docs/configure/modules/module-version-management/#external-source-and-verification)

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
