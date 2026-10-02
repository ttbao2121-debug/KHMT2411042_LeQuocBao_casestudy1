import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/transaction_model.dart';

class AddEditScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddEditScreen({super.key, this.transaction});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  late bool _isExpense;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _noteController;
  late String _selectedCategory;

  final List<String> _categories = [
    'Ăn uống',
    'Di chuyển',
    'Thu nhập',
    'Mua sắm',
    'Giáo dục',
    'Hóa đơn',
    'Khác'
  ];

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _isExpense = tx == null ? true : (tx.type == 'expense');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toStringAsFixed(0) : '',
    );
    _dateController = TextEditingController(
      text: tx != null ? tx.date : '12/04/2025',
    );
    _noteController = TextEditingController(
      text: tx != null ? (tx.note ?? tx.title) : '',
    );
    _selectedCategory = tx != null ? tx.category : 'Ăn uống';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền')),
      );
      return;
    }

    final amount = double.tryParse(amountText.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
    final title = _noteController.text.trim().isNotEmpty 
        ? _noteController.text.trim() 
        : _selectedCategory;

    final tx = TransactionModel(
      id: widget.transaction?.id,
      title: title,
      amount: amount,
      date: _dateController.text.trim(),
      category: _selectedCategory,
      type: _isExpense ? 'expense' : 'income',
      note: _noteController.text.trim(),
    );

    if (widget.transaction != null) {
      await DatabaseHelper.instance.updateTransaction(tx);
    } else {
      await DatabaseHelper.instance.insertTransaction(tx);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final titleText = isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          titleText,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle: Chi tiêu / Thu nhập
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isExpense = true;
                          if (_selectedCategory == 'Thu nhập') {
                            _selectedCategory = 'Ăn uống';
                          }
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isExpense
                                ? const Color(0xFFFF5252)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Chi tiêu',
                            style: TextStyle(
                              color: _isExpense
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isExpense = false;
                          _selectedCategory = 'Thu nhập';
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !_isExpense
                                ? const Color(0xFFFF5252)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Thu nhập',
                            style: TextStyle(
                              color: !_isExpense
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Danh mục
              const Text(
                'Danh mục',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _categories.contains(_selectedCategory) ? _selectedCategory : _categories.first,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _isExpense ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                category == 'Thu nhập' ? Icons.work : Icons.category,
                                size: 16,
                                color: _isExpense ? const Color(0xFFFF5252) : const Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Số tiền
              const Text(
                'Số tiền',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập số tiền',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  suffixText: 'đ',
                  suffixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ngày giao dịch
              const Text(
                'Ngày giao dịch',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ghi chú
              const Text(
                'Ghi chú',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập ghi chú (tùy chọn)',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Nút Lưu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
