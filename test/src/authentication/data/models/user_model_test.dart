import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/data/models/user_model.dart';
import 'package:tdd_practice/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test('should be a subclass of [User] entity', () {
    //   Act

    //   Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap)', () {
    test('should return a [UserModel] with the right data', () {
      //   Act
      final result = UserModel.fromMap(tMap);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson)', () {
    test('should return a [UserModel] with the right data', () {
      //   Act
      final result = UserModel.fromJson(tJson);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('toMap)', () {
    test('should return a [Map] with the right data', () {
      //   Act
      final result = tModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson)', () {
    test('should return a [JSON] String with the right data', () {
      // Arrange
      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar"
      });

      //   Act
      final result = tModel.toJson();

      // Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith)', () {
    test('should return a [UserModel] with different data', () {
      //   Act
      final result = tModel.copyWith(name: 'Mihir');

      // Assert
      expect(result.name, equals('Mihir'));
    });
  });
}
