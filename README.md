# Example of Ruby / Sinatra application using Redis service for Cloud Foundry

## Usage

```terminal
git clone <URL-OF-THIS-REPOSITORY>
cd app-sinatra-redis
```

```terminal
cf create-service <REDIS-SERVICE> <PLAN> redis-test
cf push
```

```terminal
export appurl=<APPLICATION-URL>
curl -X POST $appurl/service/redis/<KEY> -d <VALUE>
curl $appurl/service/redis/<KEY>
```

You will get the `<VALUE>` you set to the `<KEY>` at the last post.

### Custom startup command
<pre class="terminal">
Custom startup command> bundle exec ruby main.rb -p $PORT 
</pre>
