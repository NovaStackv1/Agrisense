import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  bool _isExpenseTab = true;
  final List<Map<String, dynamic>> _allTransactions = [
    {
      'title': 'Fertilizers',
      'category': 'Inputs',
      'amount': '-Ksh 2,500',
      'date': 'Today',
      'icon': Icons.agriculture,
      'color': Colors.orange,
      'type': 'expense',
    },
    {
      'title': 'Seed Purchase',
      'category': 'Seeds',
      'amount': '-Ksh 1,800',
      'date': 'Yesterday',
      'icon': Icons.spa,
      'color': Colors.green,
      'type': 'expense',
    },
    {
      'title': 'Tomato Sale',
      'category': 'Sales',
      'amount': '+Ksh 8,200',
      'date': '2 days ago',
      'icon': Icons.shopping_cart,
      'color': Colors.blue,
      'type': 'income',
    },
    {
      'title': 'Labor Cost',
      'category': 'Labor',
      'amount': '-Ksh 3,500',
      'date': '3 days ago',
      'icon': Icons.people,
      'color': Colors.purple,
      'type': 'expense',
    },
    {
      'title': 'Equipment Repair',
      'category': 'Maintenance',
      'amount': '-Ksh 2,833',
      'date': '1 week ago',
      'icon': Icons.build,
      'color': Colors.red,
      'type': 'expense',
    },
    {
      'title': 'Maize Harvest',
      'category': 'Sales',
      'amount': '+Ksh 12,000',
      'date': '3 days ago',
      'icon': Icons.shopping_cart,
      'color': Colors.blue,
      'type': 'income',
    },
    {
      'title': 'Pesticides',
      'category': 'Inputs',
      'amount': '-Ksh 1,200',
      'date': '4 days ago',
      'icon': Icons.medical_services,
      'color': Colors.orange,
      'type': 'expense',
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    return _allTransactions
        .where((transaction) => _isExpenseTab
        ? transaction['type'] == 'expense'
        : transaction['type'] == 'income')
        .toList();
  }

  double get _totalIncome {
    return _allTransactions
        .where((transaction) => transaction['type'] == 'income')
        .fold(0.0, (sum, transaction) {
      final amount = double.parse(transaction['amount']
          .toString()
          .replaceAll('+Ksh ', '')
          .replaceAll(',', ''));
      return sum + amount;
    });
  }

  double get _totalExpenses {
    return _allTransactions
        .where((transaction) => transaction['type'] == 'expense')
        .fold(0.0, (sum, transaction) {
      final amount = double.parse(transaction['amount']
          .toString()
          .replaceAll('-Ksh ', '')
          .replaceAll(',', ''));
      return sum + amount;
    });
  }

  double get _totalBalance => _totalIncome - _totalExpenses;

  String _formatCurrency(double amount) {
    return 'Ksh ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}';
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'export':
        _showExportDialog();
        break;
      case 'categories':
        _showCategoriesDialog();
        break;
      case 'reports':
        _showReportsDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Data'),
          content: const Text('Export your transaction data as CSV or PDF.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showToast('Export feature coming soon!');
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manage Categories'),
          content: const Text('Add, edit, or delete transaction categories.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showReportsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Financial Reports'),
          content: const Text('View detailed financial reports and analytics.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Expense Settings'),
          content: const Text('Configure your expense tracking preferences.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTransactionDialog() {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String selectedCategory = _isExpenseTab ? 'Seeds' : 'Crop Sales';

    String transactionType = _isExpenseTab ? 'Expense' : 'Income';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add $transactionType',
              style: Theme.of(context).textTheme.headlineSmall),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixText: 'Ksh ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _isExpenseTab
                    ? ['Seeds', 'Fertilizers', 'Labor', 'Equipment', 'Other']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList()
                    : ['Crop Sales', 'Livestock', 'Produce', 'Other']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (descriptionController.text.isEmpty || amountController.text.isEmpty) {
                  _showToast('Please fill all fields');
                  return;
                }

                final double amount = double.tryParse(amountController.text) ?? 0;
                if (amount <= 0) {
                  _showToast('Please enter a valid amount');
                  return;
                }

                _addTransaction(
                  description: descriptionController.text,
                  amount: amount,
                  category: selectedCategory,
                  type: _isExpenseTab ? 'expense' : 'income',
                );

                Navigator.of(context).pop();
                _showToast('$transactionType added successfully!');
              },
              child: Text('Add $transactionType'),
            ),
          ],
        );
      },
    );
  }

  void _addTransaction({
    required String description,
    required double amount,
    required String category,
    required String type,
  }) {
    final Map<String, dynamic> newTransaction = {
      'title': description,
      'category': category,
      'amount': '${type == 'expense' ? '-' : '+'}Ksh ${amount.toStringAsFixed(0)}',
      'date': 'Just now',
      'icon': _getIconForCategory(category, type),
      'color': _getColorForCategory(category),
      'type': type,
    };

    setState(() {
      _allTransactions.insert(0, newTransaction);
    });
  }

  IconData _getIconForCategory(String category, String type) {
    if (type == 'income') {
      return Icons.shopping_cart;
    }

    switch (category) {
      case 'Seeds':
        return Icons.spa;
      case 'Fertilizers':
        return Icons.agriculture;
      case 'Labor':
        return Icons.people;
      case 'Equipment':
        return Icons.build;
      case 'Inputs':
        return Icons.agriculture;
      case 'Maintenance':
        return Icons.build;
      default:
        return Icons.receipt;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Seeds':
        return Colors.green;
      case 'Fertilizers':
        return Colors.orange;
      case 'Labor':
        return Colors.purple;
      case 'Equipment':
        return Colors.red;
      case 'Inputs':
        return Colors.orange;
      case 'Maintenance':
        return Colors.red;
      case 'Crop Sales':
        return Colors.blue;
      case 'Livestock':
        return Colors.brown;
      case 'Produce':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showViewAllToast() {
    _showToast('View All feature coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'categories',
                child: Row(
                  children: [
                    Icon(Icons.category, size: 20),
                    SizedBox(width: 8),
                    Text('Categories'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'reports',
                child: Row(
                  children: [
                    Icon(Icons.analytics, size: 20),
                    SizedBox(width: 8),
                    Text('Reports'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          _buildSummaryCard(theme),

          // Tabs for Expenses/Income
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpenseTab = true;
                      });
                    },
                    child: _buildTabButton(theme, 'Expenses', _isExpenseTab),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpenseTab = false;
                      });
                    },
                    child: _buildTabButton(theme, 'Income', !_isExpenseTab),
                  ),
                ),
              ],
            ),
          ),

          // Transaction Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredTransactions.length} ${_isExpenseTab ? 'Expenses' : 'Income Sources'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  'Total: ${_isExpenseTab ? _formatCurrency(_totalExpenses) : _formatCurrency(_totalIncome)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isExpenseTab ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Recent Transactions
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent ${_isExpenseTab ? 'Expenses' : 'Income'}',
                          style: theme.textTheme.headlineSmall,
                        ),
                        GestureDetector(
                          onTap: _showViewAllToast,
                          child: Text(
                            'View All',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildTransactionList(theme, isDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: Icon(_isExpenseTab ? Icons.remove : Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(_totalBalance),
            style: theme.textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceItem('Income', _formatCurrency(_totalIncome), Colors.green[300]!),
              _buildBalanceItem('Expenses', _formatCurrency(_totalExpenses), Colors.red[300]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(ThemeData theme, String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.transparent : theme.colorScheme.primary,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isActive ? Colors.white : theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTransactionList(ThemeData theme, bool isDark) {
    final transactions = _filteredTransactions;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isExpenseTab ? Icons.money_off : Icons.attach_money,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _isExpenseTab ? 'No expenses yet' : 'No income yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isExpenseTab
                  ? 'Add your first expense to get started'
                  : 'Add your first income source to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final String amount = transaction['amount'] as String;
        final bool isIncome = amount.startsWith('+');
        final Color color = transaction['color'] as Color;
        final IconData icon = transaction['icon'] as IconData;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            title: Text(
              transaction['title'] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(transaction['category'] as String),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  transaction['date'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}