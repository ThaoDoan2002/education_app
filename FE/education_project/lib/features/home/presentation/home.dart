import 'package:carousel_slider/carousel_slider.dart';
import 'package:education_project/features/choose_language/presentation/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void showLanguageSelectionModal() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LanguageSelectionModal(),
    );

    if (result != null && result.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              // 👈 Chiều cao tối đa
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/animations/astronaut.json",
                    width: 150,
                    height: 150,
                    fit: BoxFit
                        .contain, // Có thể dùng cover, fill, etc. tùy layout
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Chuyển đổi chương trình',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Bạn có chắc chắn muốn chuyển đổi chương trình học từ Toeic sang IELTS không?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ButtonBlue(
                text: 'Chuyển sang IELTS',
                my_function: () {
                  Navigator.pop(context); // Đóng modal
                },
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: ButtonBlue(
                text: 'Chuyển sang Toeic',
                my_function: () {
                  Navigator.pop(context); // Đóng modal
                },
              ),
            ),
          ],
        ),
      );
      print('Bắt đầu với: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        title: GestureDetector(
          onTap: () {
            showLanguageSelectionModal();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28.0,
                    backgroundImage: AssetImage('assets/home/user.png'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Xin chào, User',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      Text(
                        'Bạn đang học Toiec',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_drop_down, size: 50),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(viewportFraction: 1),
              items: [Slider(), Slider(), Slider()],
            ),
          ],
        ),
      ),
    );
  }
}

class Slider extends StatelessWidget {
  const Slider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: const Image(image: AssetImage('assets/intro/intro1.jpg')),
        ),
      ),
    );
  }
}

class LanguageSelectionModal extends StatefulWidget {
  const LanguageSelectionModal({super.key});

  @override
  State<LanguageSelectionModal> createState() => _LanguageSelectionModalState();
}

class _LanguageSelectionModalState extends State<LanguageSelectionModal> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Bạn muốn bắt đầu với",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildOptionTile("IELTS"),
            const SizedBox(height: 10),
            _buildOptionTile("TOEIC"),
            const SizedBox(height: 10),
            _buildOptionTile("TOEFL"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (selected.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng chọn một lựa chọn')),
                  );
                } else {
                  Navigator.pop(context, selected);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Bắt đầu",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected == title ? Colors.blue.shade100 : Colors.transparent,
          border: Border.all(
            color: selected == title ? Colors.blue : Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              selected == title
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected == title ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
