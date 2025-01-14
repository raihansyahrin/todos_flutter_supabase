import 'package:supabase_flutter/supabase_flutter.dart';

String handleSupabaseError(AuthApiException error) {
  switch (error.code) {
    case '403':
      return 'Forbidden: You do not have permission to perform this action.';
    case '422':
      return 'Unprocessable Entity: The request cannot be processed due to a server or user state issue.';
    case '429':
      return 'Too Many Requests: Rate limit exceeded. Please try again later.';
    case '500':
      return 'Internal Server Error: There is an issue with the server. Please try again later.';
    case '501':
      return 'Not Implemented: The requested feature is not enabled on the server.';
    default:
      return 'Error ${error.code}: ${error.message}';
  }
}