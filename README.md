[![Build Status](https://ci.eknoes.de/buildStatus/icon?job=redis-dart-wrapper%2Fmaster)](https://ci.eknoes.de/blue/organizations/jenkins/redis-dart-wrapper/activity)

A simple wrapper for [redis-dart](https://github.com/ra1u/redis-dart/) that provides logging and manages a single redis connection as recommended by the author of [redis-dart](https://github.com/ra1u/redis-dart/issues/5#issuecomment-279018105) for maximum performance.
Currently it relies on some modifications of redis-dart, when these are merged the dependencies are modified to the current upstream version.

## Usage

A simple usage example:

```dart
import 'package:redis/redis.dart';
import 'package:redis_wrapper/redis_wrapper.dart';

main() async {
  final RedisWrapper redis = RedisWrapper();

  // Use it for transactions
  Transaction ta = await redis.multi();
  ta.send_object(["SADD", "project_ids", 1]);
  ta.send_object(["SADD", "project_ids", 2]);

  if(await ta.exec() != "OK") {
    print("Could not add id");
  };

  // Use it for commands
  String result = await redis.send(["SMEMBERS", "project_ids"]);

  // Close Connection
  await redis.close();
}
```
