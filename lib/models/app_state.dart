class AppState {
  final bool isLoggedIn;
  final bool isLoading;
  final int counter;

  AppState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.counter = 0,
  });

  AppState copyWith({bool isLoggedIn, bool isLoading, int counter}) {
    return new AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      counter: counter ?? this.counter,
    );
  }

  @override
  String toString() {
    return 'AppState({isLoggedIn: $isLoggedIn, isLoading: $isLoading})';
  }
}
