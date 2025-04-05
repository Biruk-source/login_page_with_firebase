import '../usefull/imports.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userName;
  String? userEmail;
  String? userPhone;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          userName = userData.data()?['name'];
          userEmail = userData.data()?['email'];
          userPhone = userData.data()?['phone'];
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GB Delivery',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'AguDisplay',
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDark ? Colors.black : const Color.fromARGB(249, 252, 208, 11),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeManager.toggleTheme(!isDark);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.delivery_dining), text: 'Deliveries'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildDeliveriesTab(),
          _buildProfileTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${userName ?? 'User'}!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildFeatureCard(
            title: 'Quick Delivery',
            description: 'Fast and reliable delivery service',
            icon: Icons.local_shipping,
            onTap: () {
              // Add quick delivery functionality
            },
          ),
          _buildFeatureCard(
            title: 'Track Order',
            description: 'Real-time tracking of your deliveries',
            icon: Icons.location_on,
            onTap: () {
              // Add order tracking functionality
            },
          ),
          _buildFeatureCard(
            title: 'Schedule Pickup',
            description: 'Schedule a pickup at your convenience',
            icon: Icons.schedule,
            onTap: () {
              // Add pickup scheduling functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveriesTab() {
    return ListView.builder(
      itemCount: 5, // Replace with actual delivery data
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.local_shipping, color: Colors.white),
            ),
            title: Text('Delivery #${index + 1}'),
            subtitle: Text('Status: In Transit'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show delivery details
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Text(
              userName?.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          _buildProfileCard(
            title: 'Name',
            value: userName ?? 'Not set',
            icon: Icons.person,
          ),
          _buildProfileCard(
            title: 'Email',
            value: userEmail ?? 'Not set',
            icon: Icons.email,
          ),
          _buildProfileCard(
            title: 'Phone',
            value: userPhone ?? 'Not set',
            icon: Icons.phone,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add edit profile functionality
            },
            child: Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.themeMode == ThemeMode.dark;
    
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildSettingCard(
          title: 'Dark Mode',
          subtitle: 'Toggle dark mode theme',
          trailing: Switch(
            value: isDark,
            onChanged: (value) {
              themeManager.toggleTheme(value);
            },
          ),
        ),
        _buildSettingCard(
          title: 'Notifications',
          subtitle: 'Manage notification settings',
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Add notification settings
          },
        ),
        _buildSettingCard(
          title: 'Language',
          subtitle: 'Change app language',
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Add language settings
          },
        ),
        _buildSettingCard(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Show privacy policy
          },
        ),
        _buildSettingCard(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Show terms of service
          },
        ),
        _buildSettingCard(
          title: 'About',
          subtitle: 'Learn more about GB Delivery',
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Show about page
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.blue, size: 32),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
