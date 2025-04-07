import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();


  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _fullnameFocusNode = FocusNode();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();

  String? errorMessage;
  String enteredPhoneNumber = '';
  String enteredPassword = '';
  String enteredRePassword = '';

  String enteredUsername = '';
  String enteredFullname = '';

  bool isLoading = false;
  bool isOsecured = true;

  @override
  void initState() {
    super.initState();
    // Tự động focus khi trang vừa được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocusNode.requestFocus();
    });
    // Ẩn icon cancle khi chưa nhập số
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose(); // Giải phóng FocusNode khi không còn sử dụng
    _passwordFocusNode.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/welcome/star.png',
          height: 73,
          width: 75,
        ),
      ),
      body: SingleChildScrollView(
        //  nội dung có thể cuộn
        child: Container(
          margin: EdgeInsets.only(top: 45, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Họ và tên',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (fullname) {
                    enteredFullname = fullname;
                  },
                  focusNode: _fullnameFocusNode,
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    suffixIcon: _usernameController.text.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : IconButton(
                            onPressed: () {
                              enteredUsername = '';
                              _usernameController.clear();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                          ),
                    filled: true,
                    fillColor: isLoading ? Colors.grey[200] : Colors.white12,
                    hintText: 'Nhập họ và tên',
                    labelText: 'Nhập họ và tên',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isLoading ? Colors.grey : Colors.blue,
                        // Màu viền khi loading
                        width: 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: isLoading ? Colors.grey : Colors.black,
                      // Màu chữ khi loading
                      fontSize: 17,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isLoading
                        ? Colors.grey
                        : Colors.black, // Màu chữ input khi loading
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Username',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (username) {
                    enteredUsername = username;
                  },
                  focusNode: _usernameFocusNode,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    suffixIcon: _usernameController.text.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : IconButton(
                            onPressed: () {
                              enteredUsername = '';
                              _usernameController.clear();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                          ),
                    filled: true,
                    fillColor: isLoading ? Colors.grey[200] : Colors.white12,
                    hintText: 'Nhập Username',
                    labelText: 'Nhập Username',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isLoading ? Colors.grey : Colors.blue,
                        // Màu viền khi loading
                        width: 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: isLoading ? Colors.grey : Colors.black,
                      // Màu chữ khi loading
                      fontSize: 17,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isLoading
                        ? Colors.grey
                        : Colors.black, // Màu chữ input khi loading
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Số điện thoại',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                IntlPhoneField(
                  controller: _phoneController,
                  onChanged: (phone) {
                    setState(() {
                      enteredPhoneNumber = phone.number;
                    });
                  },
                  focusNode: _phoneFocusNode,
                  decoration: InputDecoration(
                    suffixIcon: _phoneController.text.isEmpty || isLoading
                        ? Container(
                            width: 0,
                          )
                        : IconButton(
                            onPressed: () {
                              enteredPhoneNumber = '';
                              _phoneController.clear();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            )),
                    filled: true,
                    fillColor: isLoading ? Colors.grey[200] : Colors.white12,
                    hintText: 'Nhập số điện thoại',
                    labelText: 'Nhập số điện thoại',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isLoading ? Colors.grey : Colors.blue,
                        // Màu viền khi loading
                        width: 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: isLoading ? Colors.grey : Colors.black,
                      // Màu chữ khi loading
                      fontSize: 17,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isLoading
                        ? Colors.grey
                        : Colors.black, // Màu chữ input khi loading
                  ),
                  keyboardType: TextInputType.phone,
                  initialCountryCode: 'VN',
                  invalidNumberMessage: "Số điện thoại không hợp lệ!",
                  disableLengthCheck: true,
                  validator: (phone) async {
                    if (!RegExp(r'^[3|5|7|8|9][1-9]{8}$')
                        .hasMatch(phone!.number)) {
                      return 'Số điện thoại không hợp lệ. Số phải có độ dài 9 chữ số';
                    }
                    return null;
                  },
                  dropdownTextStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                    FilteringTextInputFormatter.digitsOnly, //chỉ nhận số
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                const Text(
                  'Mật khẩu',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (password) {
                    enteredPassword = password;
                  },
                  obscureText: isOsecured,
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: SizedBox(
                      width: _passwordController.text.isEmpty ? 10 : 105,
                      // Đặt kích thước tùy ý phù hợp với giao diện của bạn
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isOsecured = !isOsecured;
                              });
                            },
                            icon: isOsecured
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                          ),
                          if (_passwordController.text.isNotEmpty) ...[
                            Container(
                              width: 2,
                              height: 20,
                              color: Colors.grey,
                            ),
                            IconButton(
                              onPressed: () {
                                enteredPassword = '';
                                _passwordController.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: isLoading ? Colors.grey[200] : Colors.white12,
                    hintText: 'Nhập mật khẩu',
                    labelText: 'Nhập mật khẩu',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isLoading ? Colors.grey : Colors.blue,
                        // Màu viền khi loading
                        width: 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: isLoading ? Colors.grey : Colors.black,
                      // Màu chữ khi loading
                      fontSize: 17,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isLoading
                        ? Colors.grey
                        : Colors.black, // Màu chữ input khi loading
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                const Text(
                  'Nhập lại mật khẩu',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (rePassword) {
                    enteredRePassword = rePassword;
                  },
                  obscureText: isOsecured,
                  focusNode: _rePasswordFocusNode,
                  controller: _rePasswordController,
                  decoration: InputDecoration(
                    suffixIcon: SizedBox(
                      width: _rePasswordController.text.isEmpty ? 10 : 105,
                      // Đặt kích thước tùy ý phù hợp với giao diện của bạn
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isOsecured = !isOsecured;
                              });
                            },
                            icon: isOsecured
                                ? const Icon(
                              Icons.visibility,
                              color: Colors.grey,
                            )
                                : const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          if (_passwordController.text.isNotEmpty) ...[
                            Container(
                              width: 2,
                              height: 20,
                              color: Colors.grey,
                            ),
                            IconButton(
                              onPressed: () {
                                enteredRePassword = '';
                                _rePasswordController.clear();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: isLoading ? Colors.grey[200] : Colors.white12,
                    hintText: 'Nhập lại mật khẩu',
                    labelText: 'Nhập lại mật khẩu',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isLoading ? Colors.grey : Colors.blue,
                        // Màu viền khi loading
                        width: 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: isLoading ? Colors.grey : Colors.black,
                      // Màu chữ khi loading
                      fontSize: 17,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isLoading
                        ? Colors.grey
                        : Colors.black, // Màu chữ input khi loading
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                if (errorMessage != null && !isLoading)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                        children: [
                          const WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                          TextSpan(text: errorMessage),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(380, 50),
                    backgroundColor: isLoading
                        ? Colors.grey // Nút chuyển thành màu xám khi loading
                        : Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (enteredUsername.isEmpty) {
                      setState(() {
                        errorMessage = 'Vui lòng nhập Username';
                      });
                      return;
                    } else if (enteredPassword.isEmpty) {
                      setState(() {
                        errorMessage = 'Vui lòng nhập mật khẩu';
                      });
                      return;
                    } else if (enteredFullname.isEmpty) {
                      setState(() {
                        errorMessage = 'Vui lòng nhập họ và tên';
                      });
                      return;
                    }

                    if (!isLoading) {
                      setState(() {
                        // Ẩn bàn phím sau khi nhấn nút
                        FocusScope.of(context).requestFocus(FocusNode());

                        // Đặt isLoading thành true để hiển thị icon tải
                        isLoading = true;
                      });
                    }
                  },
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Đăng ký',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )
                      : Text(
                          'Đăng ký',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
