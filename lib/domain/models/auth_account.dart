class AuthAccount {
  const AuthAccount({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  final String uid;
  final String email;
  final String? displayName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthAccount &&
            other.uid == uid &&
            other.email == email &&
            other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(uid, email, displayName);
}
