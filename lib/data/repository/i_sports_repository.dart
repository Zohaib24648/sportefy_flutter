import '../model/sport_dto.dart';

abstract class ISportsRepository {
  Future<List<SportDTO>> getSports();
}
