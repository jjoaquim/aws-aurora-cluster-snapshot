# AWS Aurora Cluster Snapshot Action


This Action allows you to create AWS Aurora Cluster Snapshot & Posts a message to slack channel.

## Parameters
| Parameter | Type      | Default      | Description |
|-----------|-----------|--------------|-------------|
| `access_key_id` | `string`  |              | Your AWS access key id |
| `secret_access_key` | `string`  |              | Your AWS secret access key |
| `region` | `string`  |              | Your AWS region |
| `cluster_name` | `string`  |        | AWS Aurora Database Cluster Name |
| `slack_webhook` | `string`  |        | Slack Webhook URL |
| `prefix` | `string` | `backup`     | Prefix of the backup |

## Usage

```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: Durgaprasad-Budhwani/aws-aurora-cluster-snapshot@v1
      with:
        access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        region: ${{ secrets.REGION }}
        cluster_name: ${{ secrets.CLUSTER_NAME }}
        slack_webhook: ${{ secrets.SLACK_WEBHOOK }}
        prefix: backup
```

If you don't want to use the latest docker image, you can point to any reference in the repo directly.

```yaml
  - uses: jjoaquim/aws-aurora-cluster-snapshot@main
```
Forked from https://github.com/Durgaprasad-Budhwani/aws-aurora-cluster-snapshot
## License
The MIT License (MIT)
