class AppState {
  final bool isLoggedIn;
  final bool isLoading;
  final int counter;
  final bool firstTime;

  AppState({
    this.isLoggedIn = false,
    this.isLoading = true,
    this.counter = 0,
    this.firstTime = true,
  });

  AppState copyWith({bool isLoggedIn, bool isLoading, int counter}) {
    return new AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      counter: counter ?? this.counter,
      firstTime: firstTime ?? this.firstTime,
    );
  }

  @override
  String toString() {
    return 'AppState({isLoggedIn: $isLoggedIn, isLoading: $isLoading})';
  }
}
