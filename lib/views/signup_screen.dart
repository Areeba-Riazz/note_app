Future<void> _signup() async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    setState(() {
      _errorMessage = e.message ?? 'Signup failed, try again.';
    });
  }
}
