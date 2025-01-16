part of 'todos_cubit.dart';

@freezed
class TodosState with _$TodosState {
  const factory TodosState.initial({@Default(false) bool isLoading}) = _Initial;
  const factory TodosState.loading({@Default(false) bool isLoading}) = _Loading;
  const factory TodosState.success(String message,
      {@Default(false) bool isLoading}) = _Success;
  const factory TodosState.loaded(Stream<List<Todos>> todos,
      {@Default(false) bool isLoading}) = _Loaded;
  const factory TodosState.error(String error,
      {@Default(false) bool isLoading}) = _Error;
}
