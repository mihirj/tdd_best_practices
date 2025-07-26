import 'package:tdd_practice/core/utils/typedef.dart';

abstract class UsecaseWithParam<Type, Params> {
  const UsecaseWithParam();
  ResultFuture<Type> call(Params params);
}

abstract class UsecaseWithoutParams<Type> {
  const UsecaseWithoutParams();
  ResultFuture<Type> call();
}
