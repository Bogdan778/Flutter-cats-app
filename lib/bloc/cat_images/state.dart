part of 'bloc.dart';

@immutable
abstract class CatsState {}

class CatsInitial extends CatsState {}

class CatsLoaded extends CatsState {
  final List<ImagesData> catsImages;

  CatsLoaded({required this.catsImages});
}
