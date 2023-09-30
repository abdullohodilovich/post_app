import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:post_app/src/services/constants/string_constants.dart';
import 'package:post_app/src/services/database/auth_services.dart';
import 'package:post_app/src/services/util_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
  on<SignUpEvent>(_signUp);
  on<SignInEvent>(_signIn);
  on<SignOutEvent>(_signOut);
  on<GetUserEvent>(_getUser);
  on<DeleteConfirmEvent>(_updateUI);
  on<DeleteAccountEvent>(_deleteAccount);

  }
  /// signUp
  void _signUp(SignUpEvent event,Emitter emit )async{
       if(!Util.validateSignUp(event.username, event.email, event.password, event.prePassword)){
         emit(const AuthFailure(I18N.pleaseCheckYourData));
       }

       emit(AuthLoading());

       final result = await AuthService.signUp(event.email, event.password, event.username);

       if(result){
         emit(SignUpSuccess());
       }else{
         const AuthFailure(I18N.somethingError);
       }
  }

  /// signIn
  void _signIn(SignInEvent event,Emitter emit)async{
    if(!Util.validateSignIn(event.email, event.password)){
      emit(const AuthFailure(I18N.pleaseCheckYourData));
    }
    emit(AuthLoading());
    final result = await AuthService.signIn(event.email, event.password);

    if(result){
      emit(SignInSuccess());
    }else {
      emit(const AuthFailure(I18N.somethingError));
    }
  }

  ///signOut
  void _signOut(SignOutEvent event, Emitter emit) async {

    emit(AuthLoading());
    final result = await AuthService.signOut();

    if(result) {
      emit(SignOutSuccess());
    } else {
      emit(const AuthFailure("Something error, please try again later!!!"));
    }
  }

  ///get user
  void _getUser(GetUserEvent event, Emitter emit) async{
    emit(GetUserSuccess(AuthService.user));
  }

  ///updateUI
  void _updateUI(DeleteConfirmEvent event, Emitter emit) {
    emit(const DeleteConfirmSuccess());
  }
  /// delete account
  void _deleteAccount(DeleteAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = AuthService.user;
    final resultSignIn = await AuthService.signIn(user.email!, event.password);

    if(!resultSignIn) {
      emit(const AuthFailure(I18N.pleaseEnterValidPassword));
      return;
    }

    final result = await AuthService.deleteAccount();
    if(result) {
      emit(const DeleteAccountSuccess(I18N.successfullyDeletedAccount));
    } else {
      emit(const AuthFailure(I18N.somethingError));
    }
  }

}
