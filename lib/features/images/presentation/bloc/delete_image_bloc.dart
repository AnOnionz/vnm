import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';

part 'delete_image_event.dart';
part 'delete_image_state.dart';

class DeleteImageBloc extends Bloc<DeleteImageEvent, DeleteImageState> {
  DeleteImageBloc() : super(DeleteImageInitial()) {
    on<DeleteImageRequest>((event, emit) async {
      emit(DeleteImageLoading());
      emit(DeleteImageSuccess());
    });
  }
}
