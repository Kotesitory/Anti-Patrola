import 'package:anti_patrola/exceptions/network_exception.dart';
import 'package:dio/dio.dart';

class NetworkUtils {
  static NetworkException mapDioErrorToException(DioError err) {
    if (err.response == null) {
      return NetworkException(
          message: "Unknown NetworkException occured", innerException: err);
    }

    String message = err.response.data['message'];
    switch (err.response.statusCode) {
      case 401:
        return UnauthorizedAccessException(message: message);
        break;
      case 407:
        return InvalidRequestException(message: message);
        break;
      case 429:
        return TooManyRequestsException(message: message);
        break;
      case 403:
        return ForbiddenActionException(message: message);
        break;
      default:
        return NetworkException(
            message: "Unknown NetworkException occured", innerException: err);
    }
  }
}
