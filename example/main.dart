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
