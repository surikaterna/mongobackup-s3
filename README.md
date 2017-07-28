# Mongobackup - S3

By using this image your container will automatically connect to a secondary mongo replica member to do a full mongodump of the database. Then the dump will get archived and uploaded to S3 and then the /dump folder and archive will be removed.

A few environmental variables need to be defined for the script to work and a service link needs to be setup to connect the two containers. If no Backup schedule is set up using cron the backup needs to be run manually by starting the container since it shuts down after the backup is complete.

### Environmental variables

You need five environmental variables for the backup script to work.

| Variable | Value |
| ------ | ------ |
| AWS_ACCESS_KEY_ID | Your key id. |
| AWS_SECRET_ACCESS_KEY | Your secret access key |
| DATEFORMAT | The dateform you want to use in the backup filename. (e.g %Y-%m-%d-%H-%M-%S) |
| FILEPREFIX | the filename prefix |
| S3BUCKET | The name of your Amazon S3 Bucket to store the backup. |
 - Filename prefix will be FILEPREFIX.DATEFORM.tar.gz


# Service link & Backup scheduling

### Service link
To link your mongodb backup container to the mongodatabase add a service link in rancher using the name "mongo" e.g mongo-cluster -> mongo

### Scheduling
Since the container stops after the backup is complete, it's a good idea to schedule it to run automatically. This is done by adding a label in the rancher webui found under labels when setting up the container or upgrading. This utilizes  [SocialEngine/rancher-cron](https://github.com/SocialEngine/rancher-cron) to run containers on a schedule, examples follow below.

These are example values that can be used.
| Key | Value | example |
| ------ | ------ |------- |
| com.socialengine.rancher-cron.schedule | @every 60m | Runs every hour |
| com.socialengine.rancher-cron.schedule | @every 1d | Runs every day |

If you want to specify another time, use the table below for reference.

Entry                  | Description                                | Equivalent To
-----                  | -----------                                | -------------
@yearly (or @annually) | Run once a year, midnight, Jan. 1st        | 0 0 0 1 1 *
@monthly               | Run once a month, midnight, first of month | 0 0 0 1 * *
@weekly                | Run once a week, midnight on Sunday        | 0 0 0 * * 0
@daily (or @midnight)  | Run once a day, midnight                   | 0 0 0 * * *
@hourly                | Run once an hour, beginning of hour        | 0 0 * * * *
