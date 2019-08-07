import 'package:logging/logging.dart';
import 'dart:io';

import 'package:redis/redis.dart';

class RedisWrapper {
  final Logger _logger = Logger("RedisWrapper");
  final RedisConnection _connection = RedisConnection();
  Command _cmd;
  final String redisHost;
  final int redisPort;

  RedisWrapper({this.redisHost = "127.0.0.1", this.redisPort: 6379}) {
    _connection.connect(redisHost, redisPort);
  }

  Future<Command> _getRedisCmd() async {
    try {
      if(_cmd == null) {
        _cmd = await _connection.connect(redisHost, redisPort);
      }
      return _cmd;
    } on SocketException catch (e) {
      _logger.severe("getRedisCmd: Could not connect to Redis Server on " + e.address.host + ":" + e.port.toString());
      rethrow;
    } on RedisError catch(e) {
      _logger.severe("getRedisCmd: Could connect to Redis Server, but received an error: " + e.e);
      rethrow;
    }
  }

  void testConnection() async {
    Command cmd = await _getRedisCmd();
    String response = await cmd.send_object("PING");

    if (response == "PONG") {
      _logger.fine("Redis connection successfuly established");
    } else {
      _logger.severe("Did not receive PONG: " + response);
    }
  }

  Future send(Object object) async {
    try {
      return (await _getRedisCmd()).send_object(object);
    } on RedisError catch(e) {
      _logger.severe("send: " + e.toString());
      rethrow;
    }
  }

  Future<Transaction> multi() async {
    try {
      return (await _getRedisCmd()).multi();
    } on RedisError catch(e) {
      _logger.severe("send: " + e.toString());
      rethrow;
    }
  }

}