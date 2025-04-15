// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sign_in_button/sign_in_button.dart';
//
// import '../config/storage/token_storage.dart';
// import '../features/login/domain/usecases/params/login_param.dart';
// import '../features/login/presentation/provider/login_provider.dart';
// import '../features/login/presentation/provider/state/login_state.dart';
//
// class Home extends ConsumerWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final loginState = ref.watch(socialLoginNotifierProvider);
//     final user = FirebaseAuth.instance.currentUser;
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google SignIn"),
//         actions: [
//           if (user != null)
//             IconButton(
//               icon: const Icon(Icons.logout),
//               tooltip: 'Sign out',
//               onPressed: () async {
//                 try {
//                   await FirebaseAuth.instance.signOut();
//                   await TokenStorage().clearToken();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Signed out successfully")),
//                   );
//                 } catch (e) {
//                   print("❌ Error during sign-out: $e");
//                 }
//               },
//             ),
//         ],
//       ),
//       body: Center(
//         child: loginState is LoginLoading
//             ? const CircularProgressIndicator()
//             : user == null
//             ? SignInButton(
//           Buttons.google,
//           text: "Sign in with Google",
//           onPressed: () async {
//             final FirebaseAuth _auth = FirebaseAuth.instance;
//
//             try {
//               final googleProvider = GoogleAuthProvider();
//               final userCredential =
//               await _auth.signInWithProvider(googleProvider);
//               final idToken =
//               await userCredential.user?.getIdToken();
//
//               if (idToken != null) {
//                 final params = SocialLoginBodyParams(idToken: idToken);
//                 ref
//                     .read(socialLoginNotifierProvider.notifier)
//                     .socialLogin(params);
//               }
//
//               final tokenStorage = TokenStorage();
//               String? storedToken = await tokenStorage.getToken();
//               print("Token lấy ra từ storage: $storedToken");
//             } catch (e) {
//               print("❌ Error during Google sign-in: $e");
//             }
//           },
//         )
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("You are signed in!"),
//             const SizedBox(height: 16),
//             Text("Email: ${user.email ?? 'Unknown'}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
