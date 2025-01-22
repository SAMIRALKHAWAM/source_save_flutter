import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:source_safe/cubits/admin/state.dart';
import '../../cubits/admin/cubit.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AdminHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _showUsers = false; // لتحديد إذا كان يجب عرض صفحة المستخدمين

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // تعيين التاب بار للغروبات فقط
    _Local();
  }

  void _Local() {
    adminCubit.get(context).get_groups();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 800;
    adminCubit.get(context).get_groups();
    adminCubit.get(context).get_groups_p();


    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('File Manager'),
            backgroundColor: Colors.purple[800],
            centerTitle: true,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: isLargeScreen
                  ? BorderRadius.zero
                  : BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          body: Row(
            children: [
              if (isLargeScreen)
                Container(
                  color: Colors.purple[800],
                  width: 250,
                  child: _buildDrawerContent(),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // هنا نقلنا الـ TabBar إلى الـ Body بدلاً من الـ AppBar
                      if (!_showUsers) // إذا لم نعرض المستخدمين، نعرض التاب بار
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'All Groups'), // أول تاب للغروبات
                            Tab(text: 'Processed Groups'), // ثاني تاب للغروبات المعالجة
                          ],
                          labelColor: Colors.black, // تغيير اللون إلى أسود
                          unselectedLabelColor: Colors.black45,
                        ),
                      Expanded(
                        child: _showUsers
                            ? _buildUsersTab() // إذا كان _showUsers صحيح، نعرض صفحة المستخدمين
                            : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildGroupsTab(), // تاب الغروبات
                            _buildProcessedGroupsTab(), // تاب الغروبات المعالجة
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: isLargeScreen ? null : Drawer(child: _buildDrawerContent()),
        );
      },
    );
  }

  Widget _buildGroupsTab() {
    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        if (state is get_groupsSuccessState) {
          var groups = adminCubit.get(context).get_group!.data;

          if (groups.isEmpty) {
            return Center(child: Text("No groups available"));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Groups",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            groups[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple[800],
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.purple[800],
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildProcessedGroupsTab() {
    return BlocConsumer<adminCubit, adminSates>(
      listener: (BuildContext context, adminSates state) {
        // معالجة التغييرات هنا إذا لزم الأمر
      },
      builder: (BuildContext context, adminSates state) {
        if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is get_groupsErrorState) {
          return Center(child: Text("Error loading data"));
        } else if (state is get_groupsSuccessState) {
          // إذا كانت البيانات جاهزة
          var groups = adminCubit.get(context).get_group_p?.data;
          return groups != null && groups.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Processed Groups",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            groups[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple[800],
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.purple[800],
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
              : Center(child: Text("No processed groups available"));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildUsersTab() {
    // صفحة المستخدمين
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: 3, // عدد المستخدمين
        itemBuilder: (context, index) {
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text('User ${index + 1}'),
              subtitle: Text('user${index + 1}@example.com'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.purple[800],
          ),
          child: Center(
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.group,
            color: _selectedIndex == 0 ? Colors.black : Colors.white,
          ),
          title: Text(
            "Groups",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == 0 ? Colors.black : Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = 0;
              _showUsers = false; // إذا كان نعرض المجموعات وليس المستخدمين
            });
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: _selectedIndex == 1 ? Colors.black : Colors.white,
          ),
          title: Text(
            "Users",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == 1 ? Colors.black : Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = 1;
              _showUsers = true; // إذا كان نعرض المستخدمين
            });
          },
        ),
      ],
    );
  }
}
