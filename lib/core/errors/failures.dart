abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({super.message = 'Please check your internet connection'});
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({super.message = 'Session expired. Please login again'});
}
