part of 'todos_cubit.dart';

@freezed
class TodosState with _$TodosState {
  const factory TodosState.initial() = _Initial;
  const factory TodosState.loading() = _Loading;
  const factory TodosState.success(String message) = _Success;
  const factory TodosState.loaded(Stream<List<Todos>> todos) = _Loaded;
  const factory TodosState.error(String error) = _Error;
}
