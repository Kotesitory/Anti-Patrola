import 'package:flutter/cupertino.dart';

class NetworkException implements Exception{
  String message;
  Exception innerException;

  NetworkException({@required this.message, this.innerException});

}

class UnauthorizedAccessException extends NetworkException{
  UnauthorizedAccessException({@required String message}) : super(message: message);
}

class InvalidRequestException extends NetworkException{
  InvalidRequestException({@required String message}) : super(message: message);
}

class TooManyRequestsException extends NetworkException{
  TooManyRequestsException({@required String message}) : super(message: message);
}

class ForbiddenActionException extends NetworkException{
  ForbiddenActionException({@required String message}) : super(message: message);
}