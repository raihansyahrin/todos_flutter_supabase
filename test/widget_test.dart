// Either<String, int> divide(int a, int b) {

//   if (b == 0) {
//     return Left("Division by zero");
//   }
//   return Right(a ~/ b);
// }

// void main() {
//   final result1 = divide(10, 2);
//   final result2 = divide(10, 0);

//   result1.fold(
//     (error) => print("Error: $error"),
//     (value) => print("Result: $value"),
//   );

//   result2.fold(
//     (error) => print("Error: $error"),
//     (value) => print("Result: $value"),
//   );
// }
