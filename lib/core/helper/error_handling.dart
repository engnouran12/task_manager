class ErrorHandling {
  static String handleError(String e) {
    if (e.toString().contains('Login failed with status code 400')) {
      return 'Incorrect email or password';
    } else if (e.toString().contains('Connection failed')) {
      return 'No internet connection';
    }
    else if (e.toString().contains('Connection caused')) {
      return 'No internet connection';
    } else if (e.toString().contains('status code 401')) {
      return 'Unauthorized user';
    }else if (e.toString().contains('Failed to add ')) {
      return 'Failed to add data';
    }
    else if (e.toString().contains('Failed to edit')) {
      return 'Failed to edit data';
    }
    else if (e.toString().contains('Failed to upload image')) {
      return 'Failed to upload image';
    }
    else if (e.toString().contains('Failed to get')) {
      return 'Failed to get data';
    }else if (e.toString().contains('Failed to find ')) {
      return 'Failed to find data';
    }
    else {
      return 'error:${e.toString()}';
    }
  }
}
