import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final FocusNode _usernameFocusNode = FocusNode();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? errorMessage;
  String correctPhoneNumber = '923456789';
  String correctPassword = '123'; //sau nay rang buoc password
  String correctUsername = 'thaodoan';
  String enteredPhoneNumber = '';
  String enteredPassword = '';
  String enteredUsername = '';
  bool isLoading = false;
  bool isPassed = false;
  bool isOsecured = true;
  bool loginWithUsername = false;

  @override
  void initState() {
    super.initState();
    // Tự động focus khi trang vừa được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocusNode.requestFocus();
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
          child: !loginWithUsername
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số điện thoại',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      IntlPhoneField(
                        enabled: isPassed ? false : true,
                        controller: _phoneController,
                        onChanged: (phone) {
                          setState(() {
                            enteredPhoneNumber = phone.number;
                          });
                        },
                        focusNode: _phoneFocusNode,
                        decoration: InputDecoration(
                          suffixIcon: _phoneController.text.isEmpty ||
                                  isLoading ||
                                  isPassed
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
                          fillColor: isLoading || isPassed
                              ? Colors.grey[200]
                              : Colors.white12,
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

                      if (isPassed) ...[
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mật khẩu',
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {}, //doing....
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            )
                          ],
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
                              width:
                                  _passwordController.text.isEmpty ? 10 : 105,
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
                            fillColor:
                                isLoading ? Colors.grey[200] : Colors.white12,
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
                      ],
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
                      isPassed
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(380, 50),
                                backgroundColor: isLoading
                                    ? Colors
                                        .grey // Nút chuyển thành màu xám khi loading
                                    : Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (enteredPassword.isEmpty) {
                                  setState(() {
                                    errorMessage = 'Vui lòng nhập mật khẩu';
                                  });
                                  return;
                                }

                                if (!isLoading) {
                                  setState(() {
                                    // Ẩn bàn phím sau khi nhấn nút
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    // Đặt isLoading thành true để hiển thị icon tải
                                    isLoading = true;
                                  });

                                  // Mô phỏng độ trễ (thời gian xử lý) trong 2 giây
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      // Kiểm tra số điện thoại
                                      if (enteredPassword != correctPassword) {
                                        errorMessage = 'Mật khẩu không đúng';
                                      } else {
                                        errorMessage = null;
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      }
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);

                                      // Đặt lại isLoading thành false để dừng hiển thị icon tải
                                      isLoading = false;
                                    });
                                  });
                                }
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Đăng nhập',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                      ],
                                    )
                                  : Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(380, 50),
                                backgroundColor: isLoading
                                    ? Colors
                                        .grey // Nút chuyển thành màu xám khi loading
                                    : Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (enteredPhoneNumber.isEmpty) {
                                  setState(() {
                                    errorMessage =
                                        'Vui lòng nhập số điện thoại';
                                  });
                                  return;
                                }

                                if (!isLoading) {
                                  setState(() {
                                    // Ẩn bàn phím sau khi nhấn nút
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    // Đặt isLoading thành true để hiển thị icon tải
                                    isLoading = true;
                                  });

                                  // Mô phỏng độ trễ (thời gian xử lý) trong 2 giây
                                  Future.delayed(Duration(seconds: 2), () {
                                    setState(() {
                                      // Kiểm tra số điện thoại
                                      if (enteredPhoneNumber !=
                                          correctPhoneNumber) {
                                        errorMessage =
                                            'Số điện thoại không khớp với số đã cho';
                                      } else {
                                        errorMessage = null;
                                        isPassed = true;
                                      }

                                      // Đưa focus trở lại trường nhập số điện thoại
                                      FocusScope.of(context)
                                          .requestFocus(_phoneFocusNode);

                                      // Đặt lại isLoading thành false để dừng hiển thị icon tải
                                      isLoading = false;
                                    });
                                  });
                                }
                              },
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Tiếp tục',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                      ],
                                    )
                                  : Text(
                                      'Tiếp tục',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Nhấn vào đây để đăng nhập bằng '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: GestureDetector(
                                  child: IntrinsicWidth(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.blueAccent,
                                        ),
                                        Text(
                                          'Username',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _passwordController.clear();
                                      errorMessage = null;
                                      loginWithUsername = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      // Thêm các widget khác nếu cần
                    ],
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          fillColor:
                              isLoading ? Colors.grey[200] : Colors.white12,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mật khẩu',
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {}, //doing....
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          )
                        ],
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
                          fillColor:
                              isLoading ? Colors.grey[200] : Colors.white12,
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
                              ? Colors
                                  .grey // Nút chuyển thành màu xám khi loading
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
                          }

                          if (!isLoading) {
                            setState(() {
                              // Ẩn bàn phím sau khi nhấn nút
                              FocusScope.of(context).requestFocus(FocusNode());

                              // Đặt isLoading thành true để hiển thị icon tải
                              isLoading = true;
                            });

                            // Mô phỏng độ trễ (thời gian xử lý) trong 2 giây
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                // Kiểm tra số điện thoại
                                if (enteredUsername != correctUsername &&
                                    enteredPassword != correctPassword) {
                                  errorMessage =
                                      'Username và mật khẩu không đúng';
                                } else if (enteredUsername != correctUsername ||
                                    enteredPassword != correctPassword) {
                                  errorMessage =
                                      'Username hoặc mật khẩu không đúng';
                                } else {
                                  errorMessage = null;
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                                FocusScope.of(context)
                                    .requestFocus(_usernameFocusNode);

                                // Đặt lại isLoading thành false để dừng hiển thị icon tải
                                isLoading = false;
                              });
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
                                    'Đăng nhập',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              )
                            : Text(
                                'Đăng nhập',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Nhấn vào đây để đăng nhập bằng '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: loginWithUsername
                                    ? GestureDetector(
                                        child: const IntrinsicWidth(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                color: Colors.blueAccent,
                                              ),
                                              Text(
                                                'số điện thoại',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            isPassed = false;
                                            _phoneController.clear();
                                            errorMessage = null;
                                            _passwordController.clear();
                                            loginWithUsername = false;
                                          });
                                        },
                                      )
                                    : GestureDetector(
                                        child: IntrinsicWidth(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.blueAccent,
                                              ),
                                              Text(
                                                'Username',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            errorMessage = null;
                                            loginWithUsername = true;
                                          });
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
                      // Thêm các widget khác nếu cần
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
