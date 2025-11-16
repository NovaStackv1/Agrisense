import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
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
                  child: _buildTabButton(theme, 'Expenses', true),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTabButton(theme, 'Income', false),
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text(
                          'View All',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
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
        onPressed: () {
          _showAddExpenseDialog(context);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
            theme.colorScheme.primary.withOpacity(0.9),
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
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ksh 24,567', // <-- Changed here
            style: theme.textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceItem(
                  'Income', 'Ksh 35,200', Colors.green[300]!), // <-- Changed here
              _buildBalanceItem('Expenses', 'Ksh 10,633',
                  Colors.red[300]!), // <-- Changed here
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
    // --- Data Changed Here ---
    final List<Map<String, dynamic>> transactions = [
      {
        'title': 'Fertilizers',
        'category': 'Inputs',
        'amount': '-Ksh 2,500', // Changed
        'date': 'Today',
        'icon': Icons.agriculture,
        'color': Colors.orange,
      },
      {
        'title': 'Seed Purchase',
        'category': 'Seeds',
        'amount': '-Ksh 1,800', // Changed
        'date': 'Yesterday',
        'icon': Icons.spa,
        'color': Colors.green,
      },
      {
        'title': 'Tomato Sale',
        'category': 'Sales',
        'amount': '+Ksh 8,200', // Changed
        'date': '2 days ago',
        'icon': Icons.shopping_cart,
        'color': Colors.blue,
      },
      {
        'title': 'Labor Cost',
        'category': 'Labor',
        'amount': '-Ksh 3,500', // Changed
        'date': '3 days ago',
        'icon': Icons.people,
        'color': Colors.purple,
      },
      {
        'title': 'Equipment Repair',
        'category': 'Maintenance',
        'amount': '-Ksh 2,833', // Changed
        'date': '1 week ago',
        'icon': Icons.build,
        'color': Colors.red,
      },
    ];
    // --- End of Data Changes ---

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
                color: color.withOpacity(0.1),
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

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Transaction',
              style: Theme.of(context).textTheme.headlineSmall),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixText: 'Ksh ', // <-- Changed here
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: ['Seeds', 'Fertilizers', 'Labor', 'Equipment', 'Other']
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {},
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
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction added successfully!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}