import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_list_with_getx/app/core/utils/extensions.dart';
import 'package:todo_list_with_getx/app/modules/home/widgets/add_card.dart';
import 'package:todo_list_with_getx/app/modules/home/widgets/add_dialog.dart';
import '../../core/theme/themes_services.dart';
import '../../core/values/colors.dart';
import '../../data/models/task.dart';
import '../report/view.dart';
import 'controller.dart';
import 'widgets/task_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            SafeArea(
                child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text(
                    'My List',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ...controller.tasks
                          .map((element) => LongPressDraggable(
                              data: element,
                              onDragStarted: () => controller.changeDeleting(true),
                              onDraggableCanceled: (_, __) => controller.changeDeleting(false),
                              onDragEnd: (_) => controller.changeDeleting(false),
                              feedback: Opacity(
                                opacity: 0.8,
                                child: TaskCard(
                                  task: element,
                                ),
                              ),
                              child: TaskCard(task: element)))
                          .toList(),
                      AddCard(),
                    ],
                  ),
                ),
              ],
            )),
            Report()
          ],
        ),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(
                    () => AddDialog(),
                    transition: Transition.downToUp,
                  );
                } else {
                  EasyLoading.showInfo("Please create your task type");
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete : Icons.add,
              ),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess("Delete Success");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: (int index) => controller.changeTabIndex(index),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Padding(
                  padding: EdgeInsets.only(right: 15.0.wp),
                  child: const Icon(Icons.apps),
                ),
              ),
              BottomNavigationBarItem(
                label: "Report",
                icon: Padding(
                  padding: EdgeInsets.only(left: 15.0.wp),
                  child: const Icon(Icons.data_usage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
_appBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        ThemesServices().switchTheme();
      },
      child: Icon(
        Icons.nightlight_round,
        size: 20.0.wp,
      ),
    ),
    actions: [
      Icon(Icons.person),
      SizedBox(
        width: 20.0.wp,
      )
    ],
  );
}
