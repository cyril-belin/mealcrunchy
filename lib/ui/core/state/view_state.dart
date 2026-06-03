sealed class ViewState<T> {
  const ViewState();
}

class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

class ViewData<T> extends ViewState<T> {
  const ViewData(this.data);

  final T data;
}

class ViewError<T> extends ViewState<T> {
  const ViewError(this.message);

  final String message;
}
