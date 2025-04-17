import 'package:dio/dio.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/presentation/provider/get_cates_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/constants.dart';
import '../../../choose_language/presentation/widgets/button_widget.dart';
import '../../data/models/category.dart';


class BottomSheetCate extends ConsumerStatefulWidget {
  final int selectedId;

  const BottomSheetCate({super.key, required this.selectedId});

  @override
  ConsumerState<BottomSheetCate> createState() => _BottomSheetCateState();
}

class _BottomSheetCateState extends ConsumerState<BottomSheetCate> {
  bool isLoading = true;
  late int selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    final cates = ref.watch(categoriesProvider);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: cates.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Lỗi: $err")),
          data: (categories) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Bạn muốn bắt đầu với",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...categories.map((cat) => Column(
                children: [
                  _buildOptionTile(cat),
                  const SizedBox(height: 15),
                ],
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedId == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn một lựa chọn')),
                    );
                    return;
                  }

                  final selectedCat = categories.firstWhere(
                        (cat) => cat.id == selectedId,
                    orElse: () => CategoryModel(id: 0, name: "Chưa chọn"),
                  );

                  final oldCat = categories.firstWhere(
                        (cat) => cat.id == widget.selectedId,
                    orElse: () => CategoryModel(id: 0, name: "Chưa chọn"),
                  );

                  if (selectedCat.id == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn một lựa chọn')),
                    );
                    return;
                  }

                  if (selectedId == widget.selectedId) {
                    print('hiiiiiiiiiiiii');
                    Navigator.of(context).pop();
                    return;
                  }

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              "assets/animations/astronaut.json",
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Chuyển đổi chương trình',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Bạn có chắc chắn muốn chuyển từ ${oldCat.name} sang ${selectedCat.name} không?',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ButtonBlue(
                            text: 'Chuyển sang ${selectedCat.name}',
                            my_function: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ButtonBlue(
                            text: 'Tiếp tục với ${oldCat.name}',
                            my_function: () {
                              Navigator.pop(context, false);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    Navigator.of(context).pop(selectedId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
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
      ),
    );
  }

  Widget _buildOptionTile(CategoryEntity category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedId = category.id!;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedId == category.id
              ? Colors.blue.shade100
              : Colors.transparent,
          border: Border.all(
            color:
                selectedId == category.id ? Colors.blue : Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              selectedId == category.id
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selectedId == category.id ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(category.name),
          ],
        ),
      ),
    );
  }


}
